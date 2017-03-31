#!/bin/bash

# Bash script to pull files from and SFTP and commit them to a repo. 

# Author: Edgar Pino <me@edgarpino.com>

# # # # # # # # # # # # # # # # # # # # # # #
#  Configuration and other variables        #
# # # # # # # # # # # # # # # # # # # # # # #

# Git config
REPO_NAME=''
REPO_SSH_URL=''
REPO_BRANCH=''
REPO_BACKUP_BRANCH="$REPO_BRANCH-snapshot"
# SFTP config
SFTP_SERVER=""
SFTP_USER=""
SFTP_PWD=""
SFTP_REMOTE_DIR=/path.to.site/www/

# Local config
LOCAL_DIR=$(PWD)/$SFTP_SERVER
LOCAL_REPO_DIR=$LOCAL_DIR/$REPO_NAME
DATE=`date +%Y-%m-%d:%I:%M:%S%p`

# # # # # # # # # # # # # # # # # # # # # # #
#  Main Script                              #                         
# # # # # # # # # # # # # # # # # # # # # # #


# Clone the repo if it doesn't exists
if [ ! -d "$LOCAL_REPO_DIR" ]; then

    echo "Cloning $REPO_SSH_URL into $LOCAL_REPO_DIR"
    git clone $REPO_SSH_URL $LOCAL_REPO_DIR
    git checkout $REPO_BRANCH
    cd "$LOCAL_REPO_DIR"

else

    # Fetch updates from the Git repo
    cd "$LOCAL_REPO_DIR"
    git reset --hard
    git clean -f -d
    git pull 
    git --no-pager log --decorate=short --pretty=oneline -n10

fi

# Create a snapshot of the exiting repo before making any commits and pulling files
if [ `git branch --list $REPO_BACKUP_BRANCH` ]; then
   
    git checkout $REPO_BACKUP_BRANCH && git merge --commit -m "snapshot branch update for $DATE sync" master && git push && git checkout $REPO_BRANCH

else 
    git checkout -b $REPO_BACKUP_BRANCH && git push --set-upstream origin $REPO_BACKUP_BRANCH && git checkout $REPO_BRANCH
fi


# Pull Server files
lftp sftp://$SFTP_USER:$SFTP_PWD@$SFTP_SERVER \
	-e "mirror -c --verbose=2  --exclude-rx-from=.gitignore --exclude='.*\.(revision)$' --parallel=10 --skip-noaccess $SFTP_REMOTE_DIR $LOCAL_REPO_DIR; bye"

# Commit and push
echo 'Committing the following changes:'

git status
git add .
git commit -m "Automatic sync commit from server for $DATE"
git push


# Exit, we are done
#######################################################################
exit 0