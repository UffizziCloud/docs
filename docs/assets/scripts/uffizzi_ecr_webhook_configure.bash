#!/bin/bash

export NAME="uffizzi-webhook-ecr-image-push"

aws events create-connection --name $NAME --authorization-type API_KEY --auth-parameters '{ "ApiKeyAuthParameters": { "ApiKeyName": "AWS_PRIVATE_KEY", "ApiKeyValue": "test" } }'

export CONNECTION_ARN=`aws events describe-connection --name $NAME --query ConnectionArn --output text`

aws events create-api-destination --name $NAME --connection-arn $CONNECTION_ARN --invocation-endpoint https://app.uffizzi.com/api/v1/webhooks/amazon --http-method POST

export API_DESTINATION_ARN=`aws events describe-api-destination --name $NAME --query ApiDestinationArn --output text`

aws events put-rule --name $NAME --state ENABLED --event-pattern '{ "source": ["aws.ecr"], "detail-type": ["ECR Image Action"], "detail": { "action-type": ["PUSH"], "result": ["SUCCESS"] } }'

aws iam create-role --role-name $NAME --path '/service-role/' --assume-role-policy-document '{ "Version": "2012-10-17", "Statement": [{ "Effect": "Allow", "Principal": { "Service": "events.amazonaws.com" }, "Action": "sts:AssumeRole" }] }'

export ROLE_ARN=`aws iam get-role --role-name $NAME --query 'Role.Arn' --output text`

aws iam put-role-policy --role-name $NAME --policy-name $NAME --policy-document '{ "Version": "2012-10-17", "Statement": [{ "Effect": "Allow", "Action": "events:*", "Resource": "*" }] }'

aws events put-targets --rule $NAME --targets "[{ \"Id\": \"$NAME\", \"Arn\": \"$API_DESTINATION_ARN\", \"RoleArn\": \"$ROLE_ARN\", \"HttpParameters\": { \"PathParameterValues\": [], \"HeaderParameters\": {}, \"QueryStringParameters\": {} } }]"
