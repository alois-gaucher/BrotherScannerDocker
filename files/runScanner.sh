echo "Creating user $USERNAME"
adduser $USERNAME --disabled-password --force-badname --gecos ""

echo "Creating scanner directory"
mkdir -p /scans
chmod 777 /scans

echo "Installing scanner software"
chmod -R 777 /opt/brother
env > /opt/brother/scanner/env.txt
su - $USERNAME -c "/usr/bin/brsaneconfig4 -a name=$NAME model=$MODEL ip=$IPADDRESS"
su - $USERNAME -c "/usr/bin/brscan-skey"

su - $USERNAME -c "rm -rf /opt/brother/scanner/brscan-skey/script"
su - $USERNAME -c "mv /home/$USERNAME/script /opt/brother/scanner/brscan-skey/script"

while true;
do
  sleep 1000
done

echo "Startup finished"

exit 0
