#!/bin/bash

base64 -d <<< "H4sIAAAAAAAAA41QwQ3DQAj7M4V/TaVKt0BHOYkM4uGLDWrUvgK6YINxcgl0ZOXd+FNGdWr9yCdY
tbD5ZTzNGYmzMhWWZVks5DntgtjNrSEeiVNNeGReT67mXmMQR7IxYRvzsbjS3zkJvFtKSQI78yVc
dWtNPOl7WNFHozVY7CuVhV64bv/Kn+jViA/t/qcplAEAAA==" | gunzip

# Detect package manager
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [ "apt" = ${osInfo[$f]} ] ; then
        PKGFLG=1
    fi
done


if [ $PKGFLG -eq 1 ]
then

echo "Monkey can smell debian or debian variant distro."
echo "Monkey starting his wrenching...................."

# Check if curl is installed
if [ ! -x /usr/bin/curl ] ; then
CURL_NOT_EXIST=1
apt install -y curl
else
CURL_NOT_EXIST=0
fi

echo "Monkey installing dependencies......................."

# Install packages
apt update
apt install -y mariadb-server git

#Add Git user
adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git

#--------------------------------------------------------------------------------------------

systemctl start mariadb
systemctl enable mariadb
echo "Monkey Creating gitea database......................."
read -sp 'Enter password for gitea database: ' PASSWORD

# Create db in mariadb for gitea
mysql -u root -Bse "CREATE DATABASE gitea;"
mysql -u root -Bse "CREATE USER 'gitea'@'localhost' IDENTIFIED BY '$PASSWORD';"
mysql -u root -Bse "GRANT ALL ON gitea.* TO 'gitea'@'localhost' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;"
mysql -u root -Bse "ALTER DATABASE gitea CHARACTER SET = utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -Bse "FLUSH PRIVILEGES;"

echo "Monkey installing gitea......................."

VER=$(curl --silent "https://api.github.com/repos/go-gitea/gitea/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's|[v,]||g' )
# Download gitea
if [ -n "$(uname -a | grep i386)" ]; then
    curl -fsSL -o "/usr/local/bin/gitea" "https://dl.gitea.io/gitea/$VER/gitea-$VER-linux-386"
fi

if [ -n "$(uname -a | grep x86_64)" ]; then
  curl -fsSL -o "/usr/local/bin/gitea" "https://dl.gitea.io/gitea/$VER/gitea-$VER-linux-amd64"
fi

if [ -n "$(uname -a | grep armv6l)" ]; then
  curl -fsSL -o "/usr/local/bin/gitea" "https://dl.gitea.io/gitea/$VER/gitea-$VER-linux-arm-6"
fi

if [ -n "$(uname -a | grep armv7l)" ]; then
  curl -fsSL -o "/usr/local/bin/gitea" "https://dl.gitea.io/gitea/$VER/gitea-$VER-linux-arm-7"
fi

#Grant execution permission
chmod +x /usr/local/bin/gitea


#Create necessary folders

mkdir -pv /var/lib/gitea/{custom,data,log,indexers,public}
chown -Rv git:git /var/lib/gitea
chmod -Rv 750 /var/lib/gitea
mkdir -v /etc/gitea
chown -Rv root:git /etc/gitea
chmod -Rv 770 /etc/gitea

#Copy systemd file
cp gitea.service /etc/systemd/system/gitea.service

# Start & Enable gitea daemon
systemctl enable gitea
systemctl start gitea

echo "Gitea $VER installed successfully....................................................."
echo "--------------------------------------------------------------------------------------"
echo " Access Gitea via http://localhost:3000"
echo "--------------------------------------------------------------------------------------"
echo " >>> You must finish the initial setup on Gitea --> http://localhost:3000 <<< "
echo "--------------------------------------------------------------------------------------"
echo " >>> Then get your Gitea access token and Github access token for mirror your all Github repository to Gitea <<< "
echo "--------------------------------------------------------------------------------------"
echo " >>> Then run gitea-monkey-mirror.sh script to mirror your all Github repository to your local Gitea <<< "
echo "--------------------------------------------------------------------------------------"

#--------------------------------------------------------------------------------------------
else
echo "Monkey can't smell debian or debian variant distro. Monkey is hoping to grow up for handle other distros too."
fi