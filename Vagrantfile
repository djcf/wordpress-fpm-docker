Vagrant.configure("2") do |config|
  # jessie's 3.16 kernel has an outstanding bug with systemd-socket-proxyd
  #config.vm.box = "debian/jessie64"

  # xenial has outstanding bugs work with libvirt
  #config.vm.box = "peru/ubuntu-16.04-server-amd64"
  #config.vm.box = "ubuntu/ubuntu-16.04-server"

  # This Xenial box seems to work however
  config.vm.box = "nrclark/xenial64-minimal-libvirt"

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"

  # config.vm.provision "ansible" do |ansible|
  #   ansible.verbose = "v"
  #   ansible.playbook = "ansible/plays/system/install-web.yml"
  # end

  # config.vm.provision :docker
  # config.vm.provision :docker_compose,
  #   yml: [
  #     "/vagrant/docker/docker-compose.yml"
  #   ],
  #   run: "always"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/plays/system/configure-web.yml"
  end

end