#!/bin/bash
####################################
#
# Backup required files to backup
# location to be synced off server.
#
# TODO:
# - allow postgres user to be editable
# - check for previous backups/retention
# - add ability to send files to remote server
####################################
# setup
path="/tmp"
dest="${path}/backup"

sql_path="${dest}/sql"
redis_path="${dest}/redis"
file_path="${dest}/files"

live_path="/home/mastodon/live"
redis_file="/var/lib/redis/dump.rdb"
####################################
# Start
####################################

# Print end status message.
echo
echo "Backup starting"
date

mkdir {$dest,$sql_path,$redis_path,$file_path}

# database backup
su -c "pg_dump mastodon > ${path}/mastodon.pgsql" postgres
mv $path/mastodon.pgsql $sql_path

# .env.production
cp $live_path/.env.production $dest

# user files
tar czf $file_path/live-files.tgz $live_path

# redis
cp $redis_file $dest/redis/

# Backup the files using tar.
day=$(date +%m-%d-%Y)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

tar czf $path/$archive_file $dest

# cleanup

# Print end status message.
echo
echo "Backup finished"
date