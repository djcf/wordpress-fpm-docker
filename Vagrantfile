Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"

  config.vm.provision :docker
  config.vm.provision :docker_compose,
    yml: [
      "/vagrant/docker-compose.yml"
    ],
    run: "always"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "playbook.yml"
  end
end
