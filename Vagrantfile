
Vagrant.configure("2") do |config|
  
  config.vm.box = "Cimat/SelectorMetodologias"
  
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.network "forwarded_port", guest: 8000, host: 8000


  config.vm.synced_folder "api", "/home/vagrant/go/src/github.com/kdchaires/selectormetodologias/api"


end

