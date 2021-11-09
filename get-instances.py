#! /usr/bin/python

import os

sshKeyPath = "~/.ssh/amazon/my.pem"

def getAmazonData():
    # AMZN EC2 INPUT
    # Get instance data by forking to os and doing a bash action

    myFile=os.popen('aws ec2 describe-instances --query "Reservations[*].Instances[*].[KeyName, PublicIpAddress, PrivateIpAddress]" --output=text | grep myName').read()

    # Clean up data

    myData=myFile.strip().split()
    mySanitizedList = []

    for i in range (0, len(myData)):
        if "myName" in myData[i]:
            mySanitizedList.append((myData[i+1],myData[i+2]))

    # User selects to keep or omit instances from AMZN query

    myChosenInstances = []

    for each in mySanitizedList:
        mySelectionPrompt = str(each) + "  KEEP? (y/n) "
        print "\n"
        myChoice= raw_input(mySelectionPrompt)
        if myChoice == "y":
            myChosenInstances.append(each)
        else:
            print str(each) + " has been discarded"
    return myChosenInstances


# Manually add instances by IP
def getManualInstances():
    myNumberOfInstances = raw_input("How many instances are you configuring?\n>  ")
    manualInstanceList = []
    for i in range(0, int(myNumberOfInstances)):
        myGlobalIp = raw_input("\nGlobal IP " + str(i+1) + ": ")
        myLocalIp = raw_input("Local IP " + str(i+1) + ": ")
        manualInstanceList.append((myGlobalIp,myLocalIp))
    return manualInstanceList

# User chooses Amazon, DO, or Manual
userChoice = raw_input("Would you like to \n(1) read amazon instances\n(2) manually enter IPs?\n>  ")
userChoice = str(userChoice)
if userChoice == "1":
    myChosenInstances = getAmazonData()
else:
    myChosenInstances = getManualInstances()


# OUTPUT
myYaml=""
myLeader="""# set path to ssh private key so we can ssh into each node for provisioning
ssh_key_path: """ + sshKeyPath + """

# kubernetes_version is not required, if null rke uses latest
kubernetes_version:

# list of nodes including internal addresses is strongly recommended. 
# user must be set to ubuntu for example for ubuntu ec2 instances for ssh access.
# role must also be defined

nodes:\n"""

myProvider = raw_input("\n1 - Amazon\n2 - DigitalOcean\n>  ")
if myProvider == "1":
    myUser = "ubuntu"
elif myProvider == "2":
    myUser = "root"
else:
    myUser = "root"

myRoles = "[etcd, controlplane, worker]" # TODO: Make roles flexible. Currently a string.

myYaml += myLeader

myYamlHardeningGroup = """    #services:
    #  etcd:
    #    gid: 52034
    #    uid: 52034\n"""

# Build config.yaml

for each in myChosenInstances:
    myYaml += "  - address: " + each[0] + "\n"
    myYaml += "    internal_address: " + each[1] + "\n"
    myYaml += "    user: " + myUser + "\n"
    myYaml += "    role: " + myRoles + "\n"
    myYaml += myYamlHardeningGroup
 
    # create the ssh lines to help manually configure cluster

    print "*****************************************************************"
    print "****  Install Docker and configure user " + each[0] + "   ***\n"

    # Build ssh command

    
    sshLine="ssh ubuntu@" + each[0] + " -oStrictHostKeyChecking=no -i " + sshKeyPath

    # print simple ssh line
    print "\n****  SSH to " + each[0] + "   ***\n"
    print sshLine

    # Build the Docker install line
    print "\n****  Docker install line for " + each[0] + "   ***\n"
    dockerLine = sshLine + " 'curl https://releases.rancher.com/install-docker/20.10.sh | sh && sudo usermod -aG docker " + myUser + "'"
    print dockerLine


    # Build hardening lines
    print "\n****  HARDEN 1 " + each[0] + "   ***\n"
    hardenLine = sshLine
    hardenLine += " 'sudo groupadd --gid 52034 etcd && sudo useradd --uid 52034 --gid 52034 etcd'"
    print hardenLine

    print "\n****  HARDEN 2 " + each[0] + "   ***\n"
    # Harden by adding new kubelet conf
    hardenLine = "scp -oStrictHostKeyChecking=no -i " + sshKeyPath + " 90-kubelet.conf " + myUser + "@" + each[0] + ":~/."
    print hardenLine

    print "\n****  HARDEN 3 " + each[0] + "   ***\n"
    # Move kubelet conf to proper location
    hardenLine = "ssh " + myUser + "@" + each[0] + " -oStrictHostKeyChecking=no -i " 
    hardenLine += sshKeyPath + " -c 'sudo cp ~/90-kubelet.conf /etc/sysctl.d/.'"
    print hardenLine


# Output the constructed yaml file #TODO: just make the file.
print "\n\n############################ config.yaml ############################\n\n"
print myYaml



# python history

# import readline
# for i in range(readline.get_current_history_length()):
#    print.get_history_item(i+1)
