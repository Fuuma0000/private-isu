all: app

.PHONY: app
app: *.go go.mod go.sum
	go build -o app

.PHONY: mysql
mysql:
	mysql -u isuconp -p isuconp 

.PHONY: inalp
inalp:
	sudo mkdir /opt/scripts/
	sudo chown -R ubuntu: /opt/scripts
	sudo curl -L https://github.com/tkuchiki/alp/releases/download/v1.0.16/alp_linux_amd64.tar.gz -o /opt/scripts/alp_linux_amd64.tar.gz
	cd /opt/scripts
	sudo tar xf alp_linux_amd64.tar.gz
	sudo cp /etc/nginx/nginx.conf{,.bk}
	sudo vim /etc/nginx/nginx.conf

.PHONY: inpt
inpt:
	cd /usr/local/src
	sudo wget https://www.percona.com/downloads/percona-toolkit/3.0.10/binary/debian/xenial/x86_64/percona-toolkit_3.0.10-1.xenial_amd64.deb
	sudo apt install -y libdbd-mysql-perl libdbi-perl libio-socket-ssl-perl libnet-ssleay-perl libterm-readkey-perl
	sudo dpkg -i percona-toolkit_3.0.10-1.xenial_amd64.deb
	sudo cp /dev/null /var/log/mysql/mysql-slow.log

.PHONY: ec
ec:
	echo ${HOME}
	echo ${USER}

.PHONY: alp
alp:
	sudo cat /var/log/nginx/access.log | \
    /opt/scripts/alp ltsv \
      --sort sum \
      -m '/bulletins/view/*,/bulletins/edit/*,/bulletins/delete/*,/comment/edit/*,/comment/delete/*'

.PHONY: pt
pt:
	sudo pt-query-digest /var/log/mysql/mysql-slow.log --limit 5

.PHONY: pre
pre:
	sudo cp /dev/null /var/log/nginx/access.log
	sudo cp /dev/null /var/log/mysql/mysql-slow.log
	sudo cp /dev/null /var/log/mysql/error.log

.PHONY: restart-mysql
restart-mysql:
	sudo systemctl restart mysql

.PHONY: restart-nginx
restart-nginx:
	sudo systemctl restart nginx

.PHONY: restart-isu
restart-isu:
	sudo systemctl restart isu-go
