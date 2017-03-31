# How to use the sftp-mirror.sh script

1. Clone the file. 
1. Update the following variables: 
```bash
CLIENT_NAME='edgar'
SFTP_SERVER="ftp.host.com"
SFTP_USER="user"
SFTP_PWD="password!!"

# Remote Directory to mirror
SFTP_REMOTE_DIR=/ 

# Local Directory to download files to
LOCAL_DIR=/path/to/local/directory/$CLIENT_NAME/$SFTP_USER
```
3. Add additional files to ignore
```bash
--exclude='.*\.(zip|tar.gz|tar|log)$'
```
4. Save the file and make it executable. 


