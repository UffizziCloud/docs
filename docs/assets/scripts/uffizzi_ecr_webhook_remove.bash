#!/bin/bash

export NAME="uffizzi-webhook-ecr-image-push"

aws events remove-targets --rule $NAME --ids $NAME

aws iam delete-role-policy --role-name $NAME --policy-name $NAME

aws iam delete-role --role-name $NAME

aws events delete-rule --name $NAME

aws events delete-api-destination --name $NAME

aws events delete-connection --name $NAME
