    sudo apt-get install qemu-kvm libvirt-bin libvirt-dev

    # https://www.vagrantup.com/downloads.html
    vagrant plugin install vagrant-omnibus
    vagrant plugin install vagrant-libvirt
    vagrant box add http://linuxsimba.com/vagrantbox/centos7.box --name "centos7"

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



### Blueprint
    curl -X GET -u admin:3odl5g9oi7sdfghj 'http://176.112.202.219:8080/api/v1/clusters/eCluster?format=blueprint' > blueprint.json
для загрузки кластера или blueprint нужно вызвать "recipe[ambari::blueprints]"
