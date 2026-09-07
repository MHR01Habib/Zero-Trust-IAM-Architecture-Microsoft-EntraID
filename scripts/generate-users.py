"""
generate-users.py
Creates a fake list of 120 employees and saves it to employees.csv.
"""

import csv
import random

DOMAIN = "DetrovaMobility.onmicrosoft.com"
FIRST = ["Alex", "Kim", "Rachel", "Jacob", "Megan", "David", "Laura", "Kevin", "Emily", "Andrew"]
LAST = ["Morgan", "Sanders", "Clark", "Rivera", "Diaz", "Scott", "Reed", "Patel", "Ward", "Brooks"]

# Each department: how many people, and the job titles they can have.
DEPARTMENTS = {
    "Engineering": (30, ["Software Engineer", "QA Engineer", "DevOps Engineer"]),
    "Sales":       (26, ["Account Executive", "Sales Rep"]),
    "Marketing":   (18, ["Marketing Specialist", "Content Writer"]),
    "IT":          (16, ["IT Support", "Systems Admin"]),
    "Finance":     (16, ["Accountant", "Financial Analyst"]),
    "HR":          (13, ["Recruiter", "HR Generalist"]),
}

rows = []

# Go through each department and create that many employees.
for dept, (count, titles) in DEPARTMENTS.items():
    for i in range(count):
        first = random.choice(FIRST)
        last = random.choice(LAST)
        email = f"{first[0].lower()}{last.lower()}{i}@{DOMAIN}"  # number keeps emails unique
        rows.append([email, first, last, f"{first} {last}", random.choice(titles), dept, "US"])

# Save everyone to the CSV file.
with open("employees.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["UserPrincipalName", "FirstName", "LastName", "DisplayName", "JobTitle", "Department", "UsageLocation"])
    writer.writerows(rows)

print(f"Done! Created {len(rows)} employees.")
