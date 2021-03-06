#!/bin/bash

# Install nagios server instance

# Prereqs:
echo "yum installing gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip"
yum install -y gcc glibc glibc-common gd \
               gd-devel make net-snmp openssl-devel xinetd unzip
# PHP
echo "installing php"
yum -y install php

# Apache

echo "Installing apache..."
yum -y install httpd

#enable and start apache

echo "Enable httpd to start on boot"
systemctl enable httpd
echo "Start the httpd service"
systemctl start httpd
ps awxf | grep httpd

# Add user and group for nagios
echo "Adding user for nagios, group for nagcmd"
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

usermod -a -G nagcmd apache

# Install nagios
echo "curl the 4.2.0 nagios tarball"
cd ~
curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.0.tar.gz
echo "untar nagios tarball"
tar xvzf nagios-*.tar.gz

echo "cd into the build directory, configure and make...this may be slow"
cd nagios-4.2.0

./configure --with-command-group=nagcmd

make all
make install
make install-commandmode
make install-init
make install-config
make install-webconf

# configs:
# bin/install -c -m 775 -o nagios -g nagios -d /usr/local/nagios/etc
# /bin/install -c -m 775 -o nagios -g nagios -d /usr/local/nagios/etc/objects
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/nagios.cfg /usr/local/nagios/etc/nagios.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/cgi.cfg /usr/local/nagios/etc/cgi.cfg
# /bin/install -c -b -m 660 -o nagios -g nagios sample-config/resource.cfg /usr/local/nagios/etc/resource.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/templates.cfg /usr/local/nagios/etc/objects/templates.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/commands.cfg /usr/local/nagios/etc/objects/commands.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/contacts.cfg /usr/local/nagios/etc/objects/contacts.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/timeperiods.cfg /usr/local/nagios/etc/objects/timeperiods.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/localhost.cfg /usr/local/nagios/etc/objects/localhost.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/windows.cfg /usr/local/nagios/etc/objects/windows.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/printer.cfg /usr/local/nagios/etc/objects/printer.cfg
# /bin/install -c -b -m 664 -o nagios -g nagios sample-config/template-object/switch.cfg /usr/local/nagios/etc/objects/switch.cfg


# Apache add to nagios

usermod -G nagcmd apache

# Get and install plugins
echo "curl the plugins tarball"
cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.2.0.tar.gz
echo "untar the tarball"
tar -xvzf nagios-plugins-2.2.0.tar.gz 
cd nagios-plugins-2.2.0
echo "configure, make and install plugins"
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
make install

# get NRPE
echo "curl 2.15 NRPE from sourceforge"
cd ~
curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
echo "untar the NRPE"
tar -xvzf nrpe-2.15*
cd nrpe-2.15
echo "configure, make and install NRPE"
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make all
make install
make install-xinetd
make install-daemon-config

# configure private IP for nagios server
# Modify only_from line: 
# add private IP address of Nagios server (after 127.0.0.1)

LOCALIP=$(gcloud compute instances describe `hostname` --zone=us-central1-c | grep "networkIP" | awk -F ': ' '{ print $2 }')
echo "back up /etc/xinetd.d/nrpe to .orig"
cp /etc/xinetd.d/nrpe /etc/xinetd.d/nrpe.orig
echo "add in local IP of this server"
perl -pi -e "s|127.0.0.1|127.0.0.1 $LOCALIP|g" /etc/xinetd.d/nrpe

# Gimme debug logs please
perl -pi -e 's|debug=0|debug=1|g' /etc/nagios/nrpe.cfg
perl -pi -e 's|dont_blame_nrpe=0|dont_blame_nrpe=1|g' /etc/nagios/nrpe.cfg

echo "restart xinetd to pick up change"
service xinetd restart

echo "nagios is now installed. moving on to configuration\n\n"
echo "back up /usr/local/nagios/etc/nagios.cfg"
cp /usr/local/nagios/etc/nagios.cfg /usr/local/nagios/etc/nagios.cfg.orig
echo "modifying /usr/local/nagios/etc/nagios.cfg"
perl -pi -e "s|#cfg_dir=/usr/local/nagios/etc/servers|cfg_dir=/usr/local/nagios/etc/servers|g" /usr/local/nagios/etc/nagios.cfg

# make an indesx.html for the http checker
touch /var/www/html/index.html

# create directory to store configuration for each server monitored:

mkdir /usr/local/nagios/etc/servers

echo "back up cp /usr/local/nagios/etc/objects/contacts.cfg to .orig"
cp /usr/local/nagios/etc/objects/contacts.cfg /usr/local/nagios/etc/objects/contacts.cfg.orig


echo "add your email to nagios contacts and new contacts for group alerts and sms alerts"
perl -pi -e "s|nagios\x40localhost|jmcsagdc\x40gmail.com
}
define contact {
    contact_name                         high_priority               ; For sms to duty phone
        use                              generic-contact             ; Inherit from generic template above
        alias                            alertpriority               ; Full name of user
        email                            PHONENUMBER\x40tmobile.net  ; The sms forwarder appropriate for carrier
        ;phone                           12062223333                 ; The phone number for the pager BAD USAGE
        service_notification_period             24x7
        service_notification_options            w,u,c,r,f,s         ; do NOT use n here
        service_notification_commands           notify-service-by-pager
        host_notification_period                24x7
        host_notification_options               d,u,r,f,s           ; do NOT use n here
        host_notification_commands              notify-host-by-pager
        }

define contact {
    contact_name                                medium_priority                  ; For sms alerts to phone
        use                                     generic-contact                  ; Inherit from generic template above
        alias                                   alertpriority                    ; Full name of user
        email                                   PHONENUMBER\x40tmobile.net       ; The sms forwarder appropriate for carrier
        service_notification_period             24x7
        service_notification_options            w,u,c,r,f,s                      ; do NOT use n here
        service_notification_commands           notify-service-by-sms            ; Inherit from slim email template
        host_notification_period                24x7
        host_notification_options               d,u,r,f,s                        ; do NOT use n here
        host_notification_commands              notify-host-by-sms               ; Inherit from slim email template
        }

define contact {
    contact_name                                low_priority                ; For email notifications
        use                                     generic-contact             ; Inherit from generic template above
        alias                                   notifypriority              ; Full name of user
        email                                   team_email\x40company.net   ; Alias used for general monitor msgs
        service_notification_period             24x7
        service_notification_options            w,u,c,r,f,s                 ; do NOT use n here
        service_notification_commands           notify-service-by-email
        host_notification_period                24x7                        ; can dial back but users should adjust mail settings instead
        host_notification_options               d,u,r,f,s                   ; do NOT use n here
        host_notification_commands              notify-host-by-email
        }
|g" /usr/local/nagios/etc/objects/contacts.cfg



echo "back up /usr/local/nagios/etc/objects/commands.cfg to .orig"
cp /usr/local/nagios/etc/objects/commands.cfg /usr/local/nagios/etc/objects/commands.cfg.orig
echo "add in a command to the end of the file"
echo "define command{
command_name check_nrpe
command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}

# 'notify-service-by-sms' command definition
define command{
command_name notify-service-by-sms
command_line /usr/bin/print '*** Nagios Alert*** $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$1' | /usr/local/bin/gnokii --sendsms $CONTACTPAGER$
}

# 'notify-host-by-sms' command definition
define command{
command_name notify-host-by-sms
command_line /usr/bin/printf '*** Nagios Alert*** $NOTIFICATIONTYPE$ : Host $HOSTALIAS$ is $HOSTSTATE$' | /usr/local/bin/gnokii --sendsms $CONTACTPAGER$
}

# 'notify-service-by-pager' command definition
define command{
command_name notify-service-by-pager
command_line /usr/bin/print '*** Nagios Alert*** $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$1' | /usr/local/bin/gnokii --sendsms $CONTACTPAGER$
}

# 'notify-host-by-pager' command definition
define command{
command_name notify-host-by-pager
command_line /usr/bin/printf '*** Nagios Alert*** $NOTIFICATIONTYPE$ : Host $HOSTALIAS$ is $HOSTSTATE$' | /usr/local/bin/gnokii --sendsms $CONTACTPAGER$
}
" >> /usr/local/nagios/etc/objects/commands.cfg

# Apache
echo "configure apache"

htpasswd -cb /usr/local/nagios/etc/htpasswd.users nagiosadmin Passw0rd
echo "Passw0rd" > /root/nagiosadmin_password
chmod 600 /root/nagiosadmin_password

echo "fix permissions in nagios libs"
chown nagios. /usr/local/nagios/libexec/*

# Enable Nagios to start on boot
echo "chkconfig nagios on"
chkconfig nagios on

echo "start nagios and restart httpd"
systemctl start nagios.service
systemctl restart httpd.service

echo "*********************************************************************************************
NAGIOS email lists:
https://lists.sourceforge.net/lists/listinfo/nagios-announce
To post a message to all the list members, send email to nagios-announce@lists.sourceforge.net

https://lists.sourceforge.net/lists/listinfo/nagios-users
To post a message to all the list members, send email to nagios-users@lists.sourceforge.net
*********************************************************************************************

To fix your configs if there are issues, check the following first:
nano /usr/local/bin/gnokii
nano /usr/local/nagios/etc/objects/commands.cfg
nano /usr/local/nagios/etc/objects/contacts.cfg
nano /usr/local/nagios/etc/servers/server-<**SERVER NAME**>-final.cfg

use the following command with your user to make it possible to copy in server configs:
usermod -a -G nagios <USERNAME>

"
# Make it possible to copy in server configs. Add your user to nagios group to use.
chown nagios. /usr/local/nagios/etc/servers
chmod 775 /usr/local/nagios/etc/servers
echo "DONE!"
