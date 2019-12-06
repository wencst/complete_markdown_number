#!/bin/bash
declare -a STACK #定义一个全局数组
declare TOPLEVEL=0
declare LOWLEVEL=0
CURRINDEX=0
TEMPVALUE=0
LEVELSTR=''
function init_stack(){
    STACK[1]=0
    let TOPLEVEL=$1
    let LOWLEVEL=$1
}
function help(){
echo -e "\033[31m"
cat << HELP
===============================================
changeTitleNumber.sh

USAGE: 
To change the file title number: 
	changeTitleNumber.sh filename.md
To get help tips: 
	changeTitleNumber.sh help

EXAMPLE:

Init in markdown file:
# first title
## second title
# third title
# 2. fouth title
## 2.1. fifth title
# 3. sixth title

After execute this shell:
# 1. first title
## 1.1. second title
# 2. third title
# 3. fouth title
## 3.1. fifth title


TIPS:
1.The file must be a markdown file, and the filename must be end with '.md'.
2.The title line must be start with '#', and should use space to split 'the last #' and 'title number' and 'title line', and the title number is not necessary.
3.The first title will be the highest level, and other titles in this file can't be higher than it.
4.The title's level should not leapfrog.
5.To refresh title's level number, you can execute 'changeTitleNumber.sh filename.md' again.
6.The title number is not necessary, and could only use '0-9.' in title.
===============================================
HELP
echo -e "\033[0m"
}
function next_level(){
    if [[ $TOPLEVEL = 0 ]]; then
        init_stack $1
    fi
    if [[ $TOPLEVEL > $1 ]]; then
		echo "The first title's level is $TOPLEVEL, current level is $1. "
        help
        exit 1
    fi
    if [[ $LOWLEVEL < `expr $1 - 2` ]]; then
		echo "The title's level should not leapfrog."
        help
        exit 1
    fi

    CURRINDEX=`expr $1 - $TOPLEVEL + 1`
    if [[ $LOWLEVEL < $1 ]]; then
        TEMPVALUE=1
    else
        TEMPVALUE=`expr ${STACK[$CURRINDEX]} + 1`
    fi
    TEMPINDEX=1
    LEVELSTR=''
    while [[ $TEMPINDEX < $CURRINDEX ]]; do
        LEVELSTR=$LEVELSTR${STACK[$TEMPINDEX]}"."
        TEMPINDEX=`expr $TEMPINDEX + 1`
    done
    LEVELSTR=$LEVELSTR$TEMPVALUE"."
    STACK[$CURRINDEX]=$TEMPVALUE
    TEMPINDEX=`expr $LOWLEVEL - $TOPLEVEL + 1`
    while [[ $TEMPINDEX > $CURRINDEX ]]; do
        unset STACK[$TEMPINDEX]
        TEMPINDEX=`expr $TEMPINDEX - 1`
    done
    let LOWLEVEL=$1
    echo "LEVELSTR" $LEVELSTR
    echo "CURRLEVEL" $1
}
filename=$1
if [ $filename = "help" ]; then
    help
	exit 1
fi
if [ ! -f $filename ]; then
    echo "$filename is not exists."
    help
	exit 1
fi
fileREG='\.md$'
if [[ $filename !=~ $fileREG ]]; then
    echo "$filename is not a markdown file."
	help
	exit 1
fi
newfilename=$filename.temp
cat $filename | while read line ; do
    REG='^#+ .*'
    if [[ $line =~ $REG ]]; then
        level=${line%% *}
        other=${line#* }
        REG1='^[0-9.]+ .*'
        if [[ $other =~ $REG1 ]]; then
            title=${other#* }
        else
            title=$other
        fi
        echo "title" $title
        levelnum=`echo $level |tr -cd "#" |wc -c`
        echo "levelnum" $levelnum
        next_level $levelnum
        newtitle="$level $LEVELSTR $title"
        echo "newtitle" $newtitle
        echo $newtitle >> $newfilename
    else
        echo $line >> $newfilename
    fi
done
cat $newfilename > $filename
rm -f $newfilename

