# --------------------------------------------------------------------------
# Lunabase setup
#
# curl https://raw.githubusercontent.com/mardix/lunabase/master/setup.sh > lunabase-setup.sh
# chmod 755 setup.sh
# ./setup.sh
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------

echo "--------------------------------------------------------------------------"
echo "Lunabase Platform installation ..."
echo

apt-get update
apt-get install -y wget curl 
apt-get update

# Install Boxie
echo 
echo "================ installing Boxie ..."
echo 
curl https://raw.githubusercontent.com/mardix/boxie/master/install.sh > install.sh
chmod 755 install.sh
./install.sh

# Install Redis
echo 
echo "--------------------------------------------------------------------------"
echo "================ installing Redis ..."
echo 
while true; do
    read -s -p "Enter Redis Password: " password
    echo
    read -s -p "Re-enter Redis Password: " password2
    echo
    [ "$password" = "$password2" ] && break
    echo "Passwords didn't match. Try again"
done
echo
apt-get install -y redis-server
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf
sed -i 's/supervised.*/supervised systemd/g' /etc/redis/redis.conf
sed -i "s/# requirepass.*/requirepass $password/g" /etc/redis/redis.conf
sudo systemctl restart redis.service


# Install ArangoDB
echo 
echo "--------------------------------------------------------------------------"
echo "================ installing ArangoDB "
echo 
curl -OL https://download.arangodb.com/arangodb37/DEBIAN/Release.key
sudo apt-key add - < Release.key
echo 'deb https://download.arangodb.com/arangodb37/DEBIAN/ /' | sudo tee /etc/apt/sources.list.d/arangodb.list
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install arangodb3=3.7.3-1
