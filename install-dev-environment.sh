####################
# Let's just install a bunch of useful stuff for 
# a development test system. Source control, ssh, etc.
#
# No security considerations are handled. Use with care.
# For exaample, DOCKER runs as root and GITHUB repos can
# be made by anyone...so know your sources.
####################
echo "sudo apt-get update" 2>&1 | tee /root/install.LOG
sudo apt-get update
echo "sudo apt-get install -y tree htop inetutils-traceroute"
sudo apt-get install -y tree htop inetutils-traceroute 2>&1 | tee /root/install.LOG

####################
# SSH
####################
####################
# Let's just install a bunch of useful stuff for 
# a development test system. Source control, ssh, etc.
#
# No security considerations are handled. Use with care.
# For exaample, DOCKER runs as root and GITHUB repos can
# be made by anyone...so know your sources.
####################
echo "sudo apt-get update" 2>&1 | tee -a /root/install.LOG
sudo apt-get update
echo "sudo apt-get install -y tree htop inetutils-traceroute"
sudo apt-get install -y tree htop inetutils-traceroute 2>&1 | tee -a /root/install.LOG

####################
# SSH
####################

echo "apt-get install openssh-server"
sudo apt-get install -y openssh-server 2>&1 | tee -a /root/install.LOG
sudo systemctl enable ssh 2>&1 | tee -a /root/install.LOG
sudo systemctl start ssh 2>&1 | tee -a /root/install.LOG

####################
# curl
####################

echo "apt-get install curl"
sudo apt-get install -y curl 2>&1 | tee -a /root/install.LOG

####################
# Docker
####################

echo "curl docker repo key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2>&1 | tee -a /root/install.LOG
echo "add repo key"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 2>&1 | tee -a /root/install.LOG
echo "apt-get update"
sudo apt-get update

#   The next command is an opportunity to add scripted validation
echo "apt-cache policy check...should not error"
apt-cache policy docker-ce 2>&1 | tee -a /root/install.LOG

echo "install docker"
sudo apt-get install -y docker-ce 2>&1 | tee -a /root/install.LOG
#   Docker is installed

#   The next command is an opportunity to add scripted validation
echo "check docker status"
sudo systemctl status docker 2>&1 | tee -a /root/install.LOG

#    Executing docker as your user instead of sudo to root
echo "allow non-root user docker access"
sudo usermod -aG docker ${USER}
#    This change is not picked up until next login or next shell

#   The next command is an opportunity to add scripted validation...for now, just no error is good
echo "check docker runs"
docker info 2>&1 | tee -a /root/install.LOG

#    Suggested quick things to expedite using it when you need it: grab a few base images
echo "Preloading a bunch of docker images: centos, ubuntu, lamp, shakaplayer, pysql"
#        SQL servers
docker pull mysql 2>&1 | tee -a /root/install.LOG
docker pull postgres 2>&1 | tee -a /root/install.LOG
#        Linux distos
docker pull centos 2>&1 | tee -a /root/install.LOG
docker pull ubuntu 2>&1 | tee -a /root/install.LOG
#        Full stack
docker pull linode/lamp 2>&1 | tee -a /root/install.LOG
docker pull jasonmakescoolstuff/shakaplayer:latest 2>&1 | tee -a /root/install.LOG
docker pull jasonmakescoolstuff/pysql 2>&1 | tee -a /root/install.LOG

####################
# Python Stuff
####################
echo "Install python pip and pip3"
sudo apt-get install -y python-pip 2>&1 | tee -a /root/install.LOG
sudo apt-get install -y python3-pip 2>&1 | tee -a /root/install.LOG

echo "pip install for 2.7 tabulate and bs4"
pip install tabulate 2>&1 | tee -a /root/install.LOG
pip install bs4 2>&1 | tee -a /root/install.LOG

#    SQL stuff:
#        https://www.a2hosting.com/kb/developer-corner/mysql/connecting-to-mysql-using-python
#        https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html

echo "pip install mysql-connector-python"
pip install mysql-connector-python 2>&1 | tee -a /root/install.LOG

#        TODO add mongodb: pymongo and postgres: Psycopg2 connectors

####################
# gcloud
# From: https://medium.com/@nnilesh7756/how-to-install-and-configure-the-google-cloud-sdk-2fad4a7d3ed7
####################

echo "Setting up gcloud google cloud service"
#    Create an environment variable for the correct distribution
echo "export CLOUD_SDK_REPO environment variable"
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" 2>&1 | tee -a /root/install.LOG

#    Add the Cloud SDK distribution URI as a package source
echo "add cloud repo for sdk"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
echo "output of above not tee to install.LOG since that'd be a second tee..."
echo "in one line which I don't klnow the end result of atm"

#    Import the Google Cloud Platform public key
echo "curl google cloud public key"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 2>&1 | tee -a /root/install.LOG

#    Update the package list and install the Cloud SDK
echo "install google cloud sdk"
sudo apt-get update 2>&1 | tee -a /root/install.LOG
sudo apt-get install google-cloud-sdk 2>&1 | tee -a /root/install.LOG

####################
# Sublime Text
####################

echo "Install sublime text"
#    Install the GPG key:
echo  "wget the sublime text repo apt-key"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - 2>&1 | tee -a /root/install.LOG

#    Ensure apt is set up to work with https sources:
echo "set up apt for https sources"
sudo apt-get install apt-transport-https 2>&1 | tee -a /root/install.LOG

#    Select the channel to use:
#        Stable
echo "get sublime text repo info...not copied to install.LOG since another tee is in here"
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee -a /etc/apt/sources.list.d/sublime-text.list

#    install
echo "actually install the sublime text now"
sudo apt-get update
sudo apt-get install -y sublime-text 2>&1 | tee -a /root/install.LOG

echo "DONE" 2>&1 | tee -a /root/install.LOG

echo "apt-get install openssh-server"
sudo apt-get install -y openssh-server 2>&1 | tee /root/install.LOG
sudo systemctl enable ssh 2>&1 | tee /root/install.LOG
sudo systemctl start ssh 2>&1 | tee /root/install.LOG

####################
# curl
####################

echo "apt-get install curl"
sudo apt-get install -y curl 2>&1 | tee /root/install.LOG

####################
# Docker
####################

echo "curl docker repo key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2>&1 | tee /root/install.LOG
echo "add repo key"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 2>&1 | tee /root/install.LOG
echo "apt-get update"
sudo apt-get update

#   The next command is an opportunity to add scripted validation
echo "apt-cache policy check...should not error"
apt-cache policy docker-ce 2>&1 | tee /root/install.LOG

echo "install docker"
sudo apt-get install -y docker-ce 2>&1 | tee /root/install.LOG
#   Docker is installed

#   The next command is an opportunity to add scripted validation
echo "check docker status"
sudo systemctl status docker 2>&1 | tee /root/install.LOG

#    Executing docker as your user instead of sudo to root
echo "allow non-root user docker access"
sudo usermod -aG docker ${USER}
#    This change is not picked up until next login or next shell

#   The next command is an opportunity to add scripted validation...for now, just no error is good
echo "check docker runs"
docker info 2>&1 | tee /root/install.LOG

#    Suggested quick things to expedite using it when you need it: grab a few base images
echo "Preloading a bunch of docker images: centos, ubuntu, lamp, shakaplayer, pysql"
#        SQL servers
docker pull mysql 2>&1 | tee /root/install.LOG
docker pull postgres 2>&1 | tee /root/install.LOG
#        Linux distos
docker pull centos 2>&1 | tee /root/install.LOG
docker pull ubuntu 2>&1 | tee /root/install.LOG
#        Full stack
docker pull linode/lamp 2>&1 | tee /root/install.LOG
docker pull jasonmakescoolstuff/shakaplayer:latest 2>&1 | tee /root/install.LOG
docker pull jasonmakescoolstuff/pysql 2>&1 | tee /root/install.LOG

####################
# Python Stuff
####################
echo "Install python pip and pip3"
sudo apt-get install -y python-pip 2>&1 | tee /root/install.LOG
sudo apt-get install -y python3-pip 2>&1 | tee /root/install.LOG

echo "pip install for 2.7 tabulate and bs4"
pip install tabulate 2>&1 | tee /root/install.LOG
pip install bs4 2>&1 | tee /root/install.LOG

#    SQL stuff:
#        https://www.a2hosting.com/kb/developer-corner/mysql/connecting-to-mysql-using-python
#        https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html

echo "pip install mysql-connector-python"
pip install mysql-connector-python 2>&1 | tee /root/install.LOG

#        TODO add mongodb: pymongo and postgres: Psycopg2 connectors

####################
# gcloud
# From: https://medium.com/@nnilesh7756/how-to-install-and-configure-the-google-cloud-sdk-2fad4a7d3ed7
####################

echo "Setting up gcloud google cloud service"
#    Create an environment variable for the correct distribution
echo "export CLOUD_SDK_REPO environment variable"
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" 2>&1 | tee /root/install.LOG

#    Add the Cloud SDK distribution URI as a package source
echo "add cloud repo for sdk"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
echo "output of above not tee to install.LOG since that'd be a second tee..."
echo "in one line which I don't klnow the end result of atm"

#    Import the Google Cloud Platform public key
echo "curl google cloud public key"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 2>&1 | tee /root/install.LOG

#    Update the package list and install the Cloud SDK
echo "install google cloud sdk"
sudo apt-get update 2>&1 | tee /root/install.LOG
sudo apt-get install google-cloud-sdk 2>&1 | tee /root/install.LOG

####################
# Sublime Text
####################

echo "Install sublime text"
#    Install the GPG key:
echo  "wget the sublime text repo apt-key"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - 2>&1 | tee /root/install.LOG

#    Ensure apt is set up to work with https sources:
echo "set up apt for https sources"
sudo apt-get install apt-transport-https 2>&1 | tee /root/install.LOG

#    Select the channel to use:
#        Stable
echo "get sublime text repo info...not copied to install.LOG since another tee is in here"
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

#    install
echo "actually install the sublime text now"
sudo apt-get update
sudo apt-get install -y sublime-text 2>&1 | tee /root/install.LOG

echo "DONE" 2>&1 | tee /root/install.LOG
