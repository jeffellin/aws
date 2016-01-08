#!/bin/bash
all_mfa=true
output=`aws iam list-users | jq -r '.Users[] | select(.PasswordLastUsed !=null) | .UserName'`

while read -r line ; do
    echo "Processing $line"
    mfa=`aws iam list-mfa-devices --user-name "$line" | jq '.MFADevices | length'`
    if [ "$mfa" == "0" ]; then
    	echo -e '\tNo MFA Device Found'
    	#aws iam  delete-login-profile --user-name "$line"
    	all_mfa=false
    fi
done <<< "$output"

if $all_mfa ; then
	exit 0
else
	exit 1
fi




