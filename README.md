# Clamav

Clamav Script Scan and Send Email for infected files

```
wget -Nnv https://github.com/liberodark/clamav/raw/master/scan.sh && chmod +x scan.sh
```


# How to Work : 

### For Anti Virus need to install :

Manjaro / Arch Linux
```
sudo pacman -S clamav
systemctl enable clamav-daemon
```

Ubuntu / Debian
`sudo apt install clamav-daemon`

Fedora / Centos 8
`sudo dnf install clamav`

### For Email need to install :

Manjaro / Arch Linux
`sudo pacman -S msmtp`

Ubuntu / Debian
`sudo apt install msmtp`

Fedora / Centos 8
`sudo dnf install msmtp`

### Create config file :

`nano ~/.msmtprc`

### Config file exemple :

```
account lilo
host mail.lilo.org
port 587
from my_email
tls on
tls_certcheck off
tls_starttls on
auth on
user my_email
password my_password
```

### Secure config file :

`chmod 600 ~/.msmtprc`


### Install clamav-unofficial-sigs :

```
wget https://github.com/liberodark/clamav/releases/download/1.0.0/clamav-unofficial-sigs-7.0.1-1-any.pkg.tar.xz
pacman -U clamav-unofficial-sigs-7.0.1-1-any.pkg.tar.xz 
systemctl enable clamav-unofficial-sigs.service
systemctl start clamav-unofficial-sigs.service
```

### Edit Options clamav-unofficial-sigs :

`nano /etc/clamav-unofficial-sigs/user.conf`

### Install transmission :

`sudo pacman -S transmission-cli`

### Edit Options Transmission :

`nano /var/lib/transmission/.config/transmission-daemon/settings.json`

```
systemctl enable transmission
systemctl start transmission
chown -R transmission: /home/torrents
chmod -R 775 /home/torrents/
```

### Install ufw :

`pacman -S ufw`

`ufw allow 22/tcp && ufw allow 9091/tcp`
