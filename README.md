# pa-simple-wf

A minimal **Nextflow DSL2** workflow for **BIOL7210** that satisfies the required sequential and parallel structure:

- **Sequential:** `SRA (optional) -> fastp`
- **Parallel after fastp:** `skesa` and `seqkit`

This repo is intentionally simple so it is easy to explain, run, and grade.

---

## Workflow diagram

![workflow diagram](assets/workflow_diagram.png)

---

## What the pipeline does

1. **Fetch raw paired-end reads from SRA** with `fasterq-dump` (optional for real runs)
2. **Clean reads** with `fastp`
3. From the cleaned reads, run two jobs **in parallel**
   - **Assemble** with `skesa`
   - **Summarize read statistics** with `seqkit stats`

---

## Why this satisfies the assignment

- Uses **genomics software**
- Includes **sequential processing**: fetch/input -> fastp
- Includes **parallel processing**: fastp output is sent to skesa **and** seqkit at the same time
- Runs **locally** by default
- Includes **test data in the repo**
- Uses **Conda through Nextflow** so users do **not** need to pre-install each tool manually

---

## Repo structure

```text
pa-simple-wf/
├── main.nf
├── nextflow.config
├── modules/
│   ├── fetch_sra.nf
│   ├── fastp.nf
│   ├── skesa.nf
│   └── seqkit_stats.nf
├── assets/
│   ├── test_samplesheet.csv
│   └── workflow_diagram.png
├── test_data/
│   ├── PAmini_R1.fastq.gz
│   └── PAmini_R2.fastq.gz
├── scripts/
│   └── report_versions.sh
└── README.md
```

---

## Requirements

Fill in this section with the exact output from `scripts/report_versions.sh` before submission.

- **Nextflow version used:** replace with output of `scripts/report_versions.sh`
- **Package manager and version:** replace with output of `scripts/report_versions.sh`
- **OS used:** replace with output of `scripts/report_versions.sh`
- **Architecture used:** replace with output of `scripts/report_versions.sh`

Example helper command:

```bash
bash scripts/report_versions.sh
```

Also note your profile when submitting. For example, I recommend:

- Package manager: **Conda**
- Nextflow profile: **`-profile test,conda`** for the built-in test

---

## Quick test run (3 commands)

After Nextflow itself is installed, the grader should be able to copy/paste these **3 commands**:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
nextflow run main.nf -profile test,conda
```

This uses the tiny paired-end test reads in `test_data/` through `assets/test_samplesheet.csv`.

---

## Expected outputs

Inside `results/`:

- `01_sra/` (only for real SRA runs)
- `02_fastp/`
  - cleaned FASTQ files
  - fastp HTML report
  - fastp JSON report
- `03_skesa/`
  - assembled FASTA
- `04_seqkit/`
  - read stats text file
- automatic Nextflow run files:
  - `pipeline_trace.txt`
  - `pipeline_report.html`
  - `pipeline_timeline.html`
  - `pipeline_dag.html`

---

## Running on real SRA accessions

Example:

```bash
nextflow run main.nf -profile conda --sra_ids 'SRR000001,SRR000002'
```

If you only want to run one sample:

```bash
nextflow run main.nf -profile conda --sra_ids 'SRR000001'
```

---

## Notes for your GitHub submission

- Keep this repo public or accessible to your instructor.
- In the README, explicitly say this repo is for **BIOL7210**.
- Make sure your commit history is under your GitHub username.
- Before submitting, run `bash scripts/report_versions.sh` and paste the exact versions into the README.

---

## Simple explanation of the logic

The important design choice is that **fastp is the center of the workflow**:

- raw reads go **into fastp**
- cleaned reads come **out of fastp**
- those cleaned reads are then sent to:
  - **skesa** for assembly
  - **seqkit** for statistics

That gives you the required **one sequential step** and **one parallel fork** with the least possible complexity.
