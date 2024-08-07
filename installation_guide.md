# Guía de Instalación

## Instalación de rbenv

1. Instala rbenv y ruby-build:
   ```bash
   curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
   ```
1. Agrega rbenv al PATH:
   ```bash
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
   echo 'eval "$(rbenv init -)"' >> ~/.bashrc
   exec $SHELL
   ```
1. Instala Ruby:
   ```bash
   rbenv install 3.2.2
   rbenv global 3.2.2
   ```
## Instalación de PostgreSQL

1. Sigue las instrucciones en el sitio oficial de PostgreSQL para tu sistema operativo: [Instalar PostgreSQL](https://www.postgresql.org/download/).

## Instalación de Docker y Docker Compose
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker --version
sudo docker compose version
```