###########################################
# Cloud Integration for NextGen Firewall F 
###########################################

$pathToCERfile = "P:\BarracudaFirewallHA\Barracuda\arm.cer"
$ADAppName = 'BarracudAFirewall'
# Set the resource group the Azure Route Table is in 
$resourceGroupName = 'rg-mgt-network'
# your subscription ID - the subscription ID must be entered with the dashes, as displayed by the Login-AzureRmAccount commandlet 
$subscriptionID = "/subscriptions/06abf061-195c-4641-b286-b71d7ab912c1"

# the identifier and role name must both be unique
$identifier = 'http://localhost'
$roleName = 'BarracudaNGADM Role'


# if required uncomment the following line to be prompted to log in 
Login-AzureRmAccount

#########################################################
# You should not have to change settings after this line 
#########################################################

# stop script on error 
$ErrorActionPreference = 'Stop'

#create custom role
$role = Get-AzureRmRoleDefinition "Virtual Machine Contributor"
$role.Id = $null
$role.Name = $roleName
$role.Description = "Barracuda NextGen Firewall Cloud Integration and UDR route rewriting"
$role.Actions.Clear()

# Add role definitions to the empty role 
$role.Actions.Add("Microsoft.Compute/virtualMachines/*")
$role.Actions.Add("Microsoft.Network/*")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add($subscriptionID)
$firewallRole = New-AzureRmRoleDefinition -Role $role

$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate($pathToCERfile)
# Extract the expiration date from the certificate. Must be valid at least one year
$endDate = [System.DateTime]::Parse($cert.GetExpirationDateString())

## subtract a day to ensure valid EndDate value
$validNumDays = 1
$timespan = New-TimeSpan -Days $validNumDays
$endDate = $endDate - $timespan

# convert the certificate to a base64 encoded string 
$key = [System.Convert]::ToBase64String($cert.GetRawCertData())

# Create the Azure AD Application 
$app = New-AzureRmADApplication -DisplayName $ADAppName -HomePage $identifier -IdentifierUris $identifier -CertValue $key -EndDate $endDate
Write-Host ('Application ID created')

#Create Azure AD Service Principal 
$princ = New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId -Verbose
Write-Host ('ServicePrincipalName created...')

Start-Sleep -Seconds 30

# if this step fails increase the Start-Sleep to 120 seconds or just execute the last command again after waiting a bit
New-AzureRmRoleAssignment -RoleDefinitionName $firewallRole.Name -ServicePrincipalName $princ.ServicePrincipalNames[0]

# Get the required IDs to configure the service on the firewall 
Write-Host ('Use the following information to configure Azure Cloud Integration on your NextGen Firewall F:')
Write-Host ('Subscription ID ''{0}''' -f (Get-AzureRmSubscription).Id)
Write-Host ('Tenant ID ''{0}''' -f (Get-AzureRmSubscription).TenantId)
Write-Host ('Application ID ''{0}''' -f $app.ApplicationId)