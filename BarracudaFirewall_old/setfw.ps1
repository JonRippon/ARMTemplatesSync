Test-AzureStaticVNetIP -VNetName vnet-mgt-network -IPAddress 172.26.84.193

$staticVM = Get-AzureVM -ServiceName pip-mgtfwl01 -Name aznesmgtfwl01

Set-AzureStaticVNetIP -VM $staticVM -IPAddress 172.26.84.193 | Update-AzureVM