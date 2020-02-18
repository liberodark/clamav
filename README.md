# Clamav

Clamav Script Scan and Send Email for infected files

```
wget -Nnv https://github.com/liberodark/clamav/raw/master/scan.sh && chmod +x scan.sh
```


# How to Work : 

### For Anti Virus need to install :

Manjaro / Arch Linux
`sudo pacman -S clamav`

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
