# goorm_7th_ansible_study3_semi-project
 [ HRD.net - 구름 ] 쿠버네티스 전문가 양성 과정 7기 - 7주차 Ansible semi-project
 
# 세팅 순서
1. vagrant 설치
2. 가상환경 (VirtualBox) 설치
3. 가상환경 배포 및 접속
4. Control(Master) Node 세팅
5. ansible-playbook 실행
6. DB Server 설정

# 1. vagrant 설치 - 생략

# 2. 가상환경 (VirtualBox) 설치 - 생략

# 3. 가상환경 배포 및 접속
## git repo download
```bash
$ git clone https://github.com/scarleaf/goorm_7th_ansible_study3_semi-project.git
```
## 가상환경 배포 및 접속
```bash
$ cd ./goorm_7th_ansible_study3_semi-project/iac
$ vagrant up
$ vagrant ssh iac-control1 # control node 접속
```

# 4. Control(Master) Node 세팅
## git repo download
```bash
vagrant@iac-control1:~$ git clone https://github.com/scarleaf/goorm_7th_ansible_study3_semi-project.git
```
## Install ansible
```bash
vagrant@iac-control1:~$ sudo apt install software-properties-common
vagrant@iac-control1:~$ sudo add-apt-repository --yes --update ppa:ansible/ansible
vagrant@iac-control1:~$ sudo apt install ansible
```
## Inventory 복사
```bash
vagrant@iac-control1:~$ cd ~
vagrant@iac-control1:~$ cp ./goorm_7th_ansible_study3_semi-project/iac-control1/* .
```

## SSH 인증 설정
```bash
vagrant@iac-control1:~$ sh ~/ssh_setting.sh
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): (엔터)
Enter passphrase (empty for no passphrase): (엔터)
Enter same passphrase again: (엔터)
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:H0Wy4va5uCgACqYbREmH2Co1EzhF63sPMCkYyjPXvQQ vagrant@iac-control1
The key's randomart image is:
+---[RSA 3072]----+
|o**o      . .    |
|++*.       +     |
|o+.o E  . . .    |
|O= .. o. . .     |
|@==. . oS .      |
|+.=+  ...o o     |
| o..o  .  +      |
|.  ..o . . .     |
|     .o o..      |
+----[SHA256]-----+
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@192.168.56.21's password: (비밀번호: vagrant)

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '192.168.56.21'"
and check to make sure that only the key(s) you wanted were added.

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@192.168.56.22's password: (비밀번호: vagrant)

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '192.168.56.22'"
and check to make sure that only the key(s) you wanted were added.

# 192.168.56.21:22 SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
# 192.168.56.22:22 SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.
```

## ping test
```bash
vagrant@iac-control1:~$ ansible all -m ping -i hosts.ini
```

# 5. ansible-playbook 실행
```bash
vagrant@iac-control1:~$ ansible-playbook -i hosts.ini install_web-db.yaml
```

# 6. DB Server 설정
```bash
vagrant@iac-control1:~$ ssh 192.168.56.22

# mariadb 리스닝을 localhost -> 0.0.0.0 변경
vagrant@iac-node2:~$ ss -antp | grep 3306
LISTEN       0             80                       127.0.0.1:3306                    0.0.0.0:*

vagrant@iac-node2:~$ sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
#bind-address            = 127.0.0.1
bind-address            = 0.0.0.0

# MariaDB wordpress database 생성, 사용자 생성 및 권한 부여
vagrant@iac-node2:~$ sudo mysql
```
```sql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 39
Server version: 10.3.37-MariaDB-0ubuntu0.20.04.1 Ubuntu 20.04

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create database wordpress;
Query OK, 1 row affected (0,00 sec)

MariaDB [(none)]> use mysql;
MariaDB [mysql]> select host, user, password from user;
+-----------+------+----------+
| host      | user | password |
+-----------+------+----------+
| localhost | root |          |
+-----------+------+----------+
1 row in set (0.000 sec)

MariaDB [mysql]> create user 'wordpress'@'%' identified by 'dkagh1.!';
Query OK, 1 row affected (0,00 sec)

MariaDB [mysql]> grant all privileges on wordpress.* to 'wordpress'@'%';
Query OK, 1 row affected (0,00 sec)

MariaDB [mysql]> flush privileges;
Query OK, 1 row affected (0,00 sec)

MariaDB [mysql]> select host,user,password from user;
Query OK, 1 row affected (0,00 sec)

MariaDB [mysql]> select host, user, password from user;
+---------------+-----------+-------------------------------------------+
| host          | user      | password                                  |
+---------------+-----------+-------------------------------------------+
| localhost     | root      |                                           |
| %             | wordpress | *91B1C231B710BE16DB0764D2753CA4450C300B7A |
+---------------+-----------+-------------------------------------------+
2 rows in set (0.001 sec)
```
