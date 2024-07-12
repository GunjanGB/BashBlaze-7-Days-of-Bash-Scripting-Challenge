
#!/bin/bash

<<readme
This is day 9 of 90DaysofDevops
It takes backup of scripts with rotation key
readme

source_directory=$1
target_directory=$2
timestamp=$(date '+%Y-%m-%d-%H:%M:%S')
backup_directory="$target_directory/backup_$timestamp"


function create_backup {

zip -r "${backup_directory}.zip" "${source_directory}" > /dev/null

if [ $? -eq 0 ]; then
    echo "Backup done successfully"
else
    echo "Backup not done for $timestamp"
fi
}


function perform_rotation {
        backups=($(ls -t "$target_directory/backup_"*.zip))

        if [ "${#backups[@]}" -gt 5 ]; then
                backups_to_remove=("${backups[@]:5}")
                for backup in "${backups_to_remove[@]}";
                do
                        rm "$backup"
                done
        fi


}
create_backup
perform_rotation
