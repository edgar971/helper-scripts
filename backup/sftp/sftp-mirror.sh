#!/bin/bash

# Bash script used to sync sftp sites.

# Author: Edgar Pino <me@edgarpino.com>

# The lftp(http://lftp.tech/lftp-man.html) cli is used to mirror FTP and SFTP sites. 

# # # # # # # # # # # # # # # # # # # # # # #
# SFTP Configuration and other variables    #
# # # # # # # # # # # # # # # # # # # # # # #

CLIENT_NAME='edgar'
SFTP_SERVER="ftp.host.com"
SFTP_USER="user"
SFTP_PWD="password!!"

# Remote Directory to mirror
SFTP_REMOTE_DIR=/ 

# Local Directory to download files to
LOCAL_DIR=/path/to/local/directory/$CLIENT_NAME/$SFTP_USER

# This script backups up everything inside the remote server into the local directory. 
# This is a mirror sync so everything that is removed from the remote directory will be removed locally
# To exclude other file types or directories see the project documentation (http://lftp.tech/lftp-man.html). 
lftp sftp://$SFTP_USER:$SFTP_PWD@$SFTP_SERVER \
	-e "mirror -c --delete --verbose=2 --exclude='.*\.(zip|tar.gz|tar|log)$' --parallel=10 --skip-noaccess $SFTP_REMOTE_DIR $LOCAL_DIR; bye"

# Exit, we are done
#######################################################################
exit 0