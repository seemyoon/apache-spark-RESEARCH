Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"
    config.vm.network "private_network", ip: "192.168.100.10"
    config.vm.network "forwarded_port", guest: 8088, host: 8088
    config.vm.network "forwarded_port", guest: 9870, host: 9870
    config.vm.synced_folder ".", "/vagrant"
    config.vm.hostname = "spark-cluster"
    config.disksize.size = '20GB'
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "10240"
        vb.cpus = 4
    end
    config.vm.provision "shell", path: "set-up.sh"
end