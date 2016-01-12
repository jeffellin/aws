#!/bin/bash
all_mfa=true
output=`aws iam list-users | jq -r '.Users[] | .UserName'`

while read -r line ; do
    echo "$line"

    
    mfa=`aws iam list-mfa-devices --user-name "$line" | jq '.MFADevices | length'`
    if [ "$mfa" == "0" ]; then
    	
    	if aws iam get-login-profile --user-name "$line" > /dev/null 2>&1 ; then
    		 echo  -e '\tNo MFA Device Found'
    	         aws iam  delete-login-profile --user-name "$line"
    		 all_mfa=false
    	fi 
    fi
done <<< "$output"

if $all_mfa ; then
	exit 0
else
	exit 1
fi
