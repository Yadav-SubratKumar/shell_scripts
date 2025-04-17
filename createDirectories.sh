if [[ $# -lt 3 ]]; then
    echo "Error: format should be directory_name start_number end_number"
else
    for i in $(seq $2 $3); do
        mkdir "${1}${i}"
    done
    echo " Directories has been create $1$2 ... $1$3 "
fi
