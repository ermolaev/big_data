    sudo apt-get install qemu-kvm libvirt-bin libvirt-dev

    # https://www.vagrantup.com/downloads.html
    vagrant plugin install vagrant-omnibus
    vagrant plugin install vagrant-libvirt
    vagrant box add http://linuxsimba.com/vagrantbox/ubuntu-trusty.box --name "trusty64"

    bundle
    librarian-chef install

### бубен для запуска машин на удаленном сервере (не завёлся, ошибка - `waiting for domain to get an ip address`)
    # https://libvirt.org/remote.html
    sudo apt-get install gnutls-bin
    certtool --generate-privkey > cakey.pem
    vim ca.info
    certtool --generate-self-signed --load-privkey cakey.pem --template ca.info --outfile cacert.pem
    cat cacert.pem
    # local
    sudo mkdir /etc/pki/CA
    sudo vim /etc/pki/CA/cacert.pem

    http://pineapplesoftware.blogspot.ru/2012/11/configuring-unsecure-remote-access-to.html
    http://askubuntu.com/questions/423425/i-cant-use-libvirt-with-listen-tcp


## Команды для поднятия хостов


### chef to vagrant
    # http://www.kianmeng.org/2015/11/fedora-23-cloud-image-through-vagrant.html
    vagrant up --provider=libvirt
    vagrant rsync
    vagrant provision

### chef to production
    knife solo prepare root@176.112.202.219 --bootstrap-version=12.6.0 -P {password} # по дефолту подхватывается старая версия Chef
    knife solo cook root@176.112.202.219 --no-chef-check --no-librarian -P {password}

    knife solo prepare root@176.112.202.220 --bootstrap-version=12.6.0 -P {password} # по дефолту подхватывается старая версия Chef
    knife solo cook root@176.112.202.220 --no-chef-check --no-librarian -P {password}

После первой накатки вход под рутом должен быть запрещён, накатывать следует из-под admin.

    knife solo cook admin@194.177.23.139 --no-chef-check --no-librarian -P {password}


### Ranger
    sudo apt-get install mysql-server
    /etc/mysql/my.cnf - bind-address = сетевой IP
    sudo service mysql restart
    + правки конфигов в основном изменить db_host

### Blueprint
    curl -X GET -u admin:3odl5g9oi7sdfghj 'http://176.112.202.219:8080/api/v1/clusters/eCluster?format=blueprint' > blueprint.json
для загрузки кластера или blueprint нужно вызвать "recipe[ambari::blueprints]"
