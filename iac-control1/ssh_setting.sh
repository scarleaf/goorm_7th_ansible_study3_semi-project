ssh-keygen
ssh-copy-id 192.168.56.21
ssh-copy-id 192.168.56.22

ssh-keyscan -t ssh-rsa 192.168.56.21 >> ~/.known_hosts
ssh-keyscan -t ssh-rsa 192.168.56.22 >> ~/.known_hosts
