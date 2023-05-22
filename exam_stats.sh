#!/bin/bash -u
PATH=/bin:/usr/bin ; export PATH
umask 022
# Jiebo Peng peng0059@algonquinlive.com

declare -a exam_array
exam_array=("$@")
if [ ${#exam_array[@]} -ge 1 ]; then
    index=0
    gradeSum=0
    AVG=0
    top_index=0
    top_grade=0
    low_index=0
    low_grade=100

    while [ $index -lt ${#exam_array[@]} ]; do
	 record=${exam_array[$index]}
	 grade=$(echo $record | cut -d : -f 3)
	 if [ $grade -ge 0 ] && [ $grade -le 100 ] ; then
	       gradeSum=$(($gradeSum + $grade))
	       if [ $grade -gt $top_grade ] ; then
		       top_index=$index
		       top_grade=$grade
	       fi

	       if [ $grade -lt $low_grade ] ; then
		       low_index=$index
		       low_grade=$grade
	       fi
	 else
	       echo 1>&2 "$0: Error: the grade must between 0 to 100. The wrong student information is: $record"
	       exit 10
	 fi
	 index=$((index+1))
    done

    echo "#8844" > stats.txt
    echo "NUM_STUDS=$index" >> stats.txt
    echo "AVG=$(($gradeSum/$index))" >> stats.txt
    top_id=$(echo ${exam_array[$top_index]} | cut -d : -f 1)
    top_name=$(echo ${exam_array[$top_index]} | cut -d : -f 2)
    echo "TOP_ID=$top_id" >> stats.txt
    echo "TOP_NAME=$top_name" >> stats.txt
    echo "TOP_GRADE=$top_grade" >> stats.txt

    low_id=$(echo ${exam_array[$low_index]} | cut -d : -f 1)
    low_name=$(echo ${exam_array[$low_index]} | cut -d : -f 2)
    echo "BOTTOM_ID=$low_id" >> stats.txt
    echo "BOTTOM_NAME=$low_name" >> stats.txt
    echo "BOTTOM_GRADE=$low_grade" >> stats.txt

else
    echo 1>&2 "$0: Error: expecting at least 1 argument"
    echo 1>&2 "Usage $0 student_number:student_name:student_grade"
    echo 1>&2 "e.g: $0 1234:Leo:92"
    exit 1    
fi
