echo "############# Installing Docker on Your Ubuntu Machine #######"
sleep 3

sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-key fingerprint 0EBFCD88
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y 

sleep 2
echo "                                           "
echo "############################################"
echo "Successfully installed Docker Engine on your System"
echo "############################################"
sleep 3
echo "                                           "
echo "################################"
echo "Enabling and Starting docker"
echo "################################"
echo "                                           "

sudo systemctl enable docker
sudo systemctl start docker

echo "                                           "
echo "###################################"
echo "Status of Docker Engine"
echo "###################################"
echo "                                           "

sleep 2
sudo systemctl status docker
