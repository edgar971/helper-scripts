#!/bin/bash

echo "Starting full backup"

# Variables
DESTINATION_DIR=//volume1/Backups
REMOTE_USER=backup
REMOTE_SERVER=server.com
REMOTE_PORT=22

echo "Backing up to: rsync://$REMOTE_USER@$REMOTE_SERVER:$REMOTE_PORT$DESTINATION_DIR"
# Add additional folders to the --include list
duplicity full --no-encryption --progress \
--include={/data,/etc,/var/www,/var/log/,/var/lib/docker/swarm,/root,/home,/usr/local} \
--exclude="**" / \
rsync://$REMOTE_USER@$REMOTE_SERVER:$REMOTE_PORT$DESTINATION_DIR

echo "Done with full backup"