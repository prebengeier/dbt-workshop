# dbt-workshop

## Overview

### 1. Continuous Integration (CI) Workflow - `ci.yml`

**Trigger:** Pull requests to the `main` branch

**Purpose:** Tests dbt changes in isolated schemas before merging

**Steps:**

1. **Setup: Install dbt and dependencies**
```yaml
- name: Install dbt
  run: pip install -r dbt-requirements.txt
```
*Installs dbt-snowflake and other required packages*

2. **Download Manifest: Get latest production manifest for state comparison**
```yaml
- name: Download latest manifest artifact
  shell: bash
  run: |
    curl -s -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
        "https://api.github.com/repos/${{ github.repository }}/actions/artifacts" \
        -o artifacts.json
    artifact_id=$(grep -A20 '"name": "dbt-manifest"' artifacts.json | grep '"id":' | head -n1 | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
    curl -sL -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
        "https://api.github.com/repos/${{ github.repository }}/actions/artifacts/$artifact_id/zip" \
        -o artifact.zip
    unzip -q artifact.zip -d state
```
*Downloads the latest production manifest to enable state comparison and Slim CI*

3. **Generate Schema: Create unique schema using PR number and commit SHA**
```yaml
- name: Generate schema ID
  run: echo "SCHEMA_ID=${{ github.event.pull_request.number }}__${{ github.sha }}" >> $GITHUB_ENV
```
*Creates unique schema name like `pr_123__abc123def456` to isolate PR testing*

4. **Run Tests: Execute dbt build with state comparison (only modified models)**
```yaml
- name: Run dbt build
  run: |
    if [ -f "./state/manifest.json" ]; then
      cp ./state/manifest.json ./manifest.json
      dbt build -s 'state:modified+' --defer --state ./ --target pr --vars "schema_id: $SCHEMA_ID"
    else
      dbt build --target pr --vars "schema_id: $SCHEMA_ID"
    fi
```
*Uses Slim CI to only build modified models, deferring unchanged models to production*

5. **Cleanup: Remove temporary files**
```yaml
- name: Cleanup
  run: rm -rf state/ artifact.zip artifacts.json
```
*Removes downloaded artifacts and temporary files*

### 2. Continuous Deployment (CD) Workflow - `cd.yml`

**Trigger:** Pushes to the `main` branch

**Purpose:** Deploys tested changes to production environment

**Steps:**

1. **Setup: Install dbt and dependencies**
```yaml
- name: Install dbt
  run: pip install -r dbt-requirements.txt
```
*Installs dbt-snowflake and other required packages*

2. **Download Manifest: Get previous deployment manifest for incremental builds**
```yaml
- name: Download latest manifest artifact
  shell: bash
  run: |
    curl -s -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
        "https://api.github.com/repos/${{ github.repository }}/actions/artifacts" \
        -o artifacts.json
    artifact_id=$(grep -A20 '"name": "dbt-manifest"' artifacts.json | grep '"id":' | head -n1 | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
    curl -sL -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
        "https://api.github.com/repos/${{ github.repository }}/actions/artifacts/$artifact_id/zip" \
        -o artifact.zip
    unzip -q artifact.zip -d state
```
*Downloads the previous production manifest to enable incremental deployment*

3. **Deploy: Run dbt build with state comparison (only changed models)**
```yaml
- name: Deploy to production
  run: |
    if [ -f "./state/manifest.json" ]; then
      cp ./state/manifest.json ./manifest.json
      dbt build -s 'state:modified+' --state ./ --target prod
    else
      dbt build --target prod
    fi
```
*Deploys only modified models and dependencies to production using state comparison*

4. **Upload Artifact: Save new manifest for future deployments**
```yaml
- name: Upload new manifest artifact
  uses: actions/upload-artifact@v4
  with:
    name: dbt-manifest
    path: ./target/manifest.json
    retention-days: 7
```
*Saves the new production manifest for future incremental deployments*

### 3. CI Teardown Workflow - `ci_teardown.yml`

**Trigger:** Pull request closure (merged, closed, or abandoned)

**Purpose:** Automatically cleans up temporary CI schemas

**Steps:**

1. **Setup: Install dbt and dependencies**
```yaml
- name: Install dbt
  run: pip install -r dbt-requirements.txt
```
*Installs dbt-snowflake and other required packages*

2. **Cleanup: Drop all schemas created for the specific PR**
```yaml
- name: Cleanup PR schemas
  run: |
    dbt run-operation drop_pr_schemas \
      --target pr \
      --args '{"database": "'"$SNOWFLAKE_DATABASE"'", "schema_prefix": "pr", "pr_number": "'"$PR_NUM"'"}'
```
*Drops all temporary schemas created during PR testing to free up resources*

3. **Logging: Record cleanup operations and results**
```yaml
- name: Log cleanup results
  run: echo "✅ Cleanup completed for PR #$PR_NUM"
```
*Records successful cleanup completion for audit purposes*

## Using Other Platforms

The workflows in this repository are designed for Snowflake but can be easily adapted for other dbt-supported platforms. Here's what you need to change:

1. **Update dbt Requirements** - Replace `dbt-snowflake` with your platform's adapter (e.g., `dbt-bigquery`, `dbt-postgres`, `dbt-redshift`, `dbt-databricks`)

2. **Update Environment Variables** - Change the environment variables according to your data platform's connection requirements

3. **Update profiles.yml** - Modify your profiles configuration to use the new environment variables and platform type

4. **Update Cleanup Operations** - Modify the cleanup macro to work with your platform's resource management approach

The core CI/CD logic remains the same - only the connection details and resource management need to be updated for your specific platform.

