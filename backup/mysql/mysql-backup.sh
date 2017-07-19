#!/bin/bash

DATE=`date +%Y-%m-%d-%I%p`
NAME="$DATE-database.sql.gz"
BK_LOCATION="./"


ssh user@ip mysqldump --all-databases -u user -p123 -h localhost |  gzip -9 > $NAME