Vagrant.configure("2") do |config|
  # jessie's 3.16 kernel has an outstanding bug with systemd-socket-proxyd
  #config.vm.box = "debian/jessie64"

  # xenial has outstanding bugs work with libvirt
  #config.vm.box = "peru/ubuntu-16.04-server-amd64"
  #config.vm.box = "ubuntu/ubuntu-16.04-server"

  config.vm.box = "nrclark/xenial64-minimal-libvirt"

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/configure-host/playbook.yml"
  end

  config.vm.provision :docker
  config.vm.provision :docker_compose,
    yml: [
      "/vagrant/docker/docker-compose.yml"
    ],
    run: "always"

$COPY_SVC_UNITS = <<SH
  cp /vagrant/systemd.services/mysql.service /etc/systemd/system/multi-user.target.wants
  cp /vagrant/systemd.services/switchboard.service /etc/systemd/system/multi-user.target.wants
  cp /vagrant/systemd.services/vhost.fpm.service /etc/systemd/system
  cp /vagrant/systemd.services/vhost.fpm-waker.service /etc/systemd/system
  cp /vagrant/systemd.services/vhost.fpm-waker.socket /etc/systemd/system

  docker create \
	--name vhost \
	-v docker_web:/usr/share/nginx \
	-v /var/run/docker-apps:/var/run/docker-apps \
	fpm
SH

  config.vm.provision "shell", inline: $COPY_SVC_UNITS
end