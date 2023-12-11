<#
    AdEnumHelper.

    A small helper script to help in AD enumeration.
#>
#Parameters
param (
	[Parameter(Mandatory=$true)]
    	[string]$param1,
	
	[Parameter(Mandatory=$false)]
	[string]$param2 = "l",
	
	[Parameter(Mandatory=$false)]
	[string]$param3,
	
	[Parameter(Mandatory=$false)]
	[string]$param4,
	
	[Parameter(Mandatory=$false)]
	[string]$param5)

#Script help
if ($param1.ToUpper() -eq "HELP" -or $param1.ToUpper() -eq "H")
{
  Write-Host "
<------------------------------------------------------------------------------------------------------->
  
 Usage: .\enumhelper.ps1 '<param1>' '<param2>' '<param3>' '<param4>' '<param5>'
  
  The '<param1>' is mandatory, if not defined will be prompted, the rest are optional.
 
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
  
  Also some other stuff can be done with '<param1>':
  '<param1>' == 'spnlist'    -->  Prints out all SPNs and related objects
  '<param1>' == 'dcinfo'     -->  Prints out DC name, hostname, OS, OS version, IPv4 and IPv6
  '<param1>' == 'deviceinfo' -->  Prints out AD devices' info: Name, hostname, OS, OS SP, OS version, 
                                  IPv4 and IPv6
  
  For example:
  .\enumhelper.ps1 'spnlist'
  .\enumhelper.ps1 'dcinfo'
  .\enumhelper.ps1 'deviceinfo'
 
<------------------------------------------------------------------------------------------------------->
 
  Leveraging further with '<param2>':
  '<param1>' == 'spncheck' '<param2>' == 'account' -->  Check if any SPNs (services) are tied to a 
                                                        (service)account
  '<param1>' == 'checksid' '<param2>' == 'SID'     -->  Return the AD user / group info by SID, can be 
                                                        used to convert a SID to name for example
  '<param1>' == 'findsid'  '<param2>' == 'SID'     -->  Look through the whole AD for a SID match if you
                                                        don't know the object type (=user/group/etc)
  
  For example:
  .\enumhelper.ps1 'spncheck' 'sql_service'
  .\enumhelper.ps1 'checksid' 'S-1-5-21-809893099-1472282828-2400958209-1105'
  .\enumhelper.ps1 'findsid' 'S-1-5-21-809893099-1472282828-2400958209-1105'
 
<------------------------------------------------------------------------------------------------------->
 
  And then there's '<param3>' which can be used to do user/pass queries against the AD:
  '<param1>' == 'auth' '<param2>' == 'username'  '<param3>' == 'password'
  
  For example:
  .\enumhelper.ps1 'auth' 'megaAdmin' 'verySecurePassword'
 
<------------------------------------------------------------------------------------------------------->
 
  With some additional parameters '<param4>' and '<param5>' we can try to run remote commands over WMI:
  '<param1>' == 'wmi' '<param2>' == 'username'  '<param3>' == 'password'  '<param4>' == target IP
  '<param5>' == remote command to run
  
  For example:
  .\enumhelper.ps1 'wmi' 'username' 'password' '192.168.12.34' 'cmd'
  !NOTE: you can just run with 'wmi' and the rest will be prompted, if you don't want to plaintext the
         password on commandline.
  
<------------------------------------------------------------------------------------------------------->
 
  " -BackgroundColor Green -ForegroundColor Black
  exit
}
elseif ($param1.ToUpper() -eq "WMI")
{
	if ($param2 -ne "1" -and $param2 -and $param3)
	{
		$username = $param2
		$insecure_password = $param3
		$password = ConvertTo-SecureString $insecure_password -AsPlaintext -Force
		$computer = $param4
		$command = $param5
	}
	else
	{
		while (-not $username -or -not $password -or -not $computer -or -not $command)
		{
			$username = Read-Host -prompt 'Username: '
			$password = Read-Host -prompt 'Password: ' -AsSecureString
			$computer = Read-Host -prompt 'Target IP: '
			$command = Read-Host -prompt 'Command to run: '
		}
	}
	Write-Host ""
	Write-Host "###--------------WMIC-RUN--------------------###" -ForegroundColor Yellow
	Write-Host ""
	try
	{
		$credential = New-Object System.Management.Automation.PSCredential $username, $password
		$options = New-CimSessionOption -Protocol DCOM -ErrorAction stop
		$params = @{'ComputerName'=$computer
			'Credential'=$credential
            		'SessionOption'=$options
            		'ErrorAction'='Stop'}
		$session = New-CimSession @params
	}
	catch [Microsoft.Management.Infrastructure.CimException]
	{
		if ($_.Exception.Message -like '*Access*Denied*')
		{
			Write-Host "Invalid credentials!" -ForegroundColor Red
		}
		elseif ($_.Exception.Message -like '*RPC*server*unavailable*')
		{
			Write-Host "The host is unreachable: $computer" -ForegroundColor Red
		}
		elseif ($_.Exception.Message -like '*your*domain*isn*t*available*')
		{
			Write-Host "Domain unreachable, is the DC down?!" -ForegroundColor Red
		}
		else
		{
			$_.Exception.Message
		}
	}
	try
	{
		Invoke-CimMethod -CimSession $session -ClassName Win32_Process -MethodName Create `
		-Arguments @{CommandLine=$Command}
	}
	catch [System.Management.Automation.ParameterBindingException]
	{
		Write-Host "Cim-Session failed!" -ForeGroundColor Red
	}
	Write-Host ""
	exit
}
#Check the info for the DC
elseif ($param1.ToUpper() -eq "DCINFO")
{
	Get-ADDomainController -Filter * | Format-Table Name, Hostname, OperatingSystem, OperatingSystemVersion, IPv4Address, IPv6Address -Wrap -Auto
	exit
}
#Check the info for computers tied to the AD
elseif ($param1.ToUpper() -eq "DEVICEINFO")
{
	Get-ADComputer -Filter * -Property * `
	| Format-Table Name, DNSHostname, OperatingSystem, OperatingSystemServicePack, OperatingSystemVersion, IPv4Address, IPv6Address -Wrap -Auto	
	exit
}
#Check SPN ties for account defined as the second parameter on commandline
elseif ($param1.ToUpper() -eq "CHECKSPN")
{
	if ($param2.ToUpper() -ne "L")
	{
		setspn -L $param2
	}
	else
	{
		Write-Host 'Check the service account name!' -ForegroundColor Red
	}
	exit
}
#Convert SID to user/group
elseif ($param1.ToUpper() -eq "CHECKSID" -or $param1.ToUpper() -eq "FINDSID")
{
	if ($param2.ToUpper() -ne "L")
	{
		if ($param1.ToUpper() -eq "FINDSID")
		{
			$result = Get-ADObject -IncludeDeletedObjects -Filter "objectSid -eq '$param2'"|select Name,ObjectClass
			if (-not $result)
			{
				Write-Host 'Nothing matching that SID in AD' -ForegroundColor Red
			}
			else
			{	
				$result	
			}
		}
		else
		{
			Write-Host ''
			Write-Host '----CHECKING FROM USERS----'  -ForegroundColor Yellow
			try{
				Get-ADUser -Identity $param2
			}
			catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
			{
				Write-Host 'The SID was not found from the AD users!' -ForegroundColor Red
			}
			Write-Host '' 
			Write-Host '----CHECKING FROM GROUPS----'  -ForegroundColor Yellow
			try{
				Get-ADGroup -Identity $param2
			}
			catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
			{
				Write-Host 'The SID was not found from AD members!' -ForegroundColor Red
			}
			Write-Host ''
		}
	}
	else
	{
		Write-Host 'Recheck the SID!' -ForegroundColor Red
	}
	exit
}

#LDAP-search  function
function ldap_search {	
    $pdc = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
    $dn = ([ADSI]'').distinguishedName
    $ldap_path = "LDAP://$pdc/$dn"
    if ($param1.ToUpper() -eq "AUTH")
	{
		$ldap_login_res = New-Object System.DirectoryServices.DirectoryEntry($ldap_path, $param2, $param3)
		if (-not $ldap_login_res.DistinguishedName)
		{
			return $false
		}
		else
		{
			return $true
		}
	}
	elseif ($param1.ToUpper() -eq "SPNLIST")
	{
		$spn_search = New-Object DirectoryServices.DirectorySearcher([ADSI]"")
		$spn_search.filter = "(servicePrincipalName=*)"
		$spn_search_res = $spn_search.Findall()
		return $spn_search_res
	}
	else
	{
		$dir_entry = New-Object System.DirectoryServices.DirectoryEntry($ldap_path)
		$dir_searcher = New-Object System.DirectoryServices.DirectorySearcher($dir_entry, $param1)	
		return $dir_searcher.FindAll()
	}
}

$param1_res = ldap_search

#Print the LDAP-query results based on the paramaters from commandline
Write-Host ""
Write-Host "###--------------RESULTS--------------------###" -ForegroundColor Yellow
Write-Host ""
#Full query
if ($param2 -eq "" -or $param1.ToUpper() -eq "AUTH")
{
	if ($param1_res)
	{
		Write-Host 'Credentials match ('$param2' / '$param3' )' -ForegroundColor Green
		Write-Host ""
	}
	elseif (-not $param1_res)
	{
		Write-Host 'Credentials do not match ('$param2' / '$param3' )' -ForegroundColor Red
		Write-Host ""
	}
	else
	{
		return $param1_res
	}
}
elseif ($param1.ToUpper() -eq "SPNLIST")
{
	foreach( $result in $param1_res )
	{
		$userEntry = $result.GetDirectoryEntry()
		Write-host "Object Name =  "	$userEntry.name -ForeGroundColor "black" -BackgroundColor "gray"
		Write-host "DN          =  "	$userEntry.distinguishedName -ForeGroundColor "black" -BackgroundColor "gray"
		Write-host "Object Cat. =  " $userEntry.objectCategory -ForeGroundColor "black" -BackgroundColor "gray"
		Write-host "servicePrincipalNames" -ForeGroundColor "black"
		$i=1
		foreach( $SPN in $userEntry.servicePrincipalName ) 
		{
			Write-host "SPN ${i} = $SPN" -ForeGroundColor "red" -BackgroundColor "gray"
			$i+=1
		}
		Write-host ""
	}
}
#List properties for the queried object
elseif ($param2.ToUpper() -eq "L")
{
	foreach ($query_object in $param1_res)
	{
		Write-Host ""
		$query_object.properties
		Write-Host ""
		Write-Host "###-----------------------------------------###"  -ForegroundColor Yellow
	}
}
#List the queried objects values for a specific item
else
{
	foreach ($query_object in $param1_res) 
	{
		Write-Host ""
		$query_object.properties.item($param2)
		Write-Host ""
		Write-Host "###-----------------------------------------###" -ForegroundColor Yellow
	}
}
