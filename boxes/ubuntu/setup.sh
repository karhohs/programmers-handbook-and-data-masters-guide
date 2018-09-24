

# nvidia titan v
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get -y update
sudo apt-get -y install nvidia-(press tab to see latest)

# productivity
sudo apt-get -y install tmux nano

# certificate for internet security
sudo apt-get -y update
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get -y update
sudo apt-get -y install certbot

# The certificate will have to manually installed. 
# sudo certbot certonly