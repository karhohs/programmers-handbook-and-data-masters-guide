# Setting up a linux machine with awesome powers.

# Getting the distro
1. I like using the latest Ubuntu LTS desktop version, which in 2018 was 18.04. From another machine, I used a Dell XPS 13 Windows laptop, flash a USB drive with the Ubuntu ISO using the etcher.io software.
1. Insert the USB drive into the linux box and boot from the USB drive. Follow the prompts to install Ubuntu.
  1. I needed a monitor and keyboard hooked up to the linux box to navigate this installation menu. Later, after SSH is setup, we can configure the linux box remotely.

# Setting up SSH

```bash
sudo apt-get -y install ssh
```

## Allow SSH through the default ufw firewall
To see firewall, `ufw status`

```bash
ufw allow OpenSSH
ufw enable
```

1. At this point a remote connection can be used to finish the setup. Port forwarding to port 22 on the internal network may be required. *Note, using a Netgear R7000, I found I had to use the external IP address to connect remotely to the box, even from a machine on the same internal network.*

# Static IP for convenient port forwarding
My home network is somewhat unreliable and I must occasionally restart my router. When this happens, IP addresses will be reassigned to my devices, including the linux box. Configuring a static IP will make sure the network configuration is preserved when the network is reset.

To get the name of the network adapter use the command `ifconfig -a`. My box has a network identifier `enp0s31f6`.

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
`sudo nano /etc/ssh/sshd_config` then uncomment at set `PasswordAuthentication no`. Then `sudo service ssh restart`.

Make sure the ssh key for GitHub and GitLab are on the server in the ~/.ssh
# Add new private keys to the ssh-agent

Add `TCPKeepAlive yes` to `/etc/ssh/ssh_config`

eval `ssh-agent -s`

Change the permissions so they are not unprotected

sudo chmod 600 ~/.ssh/id_rsa

ssh-add ~/.ssh/id_rsa

# Install miniconda

`sudo apt-get install tmux`

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
For convenience add miniconda to the .bashrc PATH.

# Install git
```
sudo apt install git
```

### Register a domain with Google Domains
Go to google domains and register a domain.

Add an *A record* that points to the IP address of the box.
Add a *CNAME record* that maps www to domain name.


#### Install Apache
https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-18-04

```
sudo apt install apache2
sudo ufw allow 'Apache'
```



### Let's Encrypt
https://certbot.eff.org/lets-encrypt/ubuntuxenial-other

```
$ sudo apt-get update
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:certbot/certbot
$ sudo apt-get update
$ sudo apt-get install certbot
```

`sudo certbot certonly`

Choose standalone and follow the prompts. Record the location of the certificate files.

Change permission of certificates

`sudo chown -R kyle:kyle /etc/letsencrypt`
### Let's Encrypt
https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-18-04


####

```
$ sudo apt-get update
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:certbot/certbot
$ sudo apt-get update
$ sudo apt-get install certbot
```

`sudo certbot certonly`

Choose standalone and follow the prompts. Record the location of the certificate files.

Change permission of certificates

`sudo chown -R kyle:kyle /etc/letsencrypt`

https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-18-04




# Jupyter Hub
conda install -c conda-forge jupyterhub  # installs jupyterhub and proxy
conda install notebook  # needed if running the notebook servers locally
https://github.com/jupyterhub/jupyterhub/issues/470



Update Jupyterhub
`nano ~/.jupyter/jupyter_notebook_config.py` and change the following:
```
c.NotebookApp.certfile = u'/etc/letsencrypt/live/mywebsite.com/fullchain.pem'
c.NotebookApp.keyfile = u'/etc/letsencrypt/live/mywebsite.com/fullchain.pem'

c.NotebookApp.open_browser = False
```
### configure environments


`git clone git@gitlab.com:foobar/foobar.git`
`git@github.com:karhohs/programmers-handbook-and-data-masters-guide.git`

`conda env create -f foobar_python_linux.yml`
`source activate foobar`

`sudo python -m ipykernel install --name foobar`

#start jupyterhub at startup
https://github.com/jupyterhub/jupyterhub/wiki/Run-jupyterhub-as-a-system-service

which jupyterhub

Add full path to the jupyterhub sqlite file in jupyter_config.py.

`sudo systemctl enable jupyterhub.service`

## the sudo PATH
By default sudo uses a secure_path defined in the visudo configuration file. This will prevent `sudo jupyterhub` from running.

Add the admin user to the exempt_group to circumvent this default security measure.

First, `sudo visudo`. Then add this line `Defaults exempt_group=bigtuna`. Be careful, because this always disables the need to enter a password to use sudo powers.

`sudo ufw allow 8000`


https://github.com/jupyterhub/jupyterhub/wiki/Installation-of-Jupyterhub-on-remote-server


Update Jupyterhub
`nano ~/.jupyter/jupyter_notebook_config.py` and change the following:
```
c.NotebookApp.certfile = u'/etc/letsencrypt/live/karhohs.com/fullchain.pem'
c.NotebookApp.keyfile = u'/etc/letsencrypt/live/karhohs.com/fullchain.pem'

c.NotebookApp.open_browser = False
```

*Just for reference...*
### Add SSL
https://github.com/jupyterhub/jupyterhub/wiki/Installation-of-Jupyterhub-on-remote-server

#### openssl
https://testnb.readthedocs.io/en/stable/examples/Notebook/Configuring%20the%20Notebook%20and%20Server.html
```
When you connect to a notebook server over HTTPS using a self-signed certificate, your browser will warn you of a dangerous certificate because it is self-signed. If you want to have a fully compliant certificate that will not raise warnings, it is possible (but rather involved) to obtain one, as explained in detail in this tutorial
```
Therefore, this may not be the best method.
`openssl req ­-x509 ­-nodes ­-days 365 ­-newkey rsa:1024 ­-keyout mykey.key ­-out mycert.pem`

*...now back to the configuration.*

### Config Jupyterhub
`jupyterhub --generate-config`

`sudo apt install python3-pip`

`pip3 install oauthenticator`

When editing the jupyterhub config file, point the key to the Let's Encrypt Certificate.

#### Oauth with GitHub
callback uri = `https://www.mywebsite.com:8000/hub/oauth_callback`

Add the following to jupyterhub_config.py
```
from oauthenticator.gitlab import GitLabOAuthenticator

## This is an application.
# This is an application.
c.JupyterHub.authenticator_class = 'oauthenticator.gitlab.GitLabOAuthenticator'
c.GitLabOAuthenticator.oauth_callback_url = 'https://www.mywebsite.com:8000/hub/oauth_callback'
c.GitLabOAuthenticator.client_id = 'abcd0123'
c.GitLabOAuthenticator.client_secret = '0123abcd$
```


### redirect
Let's Encrypt will create a new config file for the apache2 virtual host.

It will be named `mywebsite.com-le-ssl.conf`
Add these lines between <VirtualHost \*:443>
```
<Directory /var/www/mywebsite.com/>
        # match any URL with www and rewrite it to https without the www
        RewriteEngine On
        RewriteBase /
        RewriteCond %{HTTP_HOST} !^www\. [NC]
        RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]
</Directory>
```
```
<Directory /var/www/mywebsite.com>
Options FollowSymLinks
AllowOverride all
Require all granted
</Directory>

RewriteEngine On
RewriteCond %{HTTP_HOST} !^localhost
RewriteCond %{HTTP_HOST} !^127.0.0.1
RewriteCond %{HTTP_HOST} !^www\.
RewriteRule ^ http%{ENV:protossl}://www.%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
RewriteCond %{HTTPS} !on
RewriteRule ^/(.*) https://%{SERVER_NAME}/$1 [R,L]

```


```
ServerAdmin admin@mywebsite.com
ServerName mywebsite.com
ServerAlias www.mywebsite.com
DocumentRoot /var/www/mywebsite.com/html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
RewriteEngine on
RewriteCond %{SERVER_NAME} =www.mywebsite.com [OR]
RewriteCond %{SERVER_NAME} =mywebsite.com
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]

```

## Install Jupyter

```
conda install -c conda-forge jupyterlab
jupyter notebook --generate-config
```

`nano ~/.jupyter/jupyter_notebook_config.py` and change the following:

```
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '0.0.0.0'
```

Add a password `jupyter notebook password`


# Blog

## Install Discourse
Discourse is the best for discussion and comments.
https://www.discourse.org/
https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md
https://meta.discourse.org/t/embedding-discourse-comments-via-javascript/31963
## Hugo
https://gohugo.io/

`sudo snap install hugo`


# Docker

# Nvidia drivers
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt-get install nvidia-(press tab to see latest)
```
