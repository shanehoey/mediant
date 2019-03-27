
# Recommended Installation Method

### Install the Mediant Module 
To install the Mediant module with PowerShellGet 

```powershell

Install-Module -Name mediant -Scope CurrentUser

```

![Installation](https://raw.githubusercontent.com/shanehoey/mediant/master/scripts/install.jpg)

### Update the Mediant Module 
To update the Mediant module with PowerShellGet 

```powershell

update-Module -Name mediant -Scope CurrentUser

```

### List Commands
List all commands in Mediant Module

```powershell

Get-Command -Module mediant

```

# Checking SSL Trust 
By default your computer may not trust the SSL certifcate on the Mediant Device, this command will check if your computer trusts the IP Phone SSL certificate

```powershell
test-MediantTrustCertPolicy -ipphone 172.16.18.131
```

if the  IP Phone is not trusted modify the trust cert policy (powershell core you use -skipcertificatecheck instead). Any changes are only valid for the current shell, if you close powershell the TrustAllCertPolicy will be reverted

```powershell

set-mediantTrustAllCertPolicy

```

# Example Usages

### Storing Mediant details in a JSON file 

The following example will store a number of Mediant details in a single json file. 

The following information is required in the json file 
 * __fqdn__ is the FQDN of your mediant device
 * __username__ is the username of the account you want to log in as in as
 * __password__ is the password of the User
 
#### Storing Password in JSON file
 If you are storing the password do not use cleartext instead use securestring and copy the resulting string into the json file. 
 
 `"mypassword" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString`
 
 The password is only valid when logged in as the same user/same password as it was created with.

#### Storing Clear Text Password in JSON file
Do Not do this! Storing passwords in a text file in clear text is a security risk, do not do this! 
If you must do this then use the -cleartext parameter.


#### JSON FILE
```json

[
  {
    "fqdn": "sbc1.directrouting.guide",
    "username": "Admin",
    "password": "gfdsgfljgifgwjirjeiwfvjjre"
  },
  {
    "fqdn": "sbc1.directrouting.guide",
    "username": "Admin",
    "password": "gfdsgfljgifgwjirjeiwfvjjre"
  }
]

```

#### Daily Check Script

NOTE:  This script is currently seperate to the module and you must download seperatly

[Link to Script](https://github.com/shanehoey/mediant/blob/master/scripts/dailychecks/invoke-dailychecks.ps1)


```powershell

./invoke-dailychecks.ps1 -subnet "172.16.18." -first 131 -last 132 -file .\PRIVATE-phones.json

```
