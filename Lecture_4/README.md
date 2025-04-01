# №4. Vagrant
1. Через команду vagrant init створюємо файл Vagrantfile
2. Ініціюємо базову конфігурацію на рівні Vagrant.configure("2") do |config|
    - config.vm.box = "ubuntu/bionic64"
    - config.vm.provider "virtualbox" do |vb|
      - vb.gui = false # Display the VirtualBox GUI when booting the machine 
      - vb.memory = "1024" # Customize the amount of memory on the VM
      - vb.cpus = "2" # Customize the amount of cpu on the VM
    - config.vm.provision "nginx", type: "shell", inline: <<-SHELL
      - sudo apt-get update -y
      - sudo apt-get install -y nginx
      - sudo systemctl enable nginx
      - sudo systemctl start nginx
3. Визначаємо специфічні налаштування для 1 віртуальної машини
```vagrant
    config.vm.define "vm1" do |vm1|
      vm1.vm.hostname = "public-server"

      vm1.vm.network "public_network", bridge: "en0: Wi-Fi"

      vm1.vm.synced_folder "./shared_vm1", "/home/vagrant"

      vm1.vm.provision "shell", inline: <<-SHELL
        echo "=== VM1 provisioning ==="
        echo "=== HELLO FROM VM1 CONSOLE ==="
        pwd
        echo "HELLO FROM VM1 provisioning" > /home/vagrant/hello.txt
      SHELL
    end
```
4. Через vagrant up стартуємо віртуальну машину
![Screenshot 2025-04-01 at 13.02.52.png](assets/Screenshot%202025-04-01%20at%2013.02.52.png)
Після завершення команди в папці shared_vm1 можемо побачити файл hello.txt
![Screenshot 2025-04-01 at 13.04.39.png](assets/Screenshot%202025-04-01%20at%2013.04.39.png)
5. Спробуємо підʼєднатися до віртуальної машини через ssh та зберегти інший рядок у файл hello.txt
```vagrant
    vagrant ssh vm1 -- -v # password: vagrant
    echo "Hello from vagrant VM1" >> /home/vagrant/hello.txt
```
![Screenshot 2025-04-01 at 12.24.20.png](assets/Screenshot%202025-04-01%20at%2012.24.20.png)
![Screenshot 2025-04-01 at 12.24.34.png](assets/Screenshot%202025-04-01%20at%2012.24.34.png)
![Screenshot 2025-04-01 at 12.24.55.png](assets/Screenshot%202025-04-01%20at%2012.24.55.png)

6. По public_network bridge: "en0: Wi-Fi" наразі є обмеження на wireless devices https://support.apple.com/en-ke/guide/mac-help/mh43557/mac, тому прокинемо порт ethernet. По примусовому сетапі bridge на WiFi інтерфейс не налаштовується
![Screenshot 2025-04-01 at 13.42.21.png](assets/Screenshot%202025-04-01%20at%2013.42.21.png)
```vagrant
    vm1.vm.network "public_network", bridge: "en13: Belkin USB-C LAN"
```
і тепер можемо достукатися до nginx з локальної мережі
![Screenshot 2025-04-01 at 14.10.10.png](assets/Screenshot%202025-04-01%20at%2014.10.10.png)

7. Створимо provision.sh
![Screenshot 2025-04-01 at 14.21.04.png](assets/Screenshot%202025-04-01%20at%2014.21.04.png)
8. Додамо налаштування VM2
```vagrant
   config.vm.define "vm2" do |vm2|
        vm2.vm.hostname = "private-server"

        vm2.vm.network "private_network", ip: "10.1.0.2"

        vm2.vm.synced_folder "./shared_vm2", "/home/vagrant/app"

        vm2.vm.provision "shell", path: "provision.sh"
   end
```

9. Запустимо vagrant up
![Screenshot 2025-04-01 at 14.36.52.png](assets/Screenshot%202025-04-01%20at%2014.36.52.png)
![Screenshot 2025-04-01 at 14.37.33.png](assets/Screenshot%202025-04-01%20at%2014.37.33.png)
![Screenshot 2025-04-01 at 14.34.17.png](assets/Screenshot%202025-04-01%20at%2014.34.17.png)
10. Додамо налаштування VM3
```vagrant
    config.vm.define "vm3" do |vm3|
        vm3.vm.hostname = "public-static"

        vm3.vm.network "public_network",
          ip: "X.X.X.151", # де X.X.X - прихована частина IP адреси
          bridge: "en13: Belkin USB-C LAN"

        vm3.vm.synced_folder "./shared_vm3", "/home/vagrant/app"

        vm3.vm.provision "shell", inline: <<-SHELL
            echo "=== VM3 provisioning ==="
            echo "=== HELLO FROM VM3 CONSOLE ==="
            pwd
            echo "HELLO FROM VM3 provisioning" > /home/vagrant/app/hello.txt
        SHELL
    end
```

11. Запустимо vagrant up
![Screenshot 2025-04-01 at 14.43.48.png](assets/Screenshot%202025-04-01%20at%2014.43.48.png)
![Screenshot 2025-04-01 at 14.45.44.png](assets/Screenshot%202025-04-01%20at%2014.45.44.png)
12. Повний vagrant файл

```vagrant
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    config.vm.box = "bento/ubuntu-24.04"

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # config.vm.box_check_update = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # config.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    # config.vm.network "private_network", ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # config.vm.synced_folder "../data", "/vagrant_data"

    # Disable the default share of the current code directory. Doing this
    # provides improved isolation between the vagrant box and your host
    # by making sure your Vagrantfile isn't accessible to the vagrant box.
    # If you use this you may want to enable additional shared subfolders as
    # shown above.
    # config.vm.synced_folder ".", "/vagrant", disabled: true

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    config.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = false

        # Customize the amount of memory on the VM:
        vb.memory = "1024"
        vb.cpus = "2"
    end
    #
    # View the documentation for the provider you are using for more
    # information on available options.

    # Enable provisioning with a shell script. Additional provisioners such as
    # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
    # documentation for more information about their specific syntax and use.
    # config.vm.provision "shell", inline: <<-SHELL
    #   apt-get update
    #   apt-get install -y apache2
    # SHELL

    config.vm.provision "nginx", type: "shell", inline: <<-SHELL
        sudo apt-get update -y
        sudo apt-get install -y nginx

        sudo systemctl enable nginx
        sudo systemctl start nginx
    SHELL

    # -------------------------------------------------
    # VM1: Публічний сервер сервер із динамічним IP
    # -------------------------------------------------
    config.vm.define "vm1" do |vm1|
        vm1.vm.hostname = "public-server"

        #       vm1.vm.network "public_network", bridge: "en0: Wi-Fi"
        vm1.vm.network "public_network", bridge: "en13: Belkin USB-C LAN"

        vm1.vm.synced_folder "./shared_vm1", "/home/vagrant/app"

        vm1.vm.provision "shell", inline: <<-SHELL
        echo "=== VM1 provisioning ==="
        echo "=== HELLO FROM VM1 CONSOLE ==="
        pwd
        echo "HELLO FROM VM1 provisioning" > /home/vagrant/app/hello.txt
        SHELL
    end

    # -------------------------------------------------
    # VM2: Приватний сервер зі статичним IP
    # -------------------------------------------------
    config.vm.define "vm2" do |vm2|
        vm2.vm.hostname = "private-server"

        vm2.vm.network "private_network", ip: "10.1.0.2"

        vm2.vm.synced_folder "./shared_vm2", "/home/vagrant/app"

        vm2.vm.provision "shell", path: "provision.sh"
    end

    # -------------------------------------------------
    # VM3: Публічний сервер зі статичним IP (міст на en13)
    # -------------------------------------------------
    config.vm.define "vm3" do |vm3|
        vm3.vm.hostname = "public-static"

        vm3.vm.network "public_network",
          ip: "X.X.X.151",
          bridge: "en13: Belkin USB-C LAN"

        vm3.vm.synced_folder "./shared_vm3", "/home/vagrant/app"

        vm3.vm.provision "shell", inline: <<-SHELL
            echo "=== VM3 provisioning ==="
            echo "=== HELLO FROM VM3 CONSOLE ==="
            pwd
            echo "HELLO FROM VM3 provisioning" > /home/vagrant/app/hello.txt
        SHELL
    end
end

```

13. Щоб реалізувати декілька машин по одному конфігу зробимо наступне
provision.sh
```bash
echo "=== provisioning ==="
echo "=== HELLO FROM CONSOLE ==="
pwd
echo "HELLO FROM provisioning" >> /home/vagrant/app/hello.txt
```
Vagrantfile
```vagrant
Vagrant.configure("2") do |config|

    config.vm.box = "bento/ubuntu-24.04"
    config.vm.network "public_network", bridge: "en13: Belkin USB-C LAN"
    config.vm.synced_folder "./shared_multiple", "/home/vagrant/app"
    config.vm.provision "shell", path: "provision.sh"

    config.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = false

        # Customize the amount of memory on the VM:
        vb.memory = "1024"
        vb.cpus = "2"
    end

    config.vm.provision "nginx", type: "shell", inline: <<-SHELL
        sudo apt-get update -y
        sudo apt-get install -y nginx

        sudo systemctl enable nginx
        sudo systemctl start nginx
    SHELL

    config.vm.define "vm1" do |vm1|
        vm1.vm.hostname = "public-server"
    end

    config.vm.define "vm2" do |vm2|
        vm2.vm.hostname = "private-server"
    end

    config.vm.define "vm3" do |vm3|
        vm3.vm.hostname = "public-static"
    end
end

```

![Screenshot 2025-04-01 at 15.00.07.png](assets/Screenshot%202025-04-01%20at%2015.00.07.png)
![Screenshot 2025-04-01 at 15.00.39.png](assets/Screenshot%202025-04-01%20at%2015.00.39.png)
![Screenshot 2025-04-01 at 15.01.29.png](assets/Screenshot%202025-04-01%20at%2015.01.29.png)

Альтернатива - використання функцій
```vagrant
Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-24.04"
    config.vm.network "public_network", bridge: "en13: Belkin USB-C LAN"

    def configure_shared_vm(vm, name)
        vm.vm.box = "bento/ubuntu-24.04"
        vm.vm.hostname = name

        vm.vm.synced_folder "./shared_#{name}", "/home/vagrant/app"

        vm.vm.provision "shell", inline: <<-SHELL
          echo "=== #{name} provisioning ==="
          echo "=== HELLO FROM #{name} CONSOLE ==="
          pwd
          echo "HELLO FROM #{name} provisioning" >> /home/vagrant/app/hello.txt
        SHELL
    end

    config.vm.provider "virtualbox" do |vb|
        vb.gui = false

        vb.memory = "1024"
        vb.cpus = "2"
    end

    config.vm.provision "nginx", type: "shell", inline: <<-SHELL
        sudo apt-get update -y
        sudo apt-get install -y nginx

        sudo systemctl enable nginx
        sudo systemctl start nginx
    SHELL

    config.vm.define "vm1" do |vm1|
        configure_shared_vm(vm1, "vm1")
    end

    config.vm.define "vm2" do |vm2|
        configure_shared_vm(vm2, "vm2")
    end

    config.vm.define "vm3" do |vm3|
        configure_shared_vm(vm3, "vm3")
    end
end

```