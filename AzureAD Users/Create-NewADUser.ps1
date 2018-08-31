#Service Accounts


$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "uLidIonVisRA!!"


New-AzureADUser -DisplayName "svc-StartStop" -PasswordProfile $PasswordProfile -UserPrincipalName "svc-StartStop@claazure.com" -AccountEnabled $true -MailNickName "svc-StartStop" 
New-AzureADUser -DisplayName "svc-IaaSConfig" -PasswordProfile $PasswordProfile -UserPrincipalName "svc-IaaSConfig@claazure.com" -AccountEnabled $true -MailNickName "svc-IaaSConfig"
New-AzureADUser -DisplayName "svc-DomainJoin" -PasswordProfile $PasswordProfile -UserPrincipalName "svc-DomainJoin@claazure.com" -AccountEnabled $true -MailNickName "svc-DomainJoin"

Set-MsolUser -UserPrincipalName svc-BarracudaFW@claazure.com -PasswordNeverExpires $true
Set-MsolUser -UserPrincipalName svc-StartStop@claazure.com -PasswordNeverExpires $true
Set-MsolUser -UserPrincipalName svc-IaaSConfig@claazure.com -PasswordNeverExpires $true
Set-MsolUser -UserPrincipalName svc-DomainJoin@claazure.com -PasswordNeverExpires $true 

Connect-MsolService

Set-MsolUserPrincipalName -UserPrincipalName "svc-StartStop@DarwinNest.onmicrosoft.com" -NewUserPrincipalName "svc-StartStop@Pension-Nest.Net"
Set-MsolUserPrincipalName -UserPrincipalName "svc-DomainJoin@DarwinNest.onmicrosoft.com" -NewUserPrincipalName "svc-DomainJoin@Pension-Nest.Net"
Set-MsolUserPrincipalName -UserPrincipalName "svc-IaaSConfig@DarwinNest.onmicrosoft.com" -NewUserPrincipalName "svc-IaaSConfigp@Pension-Nest.Net"
