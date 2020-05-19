#!/bin/bash

# We need this script to fix up permissions for files that have been uploaded
# outside the normal framework e.g. upload to a public share, then moved to
# a protected share via the console, or files that have been scp'ed up.

# parse the arguments

main_user='rob'
location_shares='/sharedfolders'



if [ $# -eq 0 ]; then
        shares="data-01 media cryptVault" # <== change these to your shared folders
else
        shares=$*
fi

# fix permissions for the specified shares
for share in $shares; do
        echo "`date "+%Y-%m-%d %H:%M:%S"` | Fixing permissions for `echo $share | tr "[:lower:]" "[:upper:]"`..."
        dir=`readlink -e $location_shares/$share`
        chmod g+s "$dir"
        chown -R root:users "$dir"
        if [ "$share" == "public" ]; then
                chmod -R 770 "$dir"
        elif [ "$share" == "cryptVault" ]; then
                chmod -R 750 "$dir"
                setfacl --recursive --modify user:"$main_user":rwx --modify mask:rwx "$dir"
                chmod -R 700 "$dir/luks"
                find "$dir/luks" -type f -exec chmod 400 {} \;
                setfacl --recursive --modify user:"$main_user":rwx --modify mask:rwx "$dir/luks"
                find "$dir/luks" -type f -exec setfacl --modify user:"$main_user":r --modify mask:r {} \;
        else
                chmod -R 750 "$dir"
                setfacl --recursive --modify user:"$main_user":rwx --modify mask:rwx "$dir"
        fi
done
echo "`date "+%Y-%m-%d %H:%M:%S"` | All done."
echo

