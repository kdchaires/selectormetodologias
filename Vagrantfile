
Vagrant.configure("2") do |config|
  
  config.vm.box = "Cimat/SelectorMetodologias"
  
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.network "forwarded_port", guest: 8000, host: 8000


  config.vm.synced_folder "api", "/home/vagrant/go/src/cimat/metodologias/selector"

  config.vm.provision "shell", inline: <<-SHELL
    echo -n                                          >  /etc/profile.d/gopath.sh
    echo 'export GOROOT=/usr/local/go'                 >> /etc/profile.d/gopath.sh
    echo 'export GOPATH=/home/vagrant/go'             >> /etc/profile.d/gopath.sh
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /etc/profile.d/gopath.sh
  SHELL
  
<<<<<<< HEAD
end
=======
end
>>>>>>> cc3c5b6c8b79c7ba2ff82481ade5a18c3a1d239d
