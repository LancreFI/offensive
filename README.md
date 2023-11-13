# offensive
Tips and tricks etc.

#BackdoorPlug.php
A WordPres plugin containing reverse shell. Prerequirements: you need access to the WP to upload and activate plugins.
Just change the host/port to whatever your listener is running on and maybe adjust the shell accordingly too, then just zip it, upload the zip as a plugin and activate the plugin to get connected with the WP-instance.

reverse_shell.aspx is not my creation, the credit goes to INSOMNIA SECURITY :: InsomniaShell.aspx, brett.moore@insomniasec.com ::  www.insomniasec.com

#winbin.sh
Whip up custom executables on the fly. So far only supports creating a x64 executable for adding a defined user with a defined password to the Administrators group. For example if you need to replace a bin which you have full control over to gain further foothold.
