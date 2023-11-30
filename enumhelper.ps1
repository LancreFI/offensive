<#
    AdEnumHelper.

    A small helper script to help in AD enumeration.
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$ldap_query,
	
	[Parameter(Mandatory=$false)]
	[string]$ldap_property = "l")

if ($ldap_query.ToUpper() -eq "HELP" -or $ldap_query.ToUpper() -eq "H")
{
  Write-Host "
<------------------------------------------------------------------------------------------------------->
 
 Usage: .\enumhelper.ps1 '<param1>' '<param2>'
 
  The '<param1>' is mandatory, if not defined will be prompted, '<param2>' optional.

<------------------------------------------------------------------------------------------------------->
  
  Using the parameters: '<param1>' == LDAP query, for example:
  .\enumhelper.ps1 '(&(SamAccountType=805306368)(name=p00p))'

  
  Using the optional: '<param2>' == 'L' to list all properties for the LDAP-response object
                      '<param2>' == 'property' to print only the chosen property's value
					  
  For example:
  .\enumhelper.ps1 '(&(SamAccountType=805306368)(name=p00p))' 'L'
  or
  .\enumhelper.ps1 '(&(SamAccountType=805306368)(name=p00p))' 'whencreated'  
  
<------------------------------------------------------------------------------------------------------->
  
  Also some other stuff can be done with '<param1>':
  '<param1>' == 'dcinfo'     -->  Prints out DC name, hostname, OS, OS version, IPv4 and IPv6
  '<param1>' == 'deviceinfo' -->  Prints out AD devices' info: Name, hostname, OS, OS SP, OS version, IPv4 and IPv6
  
  For example:
  .\enumhelper.ps1 'dcinfo'
  .\enumhelper.ps1 'deviceinfo'
  
<------------------------------------------------------------------------------------------------------->
  
  For reminder, the SamAccountTypes to query for, you need to use the decimal notation:
  #SAM_DOMAIN_OBJECT 0x0 ------------------------> 0
  #SAM_GROUP_OBJECT 0x10000000 ------------------> 268435456
  #SAM_NON_SECURITY_GROUP_OBJECT 0x10000001 -----> 268435457
  #SAM_ALIAS_OBJECT 0x20000000 ------------------> 536870912
  #SAM_NON_SECURITY_ALIAS_OBJECT 0x20000001 -----> 536870913
  #SAM_USER_OBJECT 0x30000000 -------------------> 805306368
  #SAM_NORMAL_USER_ACCOUNT 0x30000000 -----------> 805306368
  #SAM_MACHINE_ACCOUNT 0x30000001 ---------------> 805306369
  #SAM_TRUST_ACCOUNT 0x30000002 -----------------> 805306370
  #SAM_APP_BASIC_GROUP 0x40000000 ---------------> 1073741824
  #SAM_APP_QUERY_GROUP 0x40000001 ---------------> 1073741825
  #SAM_ACCOUNT_TYPE_MAX 0x7fffffff --------------> 2147483647

<------------------------------------------------------------------------------------------------------->
  "
  exit
}
elseif ($ldap_query.ToUpper() -eq "DCINFO")
{
	Get-ADDomainController -Filter * | Format-Table Name, Hostname, OperatingSystem, OperatingSystemVersion, IPv4Address, IPv6Address -Wrap -Auto
	exit
}
elseif ($ldap_query.ToUpper() -eq "DEVICEINFO")
{
	Get-ADComputer -Filter * -Property * `
	| Format-Table Name, DNSHostname, OperatingSystem, OperatingSystemServicePack, OperatingSystemVersion, IPv4Address, IPv6Address -Wrap -Auto	
	exit
}

function ldap_search {	
    $pdc = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
    $dn = ([adsi]'').distinguishedName
    $ldap_path = "LDAP://$pdc/$dn"
    $dir_entry = New-Object System.DirectoryServices.DirectoryEntry($ldap_path)
    $dir_searcher = New-Object System.DirectoryServices.DirectorySearcher($dir_entry, $ldap_query)	
	return $dir_searcher.FindAll()
}

$ldap_query_res = ldap_search

Write-Host ""
Write-Host "###--------------RESULTS--------------------###"
if ($ldap_property -eq "")
{
	return $ldap_query_res
}
elseif ($ldap_property.ToUpper() -eq "L")
{
	foreach ($query_object in $ldap_query_res)
	{
		Write-Host ""
		$query_object.properties
		Write-Host ""
		Write-Host "###-----------------------------------------###"
	}
}
else
{
	foreach ($query_object in $ldap_query_res) 
	{
		Write-Host ""
		$query_object.properties.item($ldap_property)
		Write-Host ""
		Write-Host "###-----------------------------------------###"
	}
}
