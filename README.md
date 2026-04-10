# Adhiambo — Product Paper
### CIS Compliance & Infrastructure Hardening Engine
**Version:** 0.1 - Internal Working Draft
**Status:** In Development

---

## 1. Executive Summary

Adhiambo is an automated compliance and infrastructure hardening engine designed to perform deep CIS (Center for Internet Security) benchmark checks across technologies hosted in enterprise cloud environments that fall outside the reach of conventional enterprise scanners.

The solution closes a critical visibility gap affecting internal product teams whose deployments do not conform to standard operating procedures and reside on cloud infrastructure that existing organisational scanners cannot interrogate. Beyond its internal mandate, Adhiambo is positioned as a value-added capability that can be offered to external clients during Vulnerability Assessment and Penetration Testing (VAPT) engagements.

---

## 2. Problem Statement

### 2.1 Background

In an agile organization, product teams operate with a degree of autonomy that promotes speed and innovation. A consequence of this autonomy, however, is that not all products adhere to the established Standard Operating Procedure (SOP) for infrastructure provisioning and management. Specifically:

- **Non-standard deployments** — Several products are hosted on enterprise cloud environments that deviate from the organisation's approved infrastructure baseline.
- **Scanner blind spots** — The organisation's current suite of security scanners lacks the capability to assess environments outside the standard footprint, leaving these deployments unaudited and potentially non-compliant.
- **Compliance debt accumulation** — Without regular, automated checks, infrastructure drift goes undetected, creating compounding compliance and security risk over time.
- **Inconsistent hardening posture** — The absence of a unified compliance check mechanism means that security hardening levels vary significantly across teams, with no reliable way to measure or report on the aggregate posture.

### 2.2 Consequence of Inaction

Leaving these environments unscanned exposes an organisation to:

- Regulatory and audit risk where infrastructure cannot be evidenced as compliant.
- Elevated attack surface due to misconfigured or unhardened systems.
- Reputational risk in the event of a breach originating from an unmonitored asset.
- Inability to provide evidence-based assurance to leadership or external auditors on the security posture of products.

---

## 3. Solution Overview

Adhiambo performs automated, targeted compliance assessments against the **CIS Benchmarks** — a globally recognised set of security configuration standards — across the technology stacks used by internal teams and external client environments.

The engine is designed to be:

- **Environment-agnostic** — capable of running checks against cloud-hosted infrastructure regardless of the cloud provider or configuration model.
- **Technology-aware** — built to recognise and assess the specific technologies in use across teams, rather than applying a one-size-fits-all scanner.
- **Actionable** — producing prioritised, human-readable reports that map findings directly to CIS controls and recommended remediation steps.
- **Extensible** — structured so that new technology checks can be added as the organisation's stack evolves or as new client engagements demand coverage of additional platforms.

---

## 4. Goals and Objectives

| Goal | Description |
|------|-------------|
| **Close the scanner gap** | Provide compliance visibility into cloud environments that existing enterprise scanners cannot reach. |
| **Enforce CIS standards** | Systematically check infrastructure configurations against CIS Benchmarks and surface deviations. |
| **Enable self-service hardening** | Equip engineering teams with actionable reports they can act on without waiting for a centralised security review. |
| **Support VAPT engagements** | Package compliance checks as an add-on service for external client engagements, enhancing the value of VAPT deliverables. |

---

## 5. Scope

### 5.1 In Scope

- The five confirmed v1 technology stacks: Ubuntu 24.04 LTS, Rocky Linux, PostgreSQL, Docker, and Kubernetes.
- CIS Benchmark controls applicable to the identified technology stacks.
- External client environments during VAPT engagements, where client consent and rules of engagement permit.

### 5.2 Out of Scope (Current Phase)

- Real-time continuous monitoring (targeted for a future iteration).
- Auto-remediation of identified findings.
- Environments covered by existing enterprise scanner tooling — Adhiambo is a complement, not a replacement.

---

## 6. Technical Approach

### 6.1 Assessment Methodology

Adhiambo follows a structured assessment flow:

```
Target Environment Discovery
        │
        ▼
Technology Stack Identification
        │
        ▼
CIS Benchmark Mapping
        │
        ▼
Automated Compliance Checks
        │
        ▼
Finding Classification & Scoring
        │
        ▼
Report Generation
```

### 6.2 CIS Benchmark Coverage

Checks are aligned to the CIS Benchmark framework, which classifies controls into two implementation levels:

- **Level 1** — Essential, foundational security configurations with minimal operational impact. These are the baseline and are applied by default.
- **Level 2** — Defence-in-depth configurations intended for high-security environments. Applied where the environment warrants a more stringent posture.

Each check produces a result of **Pass**, **Fail**, or **Not Applicable**, along with the specific CIS control ID, a description of the finding, and a remediation recommendation.

### 6.3 Technology Coverage — v1

The following five technologies constitute the confirmed scope for Adhiambo v1. Coverage was determined based on the technology audit conducted across internal environments.

| Technology | Category | CIS Benchmark |
|------------|----------|---------------|
| **Ubuntu 24.04 LTS** | Operating System | CIS Ubuntu Linux 24.04 LTS Benchmark |
| **Rocky Linux** | Operating System | CIS Rocky Linux Benchmark |
| **PostgreSQL** | Database | CIS PostgreSQL Benchmark |
| **Docker** | Container Runtime | CIS Docker Benchmark |
| **Kubernetes** | Container Orchestration | CIS Kubernetes Benchmark |

**Rationale for v1 scope:**

- **Ubuntu 24.04 LTS & Rocky Linux** — The two primary operating systems in use across multiple deployments. Both are well-supported by CIS Benchmarks and represent the largest surface area for OS-level misconfiguration.
- **PostgreSQL** — The predominant database engine across internal products. Database hardening is a high-priority control domain given the sensitivity of data typically stored at this layer.
- **Docker & Kubernetes** — Container workloads form the backbone of deployment architectures. CIS Benchmarks for both Docker (runtime) and Kubernetes (orchestration) address a broad set of controls including image security, runtime privileges, network policies, RBAC, and secrets management.


### 6.5 Invocation Model

Adhiambo v1 is a **Bash-based CLI tool**. Bash was chosen deliberately — the overwhelming majority of technologies in scope run on Linux servers, making Bash a native, dependency-free execution environment that requires no runtime installation on the target system.

The v1 workflow is intentionally manual and follows two steps:

**Step 1 — Deploy:** The operator transfers the Adhiambo script bundle to the target server via SSH (or the relevant authentication method available for that environment).

```bash
scp -r adhiambo/ user@target-host:/opt/adhiambo/
```

**Step 2 — Invoke:** The operator SSH's into the server and manually calls the scan script, specifying the target technology and desired scan level.

```bash
ssh user@target-host
cd /opt/adhiambo
bash adhiambo.sh --tech ubuntu --level 2
```

Each Engine script also supports a `--help` flag that prints usage information, available options, defaults, and examples, then exits without running any checks. This is intended as a quick field reference for operators.

```bash
bash engine/docker.sh --help
```

If an Engine script is invoked with no arguments, it runs with defaults — Level 1 scan, no image, and technology-appropriate defaults for any optional parameters. This keeps the tool low-friction for first-time runs and buy-in demonstrations.

This manual invocation model is appropriate for v1 given the nature of the environments being assessed. Automated scheduling and remote execution are candidates for a future version.

### 6.6 Access & Connectivity Model

Since Adhiambo is deployed directly onto the target server, it does not require inbound network access or a dedicated scanning user on a separate host. The operator needs only:

| Requirement | Detail |
|-------------|--------|
| **SSH access** | Ability to SCP the script bundle onto the target server and SSH in to invoke it. |
| **Execution permissions** | The invoking user must have sufficient privileges to run the Researcher and Engine components — typically a user with `sudo` access for OS-level checks, or the relevant service account for database and container checks. |
| **Credential handling** | No credentials are stored within Adhiambo. Any service-level credentials required (e.g. for PostgreSQL checks) are passed at invocation time and are not persisted. |

For VAPT engagements, access provisioning, credential handling, and teardown are governed by the Rules of Engagement template (see Section 7.2).

### 6.4 Reporting

Each Engine script produces structured findings that are passed to the Reporter. Every finding contains four fields, which map directly to the columns in all three output formats:

| Column | Description |
|--------|-------------|
| **Check Name** | The short identifier for the CIS control being evaluated. |
| **Description** | A plain-language explanation of what the check is testing and why it matters. |
| **Status** | The result of the check: `PASS`, `FAIL`, `N/A`, `SKIPPED`, or `MANUAL_REVIEW`. |
| **Remediation** | The specific action required to resolve a failing check. For `SKIPPED` checks, contains the reason the check was not run. For `MANUAL_REVIEW` checks, contains the captured command output. Empty for PASS and N/A results. |

The Reporter generates output in three formats from a single findings input: **CSV** (for data processing and import into other tools), **JSON** (for programmatic consumption and integration), and **TXT** (for human-readable review and documentation).

### 6.5 Console Output

In addition to the three file-based report formats, each Engine script streams live output to the console as checks execute. This provides real-time visibility into scan progress, supports debugging, and allows the operator to identify where a scan is stalling without waiting for the final report.

The console output has three layers:

**Section headers** — printed before each group of checks to visually separate the CIS benchmark sections as the scan progresses.

**Per-check status lines** — printed as each check completes. The format is consistent across all Engine scripts:

```
[PASS]           2.1   Ensure network traffic is restricted between containers
[FAIL]           2.2   Ensure logging level is set to info
[MANUAL_REVIEW]  2.6   Ensure TLS authentication for Docker daemon is configured
[SKIPPED: No image provided]  4.1  Ensure a user for the container has been created
```

**Manual review blocks** — for checks that cannot be fully automated (`MANUAL_REVIEW`), the relevant command output is collected during the section and printed as a block at the end of that section, before the next section begins. This keeps the per-check output readable while ensuring the operator can review raw output in context. The same output is also written to the Remediation column of the CSV report.

**Scan summary block** — after all checks have run, a summary block is printed to the console showing the total count of each status across the entire scan, along with the path to the generated report file. The summary block appears in the console only and is not written to any report file.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SCAN SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PASS             18
  FAIL              5
  MANUAL_REVIEW     3
  SKIPPED           4
  N/A               2
  ──────────────────
  TOTAL            32

  Report saved to: adhiambo_docker_2026-04-10T1143.csv
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 6.7 Tool Architecture

Adhiambo is structured as three discrete components that execute in sequence. This separation of concerns keeps each component focused, testable, and independently maintainable.

```
┌─────────────────────────────────────────────────────┐
│                  adhiambo.sh (entrypoint)            │
└──────────────┬──────────────────────────────────────┘
               │
               ▼
┌──────────────────────────┐
│       RESEARCHER         │  Discovers what technologies are running
│  researcher.sh           │  on the instance and passes context to
│                          │  the Engine.
└──────────────┬───────────┘
               │
               ▼
┌──────────────────────────┐
│         ENGINE           │  Technology-specific scan scripts.
│  engine/ubuntu.sh        │  Each script runs the CIS checks for
│  engine/rocky.sh         │  its technology at the requested level
│  engine/postgresql.sh    │  and outputs structured findings.
│  engine/docker.sh        │
│  engine/kubernetes.sh    │
└──────────────┬───────────┘
               │
               ▼
┌──────────────────────────┐
│        REPORTER          │  Consumes findings from the Engine and
│  reporter.sh             │  generates output in CSV, JSON, and TXT.
└──────────────────────────┘
```

**Researcher** — Interrogates the instance to determine which supported technologies are present and running. Its output informs which Engine scripts are invoked, preventing irrelevant checks from running and enabling future auto-detection of scope.

**Engine** — A collection of technology-specific Bash scripts, one per supported technology. Each Engine script is self-contained and implements the CIS checks for its technology at the level specified by the operator. Adding support for a new technology in future versions means adding a new Engine script without modifying the rest of the tool.

**Reporter** — Consumes the structured findings output by the Engine and produces the final reports in all three formats (CSV, JSON, TXT) from a single findings input, ensuring consistency across all outputs.



---

## 7. v1 Deliverables

The following defines what Adhiambo v1 will produce. These deliverables collectively constitute the definition of done for v1.

### 7.1 Tool Deliverables

**1. Adhiambo Bash Script Bundle**

A deployable set of Bash scripts structured around the three-component architecture (Researcher, Engine, Reporter). The bundle is self-contained and designed to be dropped onto a target Linux server via SSH and invoked manually.

**2. CIS Check Library — v1**

A validated set of CIS Benchmark checks covering all five v1 technologies, organised by scan level. Each check is peer-reviewed before inclusion in the library.

Checks are broken into three scan levels:

| Level | Description |
|-------|-------------|
| **Level 1** | Essential, foundational CIS controls with minimal operational impact. The default baseline — applicable to all environments. |
| **Level 2** | Defence-in-depth CIS controls for environments requiring a more stringent posture. Builds on Level 1. |

**3. Report Output — Three Formats**

The Reporter produces findings in three formats from every scan:

| Format | Primary Use |
|--------|-------------|
| **CSV** | Data processing, import into spreadsheets or other tooling, further analysis. |
| **JSON** | Programmatic consumption, integration with other systems, future tooling. |
| **TXT** | Human-readable review, documentation, inclusion in assessment reports. |

Every finding across all three formats contains the same four fields:

| Column | Description |
|--------|-------------|
| **Check Name** | Short identifier for the CIS control being evaluated. |
| **Description** | Plain-language explanation of what the check tests and why it matters. |
| **Status** | `PASS`, `FAIL`, `N/A`, `SKIPPED`, or `MANUAL_REVIEW`. |
| **Remediation** | The specific action to resolve a failing check. For `SKIPPED` checks, contains the reason the check was not run. For `MANUAL_REVIEW` checks, contains the captured command output. Blank for `PASS` and `N/A` results. |

**4. Console Output**

Each Engine script streams live output to the console as checks execute. The console output includes section headers, a per-check status line for every check as it completes, manual review blocks at the end of each section for checks requiring operator review, and a scan summary block at the end of the run. The summary block is console-only and is not written to any report file. See Section 6.5 for the full console output specification.

### 7.2 Process & Engagement Deliverables

| Deliverable | Description |
|-------------|-------------|
| **Access & Permissions Framework** | A documented process for safely provisioning the access needed to deploy and run Adhiambo on a target server, including a teardown checklist for post-assessment cleanup. |
| **VAPT Rules of Engagement (RoE) Template** | A template formalising how Adhiambo is scoped and deployed during external VAPT engagements, covering client consent, credential handling, and deliverable expectations. |

### 7.3 v1 Success Criteria

v1 is considered complete when:

- All five technology Engine scripts are built, peer-reviewed, and functional for Level 1 and Level 2.
- Each Engine script runs with sensible defaults when invoked with no arguments.
- Each Engine script produces correct help output when invoked with `--help`.
- The Researcher correctly identifies running technologies on a target instance.
- The Reporter successfully generates CSV, JSON, and TXT output from Engine findings.
- All four report columns (Check Name, Description, Status, Remediation) are consistently populated across all formats.
- Console output streams correctly during scan execution, including section headers, per-check status lines, manual review blocks, and the scan summary block.
- The Access & Permissions Framework and VAPT RoE Template are documented and approved.



---

## 8. Use Cases

### 8.1 Internal — Product Team Compliance Audits

Engineering and security teams can invoke Adhiambo against a team's environment to get a point-in-time compliance posture assessment. The output supports:

- Pre-production hardening before a product goes live.
- Periodic compliance reviews as part of a security programme.
- Evidence generation for internal audits and risk reviews.

### 8.2 Internal — Leadership Visibility

Leadership can use aggregated Adhiambo outputs to understand the compliance posture across all teams, track improvement over time, and make informed decisions about where to direct remediation effort and investment.

### 8.3 External — VAPT Value Addition

During client VAPT engagements, Adhiambo can be offered as an additional deliverable. Rather than returning only penetration test findings, the team can also provide:

- A CIS Benchmark compliance report covering the client's infrastructure.
- Hardening recommendations that go beyond identified vulnerabilities.
- A differentiated, higher-value engagement compared to standard VAPT offerings.

This positions the organisation as a comprehensive security partner rather than a point-in-time tester.

---

## 9. Value Proposition

### For Engineering & Security Teams
- Immediate, actionable visibility into compliance gaps that were previously invisible.
- Self-service capability reduces dependency on centralised security reviews.
- Clear remediation guidance mapped to industry-standard benchmarks.

### For Leadership
- Quantified, evidence-based view of the organisation's security posture across internal products.
- Demonstrates a proactive, standards-aligned approach to infrastructure security.
- Supports audit readiness and reduces the risk of compliance-related findings during external reviews.

### For External Clients (VAPT)
- Adds a compliance dimension to security assessments that clients increasingly expect.
- Provides a structured, internationally recognised framework (CIS) for understanding their hardening posture.
- Increases the overall value and stickiness of the organisation's VAPT service offering.


---

## 10. Glossary

| Term | Definition |
|------|------------|
| **CLI** | Command-Line Interface — a text-based interface used to interact with a software tool by typing commands. |
| **RoE** | Rules of Engagement — a documented agreement defining the scope, methods, and boundaries of a security assessment. |
| **CIS** | Center for Internet Security — a non-profit that publishes internationally recognised security benchmarks and best practices. |
| **CIS Benchmark** | A set of configuration guidelines developed by CIS to help organisations secure their systems against known attack patterns. |
| **VAPT** | Vulnerability Assessment and Penetration Testing — a security assessment methodology that identifies and validates vulnerabilities in a target environment. |
| **SOP** | Standard Operating Procedure — the organisation's established baseline for how infrastructure should be provisioned and managed. |
| **Infrastructure Hardening** | The process of reducing a system's attack surface by applying security configurations and removing unnecessary functionality. |
| **SKIPPED** | A check result status indicating the check was not run. The reason is recorded in the Remediation field (e.g. a required tool is not installed, or a required parameter was not provided). |
| **MANUAL_REVIEW** | A check result status indicating the check cannot be fully automated. The relevant command output is captured and provided to the operator for manual assessment. |

---

*This document is a living product paper and will be updated as Adhiambo progresses through development. All feedback should be directed to the issues tab.*