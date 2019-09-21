####################
# Let's just install a bunch of useful stuff for 
# a development test system. Source control, ssh, etc.
#
# No security considerations are handled. Use with care.
# For exaample, DOCKER runs as root and GITHUB repos can
# be made by anyone...so know your sources.
####################


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

####################
# Python Stuff
####################



####################
# Git
####################


