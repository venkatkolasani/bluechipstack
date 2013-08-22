#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# just so we're all clear
clear 

# see if we have our setuprc file available and source it
if [ -f ./setuprc ]
then
  . ./setuprc
else
  echo "##########################################################################################################################"
  echo;
  echo "A setuprc config file wasn't found & the install must halt.  Report this at https://github.com/bluechiptek/bluechipstack."
  echo;
  echo "##########################################################################################################################"
  exit;
fi

num_nodes=$NUMBER_NODES

# grab the chef client install script
curl -skS https://raw.github.com/rcbops/support-tools/master/chef-install/install-chef-client.sh > install-chef-client.sh
chmod +x install-chef-client.sh

echo "##########################################################################################################################"
echo; 
echo "Please wait while the "$num_nodes" nodes are being configured..."

# loop through config's machines and run against each 
rm -f /tmp/.node_hosts
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ./install-chef-client.sh ${!host}
  done

echo;
echo "##########################################################################################################################"