#!/bin/bash
#---------------------------------------------------------------------
#Ask for VM Destination
echo
echo -----------------------------------------------------------------
echo "Please enter the VM Destination e.g. /home/user/Backup"
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

#List all Files in VM Destination
echo
echo -----------------------------------------------------------------
echo "List of Files in VM Destination"
echo -----------------------------------------------------------------
ls -l $vmdestination

#Ask for VM Name
echo
echo -----------------------------------------------------------------
echo "Please enter the VM Name for restore e.g. ubuntu"
echo -----------------------------------------------------------------
read vmname

#Check if VM File exists
FILE="$vmdestination/$vmname.qcow2"
if [ -f "$FILE" ]; then

    echo "...done - going to next step"

else

    echo "VM File not exists - Error"
    exit
fi

#Ask for Restore Destination
echo
echo -----------------------------------------------------------------
echo "Please enter the Restore Destination e.g. /lib/libvirt/image"
echo -----------------------------------------------------------------
read redestination

#Check if Restore Destination exists
DIR="$redestination"
if [ -d "$DIR" ]; then

 #Take action if $DIR exists
  echo
  echo -----------------------------------------------------------------
  echo "Restore Destination  exists: ${DIR}..."
  echo -----------------------------------------------------------------
  echo "...going to next Step"

else

  #Take action if $DIR not exists
  echo
  echo -----------------------------------------------------------------
  echo "Restore Destination dose not exists - Error"
  echo -----------------------------------------------------------------
  exit

fi

#Copy VM Image to Restore Destination
echo
echo -----------------------------------------------------------------
echo "Copy VM Image to Restore Destination..."
echo -----------------------------------------------------------------
echo "please wait (VM size with 65GB and SSD may take about 10min.)..."
cp -f $vmdestination/$vmname.qcow2 $redestination/

#Check if VM Image is in Restore Destination
FILE="$redestination/$vmname.qcow2"
if [ -f "$FILE" ]; then

    echo "...done - going to next step"

else

    echo "VM Image was not copied - Error"
    exit
fi

#Check if VM XML File exists
echo
echo -----------------------------------------------------------------
echo "Check if VM XML File exists"
echo -----------------------------------------------------------------
FILE="$vmdestination/$vmname.xml"
if [ -f "$FILE" ]; then

    echo "...done - going to next step"

else

    echo "VM XML Fle ($vmdestination/$vmname.xml) not exists - Error"
    exit
fi

# Restore VM with XML for KVM
echo
echo -----------------------------------------------------------------
echo "Restore VM with xml File for KVM"
echo -----------------------------------------------------------------
virsh define --file $vmdestination/$vmname.xml
echo
echo "Restore $vmname successfully!"
echo
echo
