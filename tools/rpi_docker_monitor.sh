#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

function check_internet() {
  printf "Checking if you are online..."
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo "Online. Continuing."
  else
    error "Offline. Go connect to the internet then run the script again."
  fi
}

check_internet

echo "Creating directories..."
sudo mkdir -p /portainer/files/appdata/config/prometheus/config || error "Failed to create config directory!"
sudo mkdir -p /portainer/files/appdata/config/prometheus/data || error "Failed to create data directory for Prometheus!"
sudo mkdir -p /portainer/files/appdata/config/grafana/data || error "Failed to create data directory for Grafana!"
echo "Downloading Prometheus config files if they don't exist"
if [ -d /portainer/files/appdata/config/prometheus/config/prometheus.yml ];
then
    echo "/portainer/files/appdata/config/prometheus/config/prometheus.yml is a directory removing"
    rm -rf '/portainer/files/appdata/config/prometheus/config/prometheus.yml/'
fi

if [ ! -f /portainer/files/appdata/config/prometheus/config/prometheus.yml ]; 
then
	sudo wget -O /portainer/files/appdata/config/prometheus/config/prometheus.yml https://raw.githubusercontent.com/oijkn/Docker-Raspberry-PI-Monitoring/main/prometheus/prometheus.yml || error "Failed to download prometheus.yml file!"
fi

if [ -d /portainer/files/appdata/config/grafana/grafana.ini ];
then
    echo "/portainer/files/appdata/config/grafana/grafana.ini is a directory removing"
    rm -rf '/portainer/files/appdata/config/grafana/grafana.ini'
fi
sudo touch /portainer/files/appdata/config/grafana/grafana.ini || error "Failed to touch grafana.ini file!"
echo "Setting permissions..."
sudo chown -R 472:472 /portainer/files/appdata/config/grafana/data || error "Failed to set permissions for Grafana data!"
echo "Done You are ready to goto next step in the install document"
