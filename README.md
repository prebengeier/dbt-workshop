# 🦆 dbt + DuckDB Workshop 

En praktisk steg-for-steg-guide som viser hvordan du bygger et komplett **dbt-prosjekt** på **DuckDB**, med automatisert CI/CD i **GitHub Actions** og isolerte PR-miljøer. Perfekt for både nybegynnere og erfarne som vil ha en lettvekts data stack uten server.

---

## 🚀 Mål med workshopen

- Lære grunnleggende dbt-modellering
- Koble dbt mot DuckDB lokalt
- Bygge CI/CD med GitHub Actions (Slim CI med `state:modified+`)
- Opprette midlertidige databaser for hver PR
- Dele opp produksjon, test og utvikling med enkel versjonering

---

## 🧩 Forutsetninger

Installer følgende:

- **Python** 3.9–3.12
- **DuckDB** (CLI valgfritt)
- **git** og **GitHub**
- **VS Code** (anbefalt)
- **duckdb CLI (https://duckdb.org/install/?platform=windows&environment=cli)**
- **Github CLI**


Installer dbt med DuckDB-adapter:

```bash
python -m venv .venv
source .venv/bin/activate           # Windows: .venv\Scripts\activate
pip install --upgrade pip
pip install -r dbt-requirements.txt
winget install --id GitHub.cli -e
```

---

## 🗂️ Prosjektstruktur

```text
dbt-workshop/
 ├─ models/
 │  ├─ staging/
 │  ├─ marts/
 │  └─ sources.yml
 ├─ seeds/
 ├─ snapshots/
 ├─ warehouse/
 │  └─ dev.duckdb/
 │  └─ test.duckdb/
 │  └─ prod.duckdb/
 ├─ macros/
 ├─ tests/
 ├─ dbt_project.yml
 ├─ profiles.example.yml
 ├─ packages.yml
 ├─ dbt-requirements.txt
 └─ .github/workflows/
    ├─ ci.yml
    ├─ cd.yml
    └─ ci_teardown.yml
```

### Eksempel på `profiles.example.yml`

```yaml
workshop_duckdb:
  target: dev
  outputs:

    dev:
      type: duckdb
      path: ./warehouse/dev.duckdb
      schema: analytics_dev
      threads: 4
      extensions: [httpfs]
      external_root: ./external

    test:
      type: duckdb
      path: ./warehouse/test.duckdb      
      schema: analytics_test
      threads: 4
      extensions: [httpfs]
      external_root: ./external
      attach:
        - path: ./warehouse/prod.duckdb   
          alias: prod

    prod:
      type: duckdb
      path: ./warehouse/prod.duckdb
      schema: analytics
      threads: 8
      extensions: [httpfs]
      external_root: ./external

```

---

## Lokal kjøring

```bash
dbt deps 
dbt seed --target dev/test/prod
dbt build --target dev/test/prod
dbt snapshot --target dev/test/prod

export DBT_DUCKDB_PATH=./warehouse/dev.duckdb
dbt deps && dbt seed && dbt build --target dev

export DBT_DUCKDB_PATH=./warehouse/pr_999__local.duckdb
dbt build -s 'state:modified+' --state ./state --target pr --vars "schema_id: pr_999__local"
```

---

## 🔁 CI/CD med GitHub Actions

### CI – `ci.yml`
Kjøres ved **pull requests** til `main`.

- Installerer dbt og avhengigheter
- Laster ned siste manifest for Slim CI (hvis finnes)
- Kjører `dbt build -s 'state:modified+'`
- Laster opp artefakter (manifest, DuckDB-fil)

### CD – `cd.yml`
Kjøres ved **push til main**.

- Kjører dbt-build for produksjon
- Bruker forrige manifest for kun endrede modeller
- Laster opp nytt manifest for neste runde

### CI Teardown – `ci_teardown.yml`
Kjøres når en PR **lukkes eller merges**.

- Sletter DuckDB-filer for PR-miljøer
- Logger opprydding i Actions-loggen

---

## Slim CI (state:modified+)

Slim CI bygger kun endrede modeller.

```bash
dbt build -s 'state:modified+' --defer --state ./
```

Hvis ingen `manifest.json` finnes, kjøres full bygging.

dbt build --target pr --vars "schema_id: 99"

schema_id kan være navn på branchen  

---

## Lage en ny branch og deretter teste CI/CD 
```bash
git checkout -b test
git push -u origin test
gh pr create --fill --base main --head test
```

