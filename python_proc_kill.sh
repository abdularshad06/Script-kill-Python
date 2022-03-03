#!/bin/bash

while true  
do  
	NAME_KILL="python"

	#Time in seconds which the process is allowed to run
	KILL_TIME=300

	#Set UID
	U_ID=10000

	KILL_LIST=()
	EMAIL_LIST=()
	SEND_LIST=()
	while read PROC_UID PROC_USER PROC_PID PROC_ETIMES PROC_ETIME PROC_COMM; do
	    if [ $PROC_UID -gt $U_ID  -a "$PROC_COMM" == "$NAME_KILL" -a $PROC_ETIMES -gt $KILL_TIME ]; then
	    KILL_LIST+=("$PROC_PID");
	    MSG="Killing '$PROC_COMM' which runs for $PROC_ETIME";
	    echo "$MSG";
	    SEND_LIST+=($PROC_USER);
	    fi
	done < <(ps eaxo uid,user:20,pid,etimes,etime,comm | grep -i $NAME_KILL)
	
	
	if [ ${#KILL_LIST[*]} -gt 0 ]; then
	    kill -9 ${KILL_LIST[@]}
	fi
	
	if [ ${#SEND_LIST[*]} -gt 0 ]; then
	    com=`tty`
	    exec <$com
	      for i in "${SEND_LIST[@]}"
	        do
			echo "Please do not run your job on Login/Master Node more then 5 Minutes Otherwise job will kill Automatically" | write $i;
	        #echo "$i"
	      done
	    
	    	if [ $? -eq 0 ]; then
	        	echo "Warning Message has been sent successfully.............ok"
	        	#return 0
	    	else
	        	echo "Message Failed to send ..............No!!"
	        	echo "Maybe It is not available for you To send Message To hem "
	    		#return 1
	    	fi
	    
	
	fi

   sleep 1m
done
