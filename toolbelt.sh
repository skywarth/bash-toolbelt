Toolbelt_dot() { file=$1; shift; . "$file"; }
# usage example below
# Toolbelt_dot ./file-you-wanna-source.sh parameter1 parameter2 parameter3
# Toolbelt_dot ./bash-tally/tally.sh ./backup_logs.log 


Toolbelt_readConfig() {
while read -r line
do
declare -g "$line"
done < $1
}
# usage example below
# Toolbelt_readConfig config-file-location
# Toolbelt_readConfig ./some-config.txt






Toolbelt_parseJSON(){
  local -n jsonArray=$2

  SETTINGS_FILE="$1"
  SETTINGS_JSON=$(cat $SETTINGS_FILE)
  __readJSON "$SETTINGS_JSON"
}
# Usage:
# declare -A firstJSON  #this is an array
# declare -A secondJSON #this is an array
# Toolbelt_parseJSON "./test.json" firstJSON
# Toolbelt_parseJSON "./test2.json" secondJSON
# echo "--"
# echo "${firstJSON[@]}"
# echo "${secondJSON[@]}"

__readJSON() {

    local JSON=`jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" <<< "$1"`
    local KEYS=''

    if [ $# -gt 1 ]; then

        KEYS="$2"
    fi

    while read -r PAIR; do
        local KEY=''

        if [ -z "$PAIR" ]; then
            break
        fi

        IFS== read PAIR_KEY PAIR_VALUE <<< "$PAIR"

        if [ -z "$KEYS" ]; then
            KEY="$PAIR_KEY"
        else
            KEY="$KEYS:$PAIR_KEY"
        fi


                res=$(jq -e . 2>/dev/null <<< "$PAIR_VALUE")

                exitCode=$?
                check=`echo "$PAIR_VALUE" | grep -E ^\-?[0-9]*\.?[0-9]+$`
          # if [ "${res}" ] && [ $exitCode -eq "0" ] && [[ ! "${PAIR_VALUE}" == ?(-)+([0-9]) ]]  ALTERNATIVE, works only for integer (not floating point)
          if [ "${res}" ] && [ $exitCode -eq "0" ] && [[ "$check" == '' ]]
            then
                __readJSON "$PAIR_VALUE" "$KEY"
               else
            jsonArray["$KEY"]="$PAIR_VALUE"
        fi



    done <<< "$JSON"
}