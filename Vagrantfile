Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"

  config.vm.provision :docker
  config.vm.provision :docker_compose,
    yml: [
      "/vagrant/docker/docker-compose.yml"
    ],
    run: "always"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/configure-host/playbook.yml"
  end

$COPY_SVC_UNITS = <<SH
  cp /vagrant/systemd.services/mysql.service /etc/systemd/system/multi-user.target.wants
  cp /vagrant/systemd.services/switchboard.service /etc/systemd/system/multi-user.target.wants
  cp /vagrant/systemd.services/vhost.fpm.service /etc/systemd/system
  cp /vagrant/systemd.services/vhost.fpm-waker.service /etc/systemd/system
  cp /vagrant/systemd.services/vhost.fpm-waker.socket /etc/systemd/system
SH

  config.vm.provision "shell", inline: $COPY_SVC_UNITS
end