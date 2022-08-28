
non_latin_characters () { 
	local result="$(pcregrep --color='auto' -n -c "[^\x00-\x7F]" <<< $@)"
	return $result
}

create_db_if_needed () {
    mkdir -p ../data
    touch ../data/users.db
}

if [[ $1 == 'add' ]]; then
    create_db_if_needed

	echo "Type username:"
	read name
	echo "Type role:"
	read role

	non_latin_characters $name
	if [[ $? == 0 ]]; then
		echo "Username input is valid!"
	else
		echo "[Error] Username contains latin characters!"
        exit 1
    fi

	non_latin_characters $role
	if [[ $? == 0 ]]; then
        echo "Role is valid!"
    else
        echo "[Error] Role contains latin characters!"
        exit 1
    fi
	echo "$name,$role" >> ../data/users.db
	echo "Saved!"
elif [[ $1 == 'backup' ]]; then
    create_db_if_needed

    date=$(date '+%Y-%m-%dT%H:%M:%S')
    path=$(printf "../data/%s.users.db" $date)
    touch $path

    cat "../data/users.db" >> $path
elif [[ $1 == 'restore' ]]; then
    create_db_if_needed
    
    files_str=$(find ../data -regex "../data/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9].users.db" -print0 | sort -z --reverse)
    str2=$(echo $files_str | cut -d "%" -f1)

    if [[ $str2 == "" ]]; then
        echo "No backup file found!"
    else
        cp $str2 "../data/users.db"
        echo "Restored!"
    fi
elif [[ $1 == 'find' ]]; then
    create_db_if_needed

    echo "Type username:"
	read name

	non_latin_characters $name
	if [[ $? == 0 ]]; then
		echo "Username input is valid!"
	else
		echo "[Error] Username contains latin characters!"
        exit 1
    fi

    found_lines=$(grep "^$name," ../data/users.db)
    if [[ $found_lines == "" ]]; then
        echo "User not found!"
    else
        echo "Found users:"
        echo $found_lines
    fi
elif [[ $1 == 'list' ]]; then
    create_db_if_needed

    if [[ $2 == "--inverse" ]]; then
        cat -b ../data/users.db | perl -e 'print reverse <>'
    else
      cat -b ../data/users.db
    fi
elif [[ $1 == 'help' || $1 == '' ]]; then
    echo "Options:"
    echo "      add     adds new user to data/users.db"
    echo "      backup  creates a new file, named %date%-users.db.backup which is a copy of current users.db"
    echo "      find    takes the last created backup file and replaces users.db with it. If there are no backups - script should print: “No backup file found”"
    echo "      list    prints the content of the users.db in the format: N. username, role"
    echo "      help    prints instructions on how to use this script with a description of all available commands"
fi
