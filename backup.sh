#!/bin/bash
#---------------------------------------------------------------------
#List all running KVM VMs
echo
echo -----------------------------------------------------------------
echo "List with all running VMs (ID - Name - Status)"
echo -----------------------------------------------------------------
virsh list

#Ask for VM Name to be backuped
echo
echo -----------------------------------------------------------------
echo "Please enter the VM Name for Backup"
echo -----------------------------------------------------------------
read vmname

#Ask for Backupdestination
echo
echo -----------------------------------------------------------------
echo "Please enter the Backupdestination e.g. /home/user/Backup"
echo -----------------------------------------------------------------
read bkdestination

#Check if Backupdestination exists
DIR="$bkdestination"
if [ -d "$DIR" ]; then

 #Take action if $DIR exists
  echo
  echo -----------------------------------------------------------------
  echo "Backupdestination  exists: ${DIR}..."
  echo -----------------------------------------------------------------
  echo "...going to next Step"

else

  #Take action if $DIR not exists
  echo
  echo -----------------------------------------------------------------
  echo "Backupdestination dose not exists and will create now..."
  echo -----------------------------------------------------------------
  mkdir $bkdestination
  echo "Backupdestination created"

fi

#Ask for VM Destination
echo
echo -----------------------------------------------------------------
echo "Please enter the VM Destination e.g. /lib/libvirt/images"
echo -----------------------------------------------------------------
read vmdestination


#Check if VM Destination exists
DIR="$vmdestination"
if [ -d "$DIR" ]; then

 #Take action if $DIR exists
  echo
  echo -----------------------------------------------------------------
  echo "VM Destination  exists: ${DIR}..."
  echo -----------------------------------------------------------------
  echo "...going to next Step"

else

  #Take action if $DIR not exists
  echo
  echo -----------------------------------------------------------------
  echo "VM Destination dose not exists - Error"
  echo -----------------------------------------------------------------
  exit

fi

#Dump the VM config XML
echo
echo -----------------------------------------------------------------
echo "VM XML will be dump to Backupdestination"
echo -----------------------------------------------------------------
virsh dumpxml $vmname > $bkdestination/$vmname.xml

#Check if the File was created
FILE="$bkdestination/$vmname.xml"
if [ -f "$FILE" ]; then

    echo "...done - going to next step"

else 

    echo "File was not created - Error"
    exit
fi

#Create the external snapshot
echo
echo -----------------------------------------------------------------
echo "Snapshot for RAM will be created"
echo -----------------------------------------------------------------
virsh snapshot-create-as --domain $vmname $vmname-state \
    --diskspec vda,file=$bkdestination/$vmname-state.qcow2 \
    --disk-only --atomic --quiesce --no-metadata

#Check if Snapshot was created
FILE="$bkdestination/$vmname-state.qcow2"
if [ -f "$FILE" ]; then

    echo "...done - going to next step"

else 

    echo "Snapshot was not created - Error"
    exit
fi

#Backup the disk image and VM configuration
echo
echo -----------------------------------------------------------------
echo "VM $vmname will be backuped"
echo -----------------------------------------------------------------
echo "please wait (VM size with 65GB and SSD may take about 10min.)..."
cp -f $vmdestination/$vmname.qcow2 $bkdestination

#Check if Backupfile exists
FILE="$bkdestination/$vmname.qcow2"
if [ -f "$FILE" ]; then

    echo "...done - going to next step"

else 

    echo "Backup was not created - Error"
    exit
fi

#Merge the snapshot
echo
echo -----------------------------------------------------------------
echo "Merge the Snapshot to $vmname"
echo -----------------------------------------------------------------
virsh blockcommit $vmname vda --active --verbose --pivot
echo "...done - going to next step"

#Remove the snapshot
echo
echo -----------------------------------------------------------------
echo "Delete Snapshot"
echo -----------------------------------------------------------------
rm $bkdestination/$vmname-state.qcow2
echo "done - goning to next step"
echo
echo "Backup was created  successfully..."
echo
