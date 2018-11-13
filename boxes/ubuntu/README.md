# Setting up a linux machine with awesome powers.

# Getting the distro
1. I like using the latest Ubuntu LTS desktop version, which in 2018 was 18.04. From another machine, I used a Dell XPS 13 Windows laptop, flash a USB drive with the Ubuntu ISO using the [etcher.io software](https://etcher.io/).
1. Insert the USB drive into the linux box and boot from the USB drive. Follow the prompts to install Ubuntu. I chose to erase the disk and use LVM.
  1. I needed a monitor and keyboard hooked up to the linux box to navigate this installation menu. Later, after SSH is setup, we can configure the linux box remotely.

# Setting up SSH
```bash
sudo apt-get -y install ssh net-tools tmux git dtrx
```

## Allow SSH through the default ufw firewall
To see firewall, `ufw status`

```bash
sudo ufw allow OpenSSH
sudo ufw allow 8000
sudo ufw allow 'Apache Full'
sudo ufw delete allow 'Apache'
sudo ufw enable
```

1. At this point a remote connection can be used to finish the setup. Port forwarding to port 22 on the internal network may be required. *Note, using a Netgear R7000, I found I had to use the external IP address to connect remotely to the box, even from a machine on the same internal network.*

# Static IP for convenient port forwarding
My home network is somewhat unreliable and I must occasionally restart my router. When this happens, IP addresses will be reassigned to my devices, including the linux box. Configuring a static IP will make sure the network configuration is preserved when the network is reset.

To get the name of the network interface use the command `ifconfig -a`. My box has a network identifier `enp0s31f6`.

Create a network configuration yaml file, `sudo nano /etc/netplan/01-netcfg.yaml`.

Enter the following into the file:

```
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
 version: 2
 renderer: networkd
 ethernets:
  enp0s31f6:
   dhcp4: no
   addresses: [192.168.1.251/24]
   gateway4: 192.168.1.1
   nameservers:
    addresses: [8.8.8.8,8.8.4.4]
```

Set the config with `sudo netplan apply`.

## Create an ssh key for ssh key login
`ssh-keygen`

If connecting remotely from a Windows computer using mRemoteNG the private ssh key will need to be converted to ppk file using puttygen.

Add the public ssh key to authorized keys: `cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`

# Make ssh key mandatory
`sudo nano /etc/ssh/sshd_config` then uncomment and set the line `PasswordAuthentication no`. Then `sudo service ssh restart`.

Make sure the ssh key for GitHub and GitLab are on the server in the ~/.ssh

# Add new private keys to the ssh-agent

Add `TCPKeepAlive yes` to `/etc/ssh/ssh_config` using nano. This helps stabilize ssh connections.

Then use the command
```
eval `ssh-agent -s`
```

Change the permissions so they are not unprotected

sudo chmod 600 ~/.ssh/id_rsa

sudo chmod 700 ~/.ssh

ssh-add ~/.ssh/id_rsa

`nano ~/.ssh/config`

```
Host github.com
        Hostname github.com
        User git
        IdentityFile ~/.ssh/id_rsa_github

Host gitlab.com
        Hostname gitlab.com
        User git
        IdentityFile ~/.ssh/id_rsa_gitlab
```

# Install miniconda

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
For convenience add miniconda to the .bashrc PATH when prompted during the installation process. Do this for each user and make miniconda accessible by the group.

`sudo chgrp -R astronautninjas ~/miniconda3`

## For each user to do...
`echo 'export PATH="/home/kyleroot/miniconda3/bin:$PATH"' >> /home/user/.bashrc`

## Setup for all users
`conda config --write-default`




### Register a domain with Google Domains
Go to google domains and register a domain.

Add an *A record* that points to the IP address of the box.
Add a *CNAME record* that maps www to domain name.

#### Install Apache
https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-18-04
```
sudo apt install apache2

sudo mkdir -p /var/www/example.com/html

sudo chown -R $USER:$USER /var/www/example.com/html

sudo chmod -R 755 /var/www/example.com

nano /var/www/example.com/html/index.html

<html>
    <head>
        <title>Welcome to Example.com!</title>
    </head>
    <body>
        <h1>Success!  The example.com server block is working!</h1>
    </body>
</html>

sudo nano /etc/apache2/sites-available/example.com.conf

<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/example.com/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

sudo a2ensite example.com.conf

sudo a2dissite 000-default.conf

sudo apache2ctl configtest

sudo systemctl restart apache2
```

### Let's Encrypt
https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-18-04
```
$ sudo apt-get update
$ sudo apt-get -y install software-properties-common
$ sudo add-apt-repository ppa:certbot/certbot
$ sudo apt-get update
$ sudo apt-get -y install python-certbot-apache
```

```
sudo certbot --apache -d example.com -d www.example.com
```

Choose to redirect to SSL. Record the location of the certificate files, typically `/etc/letsencrypt/live/example.com`.

Change permission of certificates

`sudo chown -R $USER:$USER /etc/letsencrypt`

### redirect
https://www.digitalocean.com/community/tutorials/how-to-redirect-www-to-non-www-with-apache-on-ubuntu-14-04
Let's Encrypt will create a new config file for the apache2 virtual host.

It will be named `/etc/apache2/sites-available/example.com-le-ssl.conf`. Use nano.

Add these lines between <VirtualHost \*:443>
```
<Directory /var/www/example.com/>
  RewriteEngine On
  RewriteBase /
  RewriteCond %{HTTP_HOST} !^www\. [NC]
  RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]
</Directory>
```

# Jupyter Hub
Note that the conda installation will install jupyterhub into the current or home directory. Wherever jupyterhub gets installed, remember the path information, because it is necessary for setting up a systemd process for jupyterhub.

```
conda install -c conda-forge jupyterhub  # installs jupyterhub and proxy
conda install notebook  # needed if running the notebook servers locally
```
https://github.com/jupyterhub/jupyterhub/issues/470


### Config Jupyterhub
`jupyterhub --generate-config`

`pip install oauthenticator`

#### Oauth with GitLab
callback uri = `https://www.example.com:8000/hub/oauth_callback`

Add the following to jupyterhub_config.py using nano `nano ~/jupyterhub_config.py`
```
from oauthenticator.gitlab import GitLabOAuthenticator

## This is an application.
# This is an application.
c.JupyterHub.authenticator_class = 'oauthenticator.gitlab.GitLabOAuthenticator'
c.GitLabOAuthenticator.oauth_callback_url = 'https://www.example.com:8000/hub/oauth_callback'
c.GitLabOAuthenticator.client_id = 'abcd0123'
c.GitLabOAuthenticator.client_secret = '0123abcd$
```


When editing the jupyterhub config file, point the key to the Let's Encrypt Certificate.

```
c.JupyterHub.ssl_cert = '/etc/letsencrypt/live/example.com/fullchain.pem'
c.JupyterHub.ssl_key = '/etc/letsencrypt/live/example.com/privkey.pem'
```

```
sudo nano userlist

`myuser admin`
```

```
sudo adduser myuser

sudo mkdir /home/myuser/notebooks

sudo chown myuser:myuser /home/myuser/notebooks

sudo nano jupyterhub_config.py
c.Authenticator.whitelist = {'nipunsadvilkar', 'manasRK', 'Benybrahim'}
c.Authenticator.admin_users = {'nipunsadvilkar', 'manasRK'}
c.LocalAuthenticator.create_system_users = True
c.Spawner.notebook_dir = '~/notebooks'
```

`sudo adduser myuser sudo` if you want users to be sudo.

Jupyterhub must be run from the directory where it was installed. For conda installation this is the home directory.
`sudo env "PATH=$PATH" jupyterhub`

### configure environments

`git clone git@gitlab.com:foobar/foobar.git`
`git@github.com:karhohs/programmers-handbook-and-data-masters-guide.git`

`conda env create -f foobar_python_linux.yml`
`source activate foobar`

`sudo env "PATH=$PATH"  python -m ipykernel install --name foobar`

#start jupyterhub at startup
https://github.com/jupyterhub/jupyterhub/wiki/Run-jupyterhub-as-a-system-service#ubuntudebian-anaconda3-with-systemd

```
[Unit]
Description=Jupyterhub
After=syslog.target network.target

[Service]
User=root
Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin::/home/foobar/miniconda3/bin"
ExecStart=/home/foobar/miniconda3/bin/jupyterhub -f /home/foobar/jupyterhub_config.py

[Install]
WantedBy=multi-user.target
```
`sudo systemctl daemon-reload`
`sudo systemctl enable jupyterhub`

# Additional hard drives
https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
Find the disk.
`lsblk`
Initially, it won't have any partitions. Mine was listed as `sda` and type `disk`. If any partitions exist they'll be listed in a tree with type `part`.

Similarly `sudo parted -l` will show new disks and whether or not there is a partition table.

Create a single partition that spans the entire disk. **Make sure the disk identifier is correct, because these operations can lead to unintentional data loss.**

`sudo parted /dev/sda mklabel gpt`

`sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%`

Check to see that a partition has been created using `lsblk`

Create a filesystem on the new partition.

`sudo mkfs.ext4 -L datapartition /dev/sda1`

Mount the new filesystem by updating fstab, so that the disk mounts at boot.

Create the mount point. `sudo mkdir -p /mnt/data`

Get the UUID of the filesystem. `sudo lsblk --fs`
26eae060-7db5-468d-bea9-b45c2d399cc8
`sudo nano /etc/fstab`

e.g. `UUID=abcdefgh-0000-0000-0000-abcd0000efgh0000      /mnt/data       ext4    defaults        0       2`

reboot

Check to see if the disk is mounted with `df -h -x tmpfs -x devtmpfs | grep /dev/sda1`

# Make a group for users
sudo groupadd astronautninjas

sudo usermod -a -G astronautninjas kyle

## Make group the owners of a folder in /mnt/data

`sudo chgrp -R astronautninjas /mnt/data/mydata`
`sudo chmod -R 775 /mnt/data/mydata`


# Docker


# Nvidia drivers


```
sudo add-apt-repository ppa:graphics-drivers/ppa

sudo apt update

sudo ubuntu-drivers autoinstall

sudo reboot

sudo apt install nvidia-cuda-toolkit gcc-6

nvcc --version

nvidia-smi
```
GPU monitoring:
`whereis nvidia-smi`

`sudo nano /etc/systemd/system/nvidia-smi-daemon.service`

```
[Unit]
Description=nvidia-smi daemon
After=multi-user.target

[Service]
User=root
Type=forking
ExecStart=/usr/bin/nvidia-smi daemon -d 60
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

`sudo systemctl daemon-reload`
`sudo systemctl enable nvidia-smi-daemon.service`

Location of logs /var/log/nvstats/

For realtime monitioring...
To check GPU usage `watch gpustat` or `watch nvidia-smi`

To get the NVIDIA logs
`sudo nvidia-smi replay -f /var/log/nvstats/nvstats-YYYYMMDD -r nvstats-YYYYMMDD.csv`
