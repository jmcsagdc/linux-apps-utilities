####################
# Let's just install a bunch of useful stuff for 
# a development test system. Source control, ssh, etc.
#
# No security considerations are handled. Use with care.
# For exaample, DOCKER runs as root and GITHUB repos can
# be made by anyone...so know your sources.
####################
sudo apt-get install -y tree htop inetutils-traceroute

####################
# SSH
####################

sudo apt-get install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

####################
# curl
####################

sudo apt-get install -y curl

####################
# Docker
####################

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

#   The next command is an opportunity to add scripted validation
apt-cache policy docker-ce

sudo apt-get install -y docker-ce
#   Docker is installed

#   The next command is an opportunity to add scripted validation
sudo systemctl status docker

#    Executing docker as your user instead of sudo to root
sudo usermod -aG docker ${USER}
#    This change is not picked up until next login or next shell

#   The next command is an opportunity to add scripted validation...for now, just no error is good
docker info

#    Suggested quick things to expedite using it when you need it: grab a few base images
#        SQL servers
docker pull mysql
docker pull postgres
#        Linux distos
docker pull centos
docker pull ubuntu
#        Full stack
docker pull linode/lamp
docker pull jasonmakescoolstuff/shakaplayer:latest
docker pull jasonmakescoolstuff/pysql

####################
# Python Stuff
####################
sudo apt-get install -y python-pip
sudo apt-get install -y python3-pip
pip install tabulate
pip install bs4

#    SQL stuff:
#        https://www.a2hosting.com/kb/developer-corner/mysql/connecting-to-mysql-using-python
#        https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html

pip install mysql-connector-python

#        TODO add mongodb: pymongo and postgres: Psycopg2 connectors

####################
# gcloud
# From: https://medium.com/@nnilesh7756/how-to-install-and-configure-the-google-cloud-sdk-2fad4a7d3ed7
####################

#    Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

#    Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

#    Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#    Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk

####################
# Sublime Text
####################

#    Install the GPG key:
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

#    Ensure apt is set up to work with https sources:
sudo apt-get install apt-transport-https

#    Select the channel to use:
#        Stable
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

#    install
sudo apt-get update
sudo apt-get install -y sublime-text
