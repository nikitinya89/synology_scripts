#!/bin/bash

#set -Eeuo pipefail

echo "Enter group name:"
read group
echo "Enter Folder Path ( use \\\ for \\ ):"
read path
path2=$(echo "$path" | sed 's/\\/\//g')

#desc_folder="\\\YOUR_ADDRESS\\${path} (Read Folder Only)"
desc_readonly="\\\YOUR_ADDRESS\\${path} (Read Only)"
desc_modify="\\\YOUR_ADDRESS\\${path} (Modify)"
desc_fullcontrol="\\\YOUR_ADDRESS\\${path} (Full Control)"
desc_deny="\\\YOUR_ADDRESS\\${path} (Deny)"

#synogroup --add "$group"_Folder
#synogroup --descset "$group"_Folder "$desc_folder"

synogroup --add "$group"_ReadOnly
synogroup --descset "$group"_ReadOnly "$desc_readonly"

synogroup --add "$group"_Modify
synogroup --descset "$group"_Modify "$desc_modify"

synogroup --add "$group"_FullControl
synogroup --descset "$group"_FullControl "$desc_fullcontrol"

synogroup --add "$group"_Deny
synogroup --descset "$group"_Deny "$desc_deny"

#synogroup --memberadd "${group}_Folder" "${group}_ReadOnly"
#synogroup --memberadd "${group}_Folder" "${group}_Modify"
#synogroup --memberadd "${group}_Folder" "${group}_FullControl"


#synoacltool -add "/volume1/${path2}/" group:"${group}_Folder":allow:r-x---a-R-c--:---n
synoacltool -add "/volume1/${path2}/" group:"${group}_ReadOnly":allow:r-x---a-R-c--:fd--
synoacltool -add "/volume1/${path2}/" group:"${group}_Modify":allow:rwxp-DaARWc--:fd--
synoacltool -add "/volume1/${path2}/" group:"${group}_FullControl":allow:rwxpdDaARWcCo:fd--
synoacltool -add "/volume1/${path2}/" group:"${group}_Deny":deny:rwxpdDaARWcCo:fd--

cd "/volume1/${path2}/.."
if [ "$PWD" != "/volume1" ]
        then
                synoacltool -add "/volume1/${path2}/.." group:"${group}_ReadOnly":allow:r-x---a-R-c--:---n
                synoacltool -add "/volume1/${path2}/.." group:"${group}_Modify":allow:r-x---a-R-c--:---n
                synoacltool -add "/volume1/${path2}/.." group:"${group}_FullControl":allow:r-x---a-R-c--:---n
fi


#upper_folder_group=$(synoacltool -get "/volume1/${path2}/.." | grep -E -o 'group:.*_Folder' | grep -o '[^:]*$')
#synogroup --memberadd $upper_folder_group "${group}_Folder"
