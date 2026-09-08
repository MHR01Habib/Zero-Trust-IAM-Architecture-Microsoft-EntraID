# Walkthrough

A visual tour of the Detrova Mobility Zero Trust IAM lab, showing the key pieces I built and configured in Microsoft Entra ID.

---

### 1. Entra ID Tenant Overview

This is the Entra ID dashboard for Detrova Mobility. It shows the tenant with 123 users, 14 groups, and a Microsoft Entra ID P2 license.

![Tenant overview](01-tenant-overview.png)

---

### 2. Groups Overview

The Groups overview. Out of 14 total groups, 5 are dynamic, meaning they fill themselves automatically instead of being managed by hand.

![Groups overview](02-groups-overview.png)

---

### 3. The Five Dynamic Groups

The 5 dynamic security groups: Engineering, HR, IT, Marketing and Finance, and Sales. Each one is cloud-based and populates by department.

![Dynamic groups](03-dynamic-group.png)

---

### 4. How a Dynamic Group Fills Itself

This is the rule behind a dynamic group. Anyone whose department equals "Engineering" is added automatically, with no manual work.

![Dynamic membership rule](04-dynamic-rule.png)

---

### 5. Break Glass Admins

The Break Glass Admins group: 3 emergency accounts, excluded from all Conditional Access so a broken policy can never lock everyone out of the tenant.

![Break glass admins](05-break-glass-admins.png)
