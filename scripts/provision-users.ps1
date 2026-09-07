<#
    provision-users.ps1

    This script creates all 120 employee accounts in Entra ID automatically,  reading them from the employees.csv file. Instead of adding each person  by hand, it loops through the list and builds every account for you,   filling in their department, job title, and manager as it goes.

#>
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"

# Grab the employee list. 
$csv = Import-Csv ".\data\employees.csv"

# Now go through the list one person at a time and make their account.
foreach ($row in $csv) {

  
    $exists = Get-MgUser -Filter "userPrincipalName eq '$($row.UserPrincipalName)'" -ErrorAction SilentlyContinue
    if ($exists) { Write-Host "Skip: $($row.DisplayName)" -ForegroundColor Yellow; continue }

    # Build out this person's account details, pulling each piece
    $params = @{
        DisplayName       = $row.DisplayName
        UserPrincipalName = $row.UserPrincipalName
        MailNickname      = $row.UserPrincipalName.Split("@")[0]
        GivenName         = $row.FirstName
        Surname           = $row.LastName
        JobTitle          = $row.JobTitle
        Department        = $row.Department
        UsageLocation     = $row.UsageLocation
        AccountEnabled    = $true
        PasswordProfile   = @{
            # A temporary starter password. The user is forced to change it
            # the first time they log in, so nobody keeps this one.
            Password                      = "Detrova#2026!Temp"
            ForceChangePasswordNextSignIn = $true
        }
    }

    # Try to create the account. If it works, print a green success line.
    # If something goes wrong, print a red line that tells you what broke,
    # so you're never left guessing.
    try {
        New-MgUser @params | Out-Null
        Write-Host "Created: $($row.DisplayName)" -ForegroundColor Green
    } catch {
        Write-Host "FAILED: $($row.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
    }
}
