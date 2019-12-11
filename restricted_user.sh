#******************************************************************************
#			NAME - SHIBA BISWAS
#			DESIGNATION - STUDENT
#			EMAIL - shibabiswas1111@gmail.com
#			INDIA
#******************************************************************************

#! /bin/bash

#You are root user
#First make a directory named "Client" at home-directory & then proceed
#Following all informations are necessary

echo "-------------------------------------------------------------------------"
echo "ENTER DETAILS ABOUT USER TO MAKE AN ACCOUNT OR MODIFYING EXISTING ACCOUNT"
echo "-------------------------------------------------------------------------"
echo -e "Enter USER-NAME : \c"
read usr

#Create a bash shell for user
cp /bin/bash /root/Client/bash_$usr
shell=/root/Client/bash_$usr

echo -e "Enter USER's FULL-NAME : \c"
read fn
echo -e "Enter GROUP-NAME : \c"
read grp
echo -e "Enter path of HOME-DIRECTORY : \c"
read phm


x=`grep "$usr" /etc/passwd`
y=`grep "$usr" /etc/passwd | cut -d ":" -f 7`

#Check the existence of restricted user
if [ "$y" == "$shell" ]
then
	echo "This user : "$usr" already a restricted user."
	echo "Modify manually."
	exit 0
fi

if [ "$x" != "" ]
then
	echo "Same user-name already exists."
	echo -e "Are you want to modify existing user account ??? (y/n) : \c"
	read choice
	case "$choice" in
		[Yy]*)
			#Modifying shell of existing user
			usermod -s "$shell" "$usr"
			echo "Shell of $usr modified.";;

		*)
			echo "Please Enter valid username."
			rm "$shell"
			exit 0;;
	esac
else
	#Add a restricted user in this system
	useradd -g "$grp" -d "$phm" -c "$fn" -s "$shell" -m "$usr"
	echo "$usr added as an user."
fi

#Password setting for added or modified user
sleep 5
passwd "$usr"
sleep 5

echo "Creating $usr's new path varialbe and replacing all other path variables."

#Home directory of added user
path1=/home/$usr

#Make a directory at home directory of added user
mkdir $path1/restricted_path_$usr

#Creat new path variables for restricted user
echo -e "\n\nPATH=$path1/restricted_path_$usr\nexport PATH\n\n" >> $path1/.bashrc

sleep 5

#Enter specific commands to be executed by restricted user
#Commands must be separated by a space
echo -e "Enter commands (separated by a space) : \c"
read comds
comd_array=($comds)
for comd in ${comd_array[@]}
do
	ln -s /bin/$comd $path1/restricted_path_$usr
done
echo "Commands selections are completed."

echo "Creating .bashrc file immutable."
sleep 5
chattr +i $path1/.bashrc
echo "Process is complete."

echo "YOUR SYSTEM WITH USER : $usr IS READY."
echo "NOW SYSTEM WILL BE REBOOT IN FEW SECONDS."
echo "REBOOTING . . ."
sleep 10
init 6		#For system reboot

