#!/bin/bash

base64 -d <<< "H4sIAAAAAAAAA51QWwoDMQj8zyn87MLCXKBHWZgeZA9fHY0EtvRliDHz0JBhHTTSvo1P0tf0kNO9
vHEzqCxgto260cpIKXMsL1pvxjWS4win3x7Q6duOAsRnzYl2BqYWPXrVRs1O6SOGtNMD00QB1WBZ
y22/23tt0DMVo588yD0QP2Mr7RRZrVC0c1kTJ8/W2kUrXT7e2qdpyGf9F7+axxNy4kDqlQIAAA==" | gunzip

# Detect package manager
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [ "apt" = ${osInfo[$f]} ] ; then
        PKGFLG=1
    fi
done

if [ $PKGFLG -eq 1 ]
then
echo "Monkey can smell debian or debian variant distro."
echo "--------------------------------------------------------------------------------------"

read -p 'Enter Github user name: ' GITHUB_USERNAME
read -sp 'Enter Github access token: ' GITHUB_TOKEN
echo " "
read -p 'Enter Gitea user name: ' GITEA_USERNAME
read -sp 'Enter Gitea access token: ' GITEA_TOKEN
echo " "

echo ""Monkey starting his wrenching....................""
echo "--------------------------------------------------------------------------------------"

#Initailze variables
GITEA_DOMAIN=localhost:3000
GITEA_REPO_OWNER=$GITEA_USERNAME

# Install packages
apt update
apt install -y curl git jq sed

GET_REPOS=$(curl -u $GITHUB_USERNAME:$GITHUB_TOKEN  https://api.github.com/user/repos?visibility=all | jq -r '.[].html_url')

for URL in $GET_REPOS; do

    REPO_NAME=$(echo $URL | sed 's|https://github.com/'$GITHUB_USERNAME'/||g')

    echo "Found $REPO_NAME, importing..."

    curl -X POST "http://$GITEA_DOMAIN/api/v1/repos/migrate" -u $GITEA_USERNAME:$GITEA_TOKEN -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \
    \"auth_username\": \"$GITHUB_USERNAME\", \
    \"auth_token\": \"$GITHUB_TOKEN\", \
    \"clone_addr\": \"$URL\", \
    \"mirror\": true, \
    \"private\": true, \
    \"repo_name\": \"$REPO_NAME\", \
    \"repo_owner\": \"$GITEA_REPO_OWNER\", \
    \"service\": \"git\", \
    \"uid\": 0, \
    \"wiki\": true}" 

done

echo "--------------------------------------------------------------------------------------"
echo " >>> Mirroring from Github to Gitea is completed. <<< "
echo "--------------------------------------------------------------------------------------"

#--------------------------------------------------------------------------------------------
else
echo "Monkey can't smell debian or debian variant distro. Monkey is hoping to grow up for handle other distros too."
fi