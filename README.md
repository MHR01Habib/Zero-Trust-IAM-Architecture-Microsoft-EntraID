# Zero Trust IAM Architecture: Microsoft Entra ID & Intune

A hands-on lab where I built a **simulated 120-employee enterprise** in Microsoft Entra ID and Intune to understand how identity and access flow at an enterprise level. The goal was to learn how a **single source of truth cascades** into access, security, and control across a real organization: from automated user provisioning, to Zero Trust Conditional Access, to just-in-time admin with PIM and device compliance with Intune.

> **Note:** This is a portfolio lab built entirely on free and trial licenses. The company, **Detrova Mobility** (a fictional Detroit-based EV company), and its 120 employees are simulated.

---

## What This Project Demonstrates

- **Automated user provisioning**: 120 users created from a CSV via PowerShell + Microsoft Graph, no manual entry
- **Attribute-driven access**: dynamic groups that assign membership automatically based on department
- **Zero Trust access controls**: Conditional Access enforcing MFA, phishing-resistant MFA, compliant devices, and geo-restrictions
- **Least-privilege administration**: just-in-time admin access with Privileged Identity Management (PIM)
- **Device security**: Intune compliance and configuration policies, enforced through Conditional Access
- **The cascade**: one source of truth (an employee record) flowing automatically into groups, file access, and security posture

---

## Tools & Licensing

| Tool | Purpose |
|------|---------|
| Microsoft Entra ID P2 (trial) | Users, dynamic groups, Conditional Access, PIM |
| Microsoft 365 Business Standard (trial) | SharePoint team sites |
| Microsoft Intune | Device compliance & configuration |
| Microsoft Graph + PowerShell | Bulk user provisioning |
| Python | Realistic employee data generation |

---

## Architecture Overview


**The core idea:** editing one field in the source data (adding a person, changing a department, removing someone) cascades automatically into group membership and access, with no manual grants anywhere.

---

## What I Built

### 1. Foundation
- Created a cloud-native Entra tenant and configured the organization (Detrova Mobility)
- Set up **two break-glass emergency admin accounts**, placed in a dedicated group and **excluded from all Conditional Access policies**, so a misconfigured rule can never lock the tenant out

### 2. Automated User Provisioning
- Generated a realistic `employees.csv` (120 employees, each with department, job title, and manager) using Python
- Wrote a **PowerShell script using Microsoft Graph** to create all 120 users and build the full manager hierarchy
- Key learning: personal/guest accounts can't create users via Graph (405 error), so provisioning must run under a proper cloud-native admin

### 3. Dynamic Groups (Attribute-Driven Access)
- Built **5 dynamic security groups** that populate automatically based on the `department` attribute
- Membership is evaluated on account creation **and** whenever a department changes, so access follows *who a person is*, not who remembered to grant it
- Marketing and Finance share one group via an `OR` rule

### 4. File Access (SharePoint)
- Created private SharePoint team sites for **Engineering** and **IT**, each scoped to its dynamic group
- Access flows straight from group membership, the same cascade extended to files

### 5. Zero Trust: Conditional Access
- **Require MFA** for all users (SMS disabled, vulnerable to SIM-swapping; app + passkey only)
- **Phishing-resistant MFA** for Engineering and IT, an added layer for the highest-risk teams, bound to the real site and device
- **Require compliant device**: reads the Intune compliance label and blocks non-compliant devices
- **Geo-restriction**: blocks sign-ins from outside the US, with an "Approved International Travelers" exclusion group for approved business trips

### 6. Least-Privilege Admin: PIM
- Configured **Privileged Identity Management** so admin roles are off by default and requested just-in-time
- Made a user **eligible** for Helpdesk Administrator (request password-reset rights only when needed)
- Built an **authentication context** (a label that forces MFA) and attached it to PIM roles, so activating admin access requires fresh verification

### 7. Device Management: Intune
- **Compliance policy**: the "health checklist" (BitLocker, antivirus, firewall, Defender, etc.); labels devices compliant or not
- **Configuration policies (paired):** a UAC credential prompt for installs, plus removal of local admin rights, because UAC alone is defeated if the user is already a local admin. Together they close the gap.
- Enforcement note: **Intune decides, Conditional Access enforces**, Intune labels the device and Conditional Access acts on the label

---

## Key Design Principles

- **Single source of truth**: employee data drives everything downstream
- **Least privilege**: people (and admins) get only the access they need, only when they need it
- **Defense in depth**: identity, device, and network checks layered together
- **Fail-safe**: break-glass accounts ensure a broken policy never causes a full lockout

---

## Repository Contents

> **Security note:** No real secrets are committed. The provisioning script uses a placeholder temporary password and forces a reset on first sign-in. Sensitive values should always be stored in a secret manager, never in source control.

---

## What I Learned

This project taught me how the pieces of an enterprise identity system fit together, not just how to click through each feature, but *why* each control exists and how they reinforce one another. The biggest takeaway is that good IAM is about **automation and flow**: when identity is the source of truth, access becomes something that follows a person automatically, securely, and consistently, instead of something granted by hand and forgotten.

