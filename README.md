# 🦆 dbt + DuckDB Workshop (Norsk versjon)

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

Installer dbt med DuckDB-adapter:

```bash
python -m venv .venv
source .venv/bin/activate           # Windows: .venv\Scripts\activate
pip install --upgrade pip
pip install dbt-duckdb dbt-utils
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
duckdb:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "{{ env_var('DBT_DUCKDB_PATH', 'local.duckdb') }}"
      schema: main
      threads: 4
```

---

## ⚙️ Lokal kjøring

```bash
export DBT_DUCKDB_PATH=local.duckdb   # Windows: set DBT_DUCKDB_PATH=local.duckdb

dbt deps
dbt seed
dbt build
dbt snapshot
duckdb local.duckdb -c "select * from marts.fct_orders limit 5;"
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

> 💡 **Tips:** Hver PR får sin egen `.duckdb`-fil — ingen database-server trengs. Bare slett filen for å rydde opp.

---

## 🧠 Slim CI (state:modified+)

Slim CI bygger kun endrede modeller.

```bash
dbt build -s 'state:modified+' --defer --state ./
```

Hvis ingen `manifest.json` finnes, kjøres full bygging.

---


## Workshop-oppgaver

1️⃣ **Kjør lokalt (30 min)** – bygg, seed, snapshot

2️⃣ **Legg til feiltest (20 min)** – endre CSV slik at test feiler

3️⃣ **Lag ny modell (30 min)** – bygg en aggregert `int_daily_revenue.sql`

4️⃣ **Snapshot (20 min)** – endre e-post og se historikk

5️⃣ **PR CI (40 min)** – åpne PR, CI kjører isolert DuckDB-fil

6️⃣ **CD (30 min)** – merge til main, bygg prod og last opp manifest

7️⃣ **Teardown (10 min)** – lukk PR, slett midlertidige filer

---

## 🧹 Feilsøking

| Problem | Løsning |
|----------|----------|
| `jq: Cannot iterate over null` | Ingen artefakter ennå – første bygg kjører full run |
| `404 Not Found` for artefakter | Gamle eller utløpte artefakter slettet av GitHub |
| PR fra fork feiler | Forks har ikke tilgang til artefakter fra hovedrepo |
| Ingen Slim CI-effekt | Sjekk at `manifest.json` finnes i `./` og `--state ./` brukes |

---

## 🔧 Videre forbedringer

- Generer **dbt docs** og publiser via GitHub Pages
- Legg til **SQL-linting** med `sqlfluff`
- Legg inn **pytest** for makrotesting
- Integrer **testdekning** i CI/CD

---

## 🧾 Hurtigreferanse

```bash
# Lokal utvikling
export DBT_DUCKDB_PATH=local.duckdb
dbt deps && dbt seed && dbt build && dbt snapshot

# Slim CI lokalt
dbt build -s 'state:modified+' --defer --state ./

# Rydd opp PR-db-filer
dbt run-operation drop_pr_dbs --args '{"glob_pattern": "ci/pr_123__*.duckdb"}'
```

---

🎉 **Gratulerer!** Du har nå et komplett oppsett for dbt + DuckDB, med moderne CI/CD og produksjonslignende miljøer – alt lokalt og gratis.

