Toolbelt_dot() { file=$1; shift; . "$file"; }
# usage example below
# Toolbelt_dot ./file-you-wanna-source.sh parameter1 parameter2 parameter3
# Toolbelt_dot ./bash-tally/tally.sh ./backup_logs.log 


Toolbelt_readConfig() {
while read -r line; do declare  "$line"; done < $1
}
# usage example below
# Toolbelt_readConfig config-file-location
# Toolbelt_readConfig ./some-config.txt
