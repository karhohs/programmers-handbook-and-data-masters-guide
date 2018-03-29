Setting up a linux machine with awesome powers.

# Jupyter server

## Install miniconda

`sudo apt-get install tmux`

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
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

Update other
`nano ~/.jupyter/jupyter_notebook_config.py` and change the following:
```
c.NotebookApp.certfile = u'/etc/letsencrypt/live/karhohs.com/fullchain.pem'
c.NotebookApp.keyfile = u'/etc/letsencrypt/live/karhohs.com/fullchain.pem'

c.NotebookApp.open_browser = False
```

Change permission of certificates

`sudo chown -R kyle:kyle /etc/letsencrypt`

#### Register a domain with Google Domains


## Start Jupyter

`jupyter lab`

# Blog

## Install Discourse
Discourse is the best for discussion and comments.
https://www.discourse.org/
https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md
https://meta.discourse.org/t/embedding-discourse-comments-via-javascript/31963
## Hugo
https://gohugo.io/

`sudo snap install hugo`


## nginx
https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04

# Docker

# Nvidia drivers
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt-get install nvidia-(press tab to see latest)
```
