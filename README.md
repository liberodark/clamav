# clamav

```
wget -Nnv https://github.com/liberodark/clamav/raw/master/scan.sh && chmod +x scan.sh
```


# How to Work : 

For Email need to install :

`sudo pacman -S msmtp`

Create config file :

`nano ~/.msmtprc`

Config file exemple :

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

Secure config file :

`chmod 600 ~/.msmtprc`
