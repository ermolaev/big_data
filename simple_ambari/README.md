    yum install qemu-kvm qemu-img virt-install libvirt libvirt-client
    sudo service qemu-kvm restart

    # https://www.vagrantup.com/downloads.html
    vagrant plugin install vagrant-omnibus
    vagrant plugin install vagrant-libvirt
    vagrant box add http://linuxsimba.com/vagrantbox/centos7.box --name "centos7"

    bundle
    librarian-chef install

    vagrant up
    vagrant rsync-auto
    vagrant provision

### OpenVPN
http://blog.amet13.name/2015/11/openvpn-centos-7.html
yum install openvpn easy-rsa
sudo yum install firewalld
