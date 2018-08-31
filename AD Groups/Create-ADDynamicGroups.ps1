Connect-AzureAd 

#User Dynamic Azure AD Groups

New-AzureADMSGroup -DisplayName "grp-mgt-ServiceAccounts" -Description "Dynamic Group with Service Accounts" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.userPrincipalName -contains ""svc"")" -MembershipRuleProcessingState "On"
New-AzureADMSGroup -DisplayName "grp-mgt-Advanced" -Description "Dynamic Group for Advanced" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.userPrincipalName -contains ""adm"")" -MembershipRuleProcessingState "On"
New-AzureADMSGroup -DisplayName "grp-mgt-TestUsers" -Description "Dynamic Group for TestUsers" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.userPrincipalName -contains ""Test"")" -MembershipRuleProcessingState "On"




#Computer Dynamic Azure AD Groups

New-AzureADMSGroup -DisplayName "grp-mgt-ServiceAccounts" -Description "Dynamic Group with Service Accounts" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.userPrincipalName -contains ""svc"")" -MembershipRuleProcessingState "On"


New-AzureADMSGroup -DisplayName "grp-mgt-PRDSrv" -Description "Dynamic Group for PRD Servers" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.userPrincipalName -contains ""svc"")" -MembershipRuleProcessingState "On"
