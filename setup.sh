# Add Docker's official GPG key:
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install the docker packages
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user to the docker group
sudo groupadd -f docker
sudo usermod -aG docker $USER

# Configure Docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Free up port 53 for pihole
sudo sed -i 's/^\#DNSStubListener=yes$/DNSStubListener=no/' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

# Create data directory
source .env
sudo mkdir -p /data
sudo chown $PUID:$GUID /data
mkdir -p /data/torrents/movies
mkdir -p /data/torrents/tv
mkdir -p /data/media/movies
mkdir -p /data/media/tv
