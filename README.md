### <b>offensive</b><br/>
Tips and tricks etc. for offensive<br/>
<br/>
<b>BackdoorPlug.php</b><br/>
A WordPres plugin containing reverse shell. <br/>
Prerequirements: you need access to the WP to upload and activate plugins.<br/>
Just change the host/port to whatever your listener is running on and maybe adjust the shell accordingly too, then just zip it, upload the zip as a plugin and activate the plugin to get connected with the WP-instance.<br/>
<br/>
<b>checklist</b><br/>
A very basic list of pentest steps.<br/>
<br/>
<b>dorks.google</b><br/>
Some random Google dorks to leverage while enriching your case data<br/>
<br/>
<b>enumhelper.ps1</b><br/>
A helper script for AD enumeration and lateral movement. Built on-the-go so might contain a lot of logical fallacies and missing lots of error checks.<br/>
Check the help section before running: .\enumhelper.ps1 "help" for somewhat of instructions.<br/>
Can do: <br/>
  - LDAP queries<br/>
  - User/pass testing over LDAP-query<br/>
  - List all properties of LDAP response object<br/>
  - Get the value of a specific LDAP property<br/>
  - Get all SPNs and related objects<br/>
  - Check if any SPNs are tied to a (service)account<br/>
  - Get DC info: name, hostname, OS, OS version, IPv4 and IPv6<br/>
  - Get AD device info: name, hostname, OS, OS SP, OS version, IPv4 and IPv6<br/>
  - Get AD user/group info by SID (converting a SID to a name for example)<br/>
  - Create PsExec.exe or PsExec64.exe<br/>
  - SID lookup from AD<br/>
  - DCOM lateral movement leveraging MMC<br/>
    - Also the possibility of building a reverse-shell command and initiating it on the target<br/>
  - Remote connectiong over PowerShell<br/>
  - Remote commands over WMI, WINRS, PsExec or PsExec64:<br/>
    - Also the possibility of building a reverse-shell command and initiating it on the target<br/>
<br/>
<b>nix-shell-tricks</b><br/>
Common tips and tricks etc. to use in Linux shell when being offensive or otherwise enumerating<br/>
<br/>
<b>php-trickery</b><br/>
Some PHP-tricks for offensive security<br/>
<br/>
<b>reverse_shell.aspx</b><br/>
Not my creation, credit goes to INSOMNIA SECURITY :: InsomniaShell.aspx, brett.moore@insomniasec.com ::  www.insomniasec.com<br/>
<br/>
<b>winbin.sh</b><br/>
Whip up custom executable/dll on the fly. So far only supports creating a x64 executable/dll for adding a defined user with a defined password to the Administrators group or changing an existing user's password. <br/>
For example if you need to replace a bin which you have full control over to gain further foothold or to leverage a missing DLL etc.<br/>
<br/>
<b>windows-shell-tricks-and-ad-tips</b><br/>
Common tips and tricks etc. to use with PowerShell / cmd when being offensive or otherwise enumerating and getting to know AD<br/>
