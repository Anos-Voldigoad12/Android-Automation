#/bin/bash
function getAnimSpeed
{
	default_window_speed=$( adb shell settings get global window_animation_scale )
	default_transition_speed=$( adb shell settings get global transition_animation_scale )
	default_animator_duration=$( adb shell settings get global animator_duration_scale )
}
function setAnimSpeed
{
	local var1=$1
	local var2=$2
	local var3=$3

	if [ -z "$var2" ];
	then
		var2=$var1
	fi
	if [ -z "$var3" ];
	then
		var3=$var2
	fi

	adb shell settings put global window_animation_scale $var1
	adb shell settings put global transition_animation_scale $var2
	adb shell settings put global animator_duration_scale $var3
	adb shell settings put global immersive_mode_confirmations confirmed
}
function filter
{
	IFS=' '
	read -ra s<<<"$1"
	local string=""
	for x in "${s[@]}";
	do
		string+=$x
		string+="\ "
	done
	IFS='('
	read -ra s<<<"$string"
	string=""
	for x in "${s[@]}";
	do
		string+=$x
		string+="\("
	done
	IFS=')'
	read -ra s<<<"$string"
	string=""
	for x in "${s[@]}";
	do
		string+=$x
		string+="\)"
	done
	
	string=${string::-4}
	unset s

	echo "$string"
}
function Back
{
	adb shell input keyevent 4
}
function Home
{
	adb shell input keyevent 3
}
function Recent
{
	adb shell input keyevent 187
	
	for ((;;));
	do
		read -p "Close Last Process : " choice
		echo " "
		case $choice in
			'yes'|'y'|'Y'|'Yes'|'YES')
				adb shell input swipe 370.5 823.5 370.5 64 100
			;; 
			'no'|'n'|'N'|'No'|'NO')
				return 1
			;;
			*)
				echo "Invalid Choice!"
				adb shell input keyevent 187
				return 1
			;;
		esac
	done	
}
function WhatsApp_Bulk
{
	read -p "Message : " msg
	read -p "Names seperated by (;) : " temp_name
	IFS=';'
	read -ra names<<<"$temp_name"
	adb shell input tap "${WpNew[@]}"
	adb shell input tap "${WpSearch[@]}" 
	adb shell input text "$( filter "${names[0]}" )"
	adb shell input tap "${Wp1Name[@]}"
	adb shell input text "$( filter "$msg" )"
	adb shell input tap "${WpSend[@]}"
	Back
	adb shell input swipe ${WpSent[@]} ${WpSent[@]} 1000
	adb shell input tap "${WpFwrd[@]}"
	adb shell input tap "${WpFwrdSearch[@]}"
	len=${#names[@]}
	for ((i=1;i<len;i++));
	do
		adb shell input text "$( filter "${names[$i]}" )"
		adb shell input tap "${Wp1Name[@]}"
		adb shell input tap "${WpFwrdClrSearch[@]}"
	done
	adb shell input tap "${WpFwrdSend[@]}"
	sleep 1
	Back
}
function WhatsApp_Spam
{
	read -p "Name : " name
	read -p "Message : " msg
	read -p "Message Count : " count
	
	echo " "
			
	adb shell input tap "${WpNew[@]}"
	adb shell input tap "${WpSearch[@]}" 
	adb shell input text "$( filter "$name" )"
	adb shell input tap "${Wp1Name[@]}"
	printf "${PURPLE}"
	printf "[ "
	for ((i=1;i<=count;i++));
	do
		printf "$i "
		adb shell input text "$( filter "$msg" )"
		adb shell input tap "${WpSend[@]}"
	done
	printf "]${NC}"
	unset name && unset msg && unset count
	Back
	Back
}
function WhatsApp
{
	adb shell monkey -p com.whatsapp -v 1 &> /dev/null
	sleep 1

	printf "${LIGHTGREEN}"
	echo "[Options :  Bulk(B)  Spam(S)  Exit(X)]"
	read -p "Choice : " choice
	printf "${NC}"
	echo " "
	case $choice in
		'B'|'b')
			WhatsApp_Bulk
		;;
		'S'|'s')
			WhatsApp_Spam
		;;
		'X'|'x')
			return 1
		;;
		*)
			echo "Invalid Choice!"
		;;	
	esac
	echo " "	  
}
function DM_Bulk
{
	read -p "Message : " msg
	read -p "Names seperated by (;) : " temp_name
	IFS=';'
	read -ra names<<<"$temp_name"
	adb shell input tap "${IgSearch[@]}"
	adb shell input text "$( filter "${names[0]}" )"
	adb shell input tap "${Ig1Name[@]}"
	adb shell input text "$( filter "$msg" )"
	adb shell input tap "${IgSend[@]}"
	Back
	sleep 1
	adb shell input swipe ${IgSent[@]} ${IgSent[@]} 1500
	adb shell input tap "${IgMore[@]}"
	sleep 1
	adb shell input tap "${IgFwrd[@]}"
	sleep 1
	adb shell input tap "${IgFwrdSearch[@]}"
	len=${#names[@]}
	for ((i=1;i<len;i++));
	do
		adb shell input text "$( filter "${names[$i]}" )"
		sleep 1
		adb shell input tap "${IgFwrdSend[@]}"
		adb shell input tap "${IgFwrdClrSearch[@]}"
		adb shell input tap "${IgFwrdSearch[@]}"
	done
	adb shell input tap "${IgFwrdDone[@]}"
	Back
	Back
}
function DM_Spam
{
	read -p "Username : " name
	read -p "Message : " msg
	read -p "Message Count : " count
		
	echo " "
		
	adb shell input tap "${IgSearch[@]}"
	adb shell input text "$( filter "$name" )"
	adb shell input tap "${Ig1Name[@]}"
	printf "${PURPLE}[ "
	for ((i=1;i<=count;i++));
	do
		printf "$i "
		adb shell input text "$( filter "$msg" )"
		adb shell input tap "${IgSend[@]}"
	done
	printf "]${NC}"
	unset name && unset msg && unset count
	Back
	Back
	Back
}
function DM
{
	adb shell input tap "${IgDM[@]}"
	printf "${LIGHTGREEN}"
	echo "[Options :  Bulk(B)  Spam(S)  Exit(X)]"
	read -p "Choice : " choice
	printf "${NC}"
	echo " "
	case $choice in
		'B'|'b')
			DM_Bulk
		;;
		'S'|'s')
			DM_Spam
		;;
		'X'|'x')
			return 1
		;;
		*)
			echo "Invalid Choice!"
		;;	
	esac
	echo " "
}
function Instagram
{
	adb shell monkey -p com.instagram.android -v 1 &> /dev/null
	sleep 1
	for ((;;))
	do
		printf "${LIGHTGREEN}"
		echo "[Options :  Scroll Up(U)  Scroll Down(D)  DM(M)  Exit(X)]"
		read -p "Choice : " choice
		printf "${NC}"
		echo " "
		case $choice in 
			'U'|'u')
				adb shell input swipe 322 1234 322 1100 50
			;;
			'D'|'d')
				adb shell input swipe 322 1100 322 1234 50
			;;
			'M'|'m')
				DM
			;;
			'X'|'x')
				return 1
			;;
			*)
				echo "Invalid Choice!"
			;;
		esac
		echo " "
	done
	
}
function Camera
{
	adb shell monkey -p com.android.camera -v 1 &> /dev/null
	for ((;;));
	do
		printf "${LIGHTGREEN}"
		echo "[Options :  Focus(F)  Shoot(0)  Exit(X)]"
		read -p "Choice : " choice
		printf "${NC}"
		echo " "
		case $choice in
			'F'|'f')
				adb shell input tap 375.5 648.5
			;;
			'0'|0)
				adb shell input tap "${CamShutter[@]}"
			;;
			'X'|'x')
				return 1
			;;
			*)
				echo "Invalid Choice!"
			;;
		esac
		echo " "
	done
}
function Gallery
{
	adb shell monkey -p com.google.android.apps.photosgo -v 1 &> /dev/null
	sleep 3
	adb shell input tap "${Gal1Pic[@]}"
	sleep 1
	adb shell input tap "${Gal1Pic[@]}"
	for ((;;));
	do
		printf "${LIGHTGREEN}"
		echo "[Options :  Left(<)  Right(>)  Exit(X)]"
		read -p "Choice : " choice
		printf "${NC}"
		echo " "
		case $choice in 
			'<')
				adb shell input swipe 400 871 191 871 50 
			;;
			'>')
				adb shell input swipe 191 871 400 871 50
			;;
			'X'|'x')
				return 1
			;;
			*)
				echo "Invalid Choice!"
			;;
		esac
		echo " "
	done
}
function YouTube
{	
	read -p "Search : " search
	
	adb shell monkey -p com.google.android.youtube -v 1 &> /dev/null
	sleep 3
	adb shell input tap "${YtSearch[@]}"
	adb shell input text "$( filter "$search" )"
		adb shell input keyevent 66
	sleep 3
	adb shell input tap "${Yt1Search[@]}"
}
function Phone_Contact
{
	read -p "Name : " name
	adb shell monkey -p com.google.android.dialer -v 1 &> /dev/null
	sleep 1
	adb shell input tap "${Contacts[@]}"
	adb shell input tap "${ContactSearch[@]}"
	sleep 1
	adb shell input text "$( filter "$name" )"
	adb shell input tap "${Contact1Name[@]}"
}
function Phone_Number
{
	read -p "Number(inc country code) : " number
	adb shell am start -a android.intent.action.CALL -d tel:$number &> /dev/null
	echo " "
}
function Phone
{
	printf "${LIGHTGREEN}"
	echo "[Options :  Saved Contact(C)  Phone Number(N)  Exit(X)]"
	read -p "Choice : " choice
	printf "${NC}"
	echo " "
	case $choice in
		'C'|'c')
			Phone_Contact
		;;
		'N'|'n')
			Phone_Number
		;;
		'X'|'x')
			return 1
		;;
		*)
			echo "Invalid Choice!"
		;;
	esac	
	for ((;;));
	do
		printf "${LIGHTGREEN}"
		echo "[Options :  Loud Speaker(L)  Disconect(D)  Exit(X)]"
		read -p "Choice : " choice
		printf "${NC}"
		echo " "
		case $choice in
			'L'|'l')
				adb shell input tap "${CallLoud[@]}"
			;;
			'D'|'d')
				adb shell input tap "${CallDisconnect[@]}"
				return 1
			;;
			'X'|'x')
				return 1
			;;
			*)
				echo "Invalid Choice!"
			;;
		esac
		echo " "
	done			
		
}
