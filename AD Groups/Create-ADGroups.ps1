##New-AzureADMSGroup -Description “grp-prd-Subscription” -DisplayName “Subscription Owners” -MailEnabled $false -SecurityEnabled $true -MailNickname “grp-prd-Subscription” -GroupTypes “DynamicMembership” -MembershipRule “(user.GivenName -iq “”ADM””)” -MembershipRuleProcessingState “Paused”

Connect-AzureAD

New-AzureADGroup -Description “Subscription Owners” -DisplayName “grp-prd-Subscription” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"
New-AzureADGroup -Description “KayVault Admins” -DisplayName “grp-prd-KeyVault” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"


New-AzureADGroup -Description “Allows RDP to Prod IaaS Machines” -DisplayName “grp-prd-AllowRDPPRD” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"
New-AzureADGroup -Description “Allows RDP to Prod IaaS Machines” -DisplayName “grp-prd-AllowRDPMGT” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"

New-AzureADGroup -Description “Local Admin on IaaS PRD Servers” -DisplayName “grp-mgt-LocalAdmPRD” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"
New-AzureADGroup -Description “Local Admin on IaaS MGT Servers” -DisplayName “grp-mgt-LocalAdmPRD” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"



# NOT CREATED YET 



New-AzureADGroup -Description “Iaas Owners” -DisplayName “grp-mgt-IaaS” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"
New-AzureADGroup -Description “Network MGT Owners” -DisplayName “grp-mgt-Network” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"
New-AzureADGroup -Description “Network PRD Owners” -DisplayName “grp-prd-Network” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"

New-AzureADGroup -Description “Azure TemplateOwner” -DisplayName “grp-mgt-TemplateOwner” -MailEnabled $false -SecurityEnabled $true -MailNickName "notset"

