#!/bin/sh
set -e

cd /docs

if [ -d .git ]; then
    CURR_REMOTE=$(git remote show origin | grep 'Fetch URL' | sed -E 's/(.+: )//g')
    if [ $ACCESS_TOKEN ]; then
        CURR_REMOTE=$(echo "$CURR_REMOTE" | sed -E 's/(.+@)/<ACCESS_TOKEN>@/g');
    fi;
    echo "Existing repo https://$CURR_REMOTE";
    git pull;
else
    echo "DOC_REPO=$DOC_REPO";
    if [ $ACCESS_TOKEN ]; then
        echo "ACCESS_TOKEN set";
        git clone "https://$ACCESS_TOKEN@$DOC_REPO" .;
    else
        git clone "https://$DOC_REPO" .;
    fi;
fi;

mkdocs build -d /usr/share/nginx/html
nginx -g "daemon off;"