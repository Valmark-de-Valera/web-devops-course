# Lecture 5
Хотів би спробувати встановити Alpine image та помітив, що Vagrant не підтримує 
ARM64 image. Вирішив спробувати змінити VirtualBox на QEMU.
https://portal.cloud.hashicorp.com/vagrant/discover/generic/alpine318
1. Install QEMU - ```brew install qemu```
1.2. Install QEMU - ```brew install qemu-efi```
2. Setup Vagrant QEMU Plugin - ```vagrant plugin install vagrant-qemu```
> Installed the plugin 'vagrant-qemu (0.3.9)'!
3. ```qemu-system-arm --version```
> QEMU emulator version 9.2.3 \
Copyright (c) 2003-2024 Fabrice Bellard and the QEMU Project developer
4. Vagrantfile
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "generic/alpine318"

  config.vm.provider :qemu do |qemu|
      qemu.qemu_bin = "/usr/local/bin/qemu-system-arm"

      qemu.memory = 512

      qemu.cpus = 1
    end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
```
5. ```vagrant up --provider=qemu```
> Bringing machine 'default' up with 'qemu' provider... \
==> default: Box 'generic/alpine318' could not be found. Attempting to find and install... \
default: Box Provider: libvirt \
default: Box Version: >= 0 \
==> default: Loading metadata for box 'generic/alpine318' \
default: URL: https://vagrantcloud.com/api/v2/vagrant/generic/alpine318 \
==> default: Adding box 'generic/alpine318' (v4.3.12) for provider: libvirt (arm64) \
default: Downloading: https://vagrantcloud.com/generic/boxes/alpine318/versions/4.3.12/providers/libvirt/arm64/vagrant.box \
default: Calculating and comparing box checksum... \
==> default: Successfully added box 'generic/alpine318' (v4.3.12) for 'libvirt (arm64)'! \
==> default: Checking if box 'generic/alpine318' version '4.3.12' is up to date... \
==> default: Importing a QEMU instance \
default: Creating and registering the VM... \
default: Successfully imported VM \
==> default: Warning! The QEMU provider doesn't support any of the Vagrant \
==> default: high-level network configurations (`config.vm.network`). They \
==> default: will be silently ignored. \
==> default: Starting the instance... \
==> default: Waiting for machine to boot. This may take a few minutes... \
default: SSH address: 127.0.0.1:50022 \
default: SSH username: vagrant \
default: SSH auth method: private key \
default: \
default: Vagrant insecure key detected. Vagrant will automatically replace \
default: this with a newly generated keypair for better security. \
default: \
default: Inserting generated public key within guest... \
default: Removing insecure key from the guest if it's present... \
default: Key inserted! Disconnecting and reconnecting using new SSH key... \
==> default: Machine booted and ready!
6. ```vagrant ssh```
> alpine318:~$
7. VM terminal: ```cat /etc/os-release```
> NAME="Alpine Linux" \
ID=alpine \
VERSION_ID=3.18.5 \
PRETTY_NAME="Alpine Linux v3.18" \
HOME_URL="https://alpinelinux.org/" \
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues" \
![Screenshot 2025-04-14 at 17.33.15.png](assets/Screenshot%202025-04-14%20at%2017.33.15.png)
8. Або вручну інсталюємо https://alpinelinux.org/downloads/ (aarch64). Це буде весело без GUI)

![Screenshot 2025-04-14 at 17.37.26.png](assets/Screenshot%202025-04-14%20at%2017.37.26.png)
### Setup virtual disk with qcow2 format 
```qemu-img create -f qcow2 alpine-aarch64.qcow2 4G```
![Screenshot 2025-04-14 at 17.41.49.png](assets/Screenshot%202025-04-14%20at%2017.41.49.png)
### Install Alpine Linux
```zsh
qemu-system-aarch64 \
  -machine virt \
  -cpu host \
  -accel hvf \
  -m 1024 \
  -bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd \
  -drive if=none,file=alpine-aarch64.qcow2,id=hd0 \
  -device virtio-blk-device,drive=hd0 \
  -cdrom ./alpine-3.21.3-aarch64.iso \
  -boot d \
  -nic user,model=virtio-net-pci \
  -nographic
```
> qemu-system-aarch64: емулятор/гіпервізор для ARM64. \
-machine virt: “віртуальна плата” для aarch64. \
-cpu host -accel hvf: використовує локальний CPU та Hypervisor Framework (macOS). \
-m 1024: 1 ГБ RAM для гостя. \
-bios edk2-aarch64-code.fd: UEFI прошивка для ARM64. \
-drive & -device virtio-blk-device: підключення qcow2-диска у режимі virtio (швидше). \
-boot c: завантажувати з диска. \
-nic user,model=virtio-net-pci: мережа з NAT + virtio-адаптер. \
-nographic: немає графічного вікна, все йде в термінал (серійна консоль).

virtio-blk-device — паравіртуалізований блоковий диск (швидший і ефективніший, ніж емуляція IDE чи SCSI).
virtio-net-pci: пристрій мережі паравіртуалізований (virtio) – швидший за емуляцію звичайних карт (e1000/rtl8139).
edk2-aarch64-code.fd — це змонтований (або компільований) EDK2 (UEFI) для ARM64

![Screenshot 2025-04-14 at 17.56.57.png](assets/Screenshot%202025-04-14%20at%2017.56.57.png)
![Screenshot 2025-04-14 at 17.57.28.png](assets/Screenshot%202025-04-14%20at%2017.57.28.png)
Розібравшись з логами бачу, що деякі ресурси не підключені успішно, як генерація RND та TPM модулю, але думаю, що жити можна без них зараз

Взагалом Alpine Linux 3.21.3 для aarch64 успішно завантажилася в QEMU через UEFI (edk2)

### ```root```
![Screenshot 2025-04-14 at 18.02.00.png](assets/Screenshot%202025-04-14%20at%2018.02.00.png)

### Підготовимо ssl ключі - ```ssh-keygen -t ed25519 -C "root@alpine"```
![Screenshot 2025-04-14 at 18.17.46.png](assets/Screenshot%202025-04-14%20at%2018.17.46.png)

### ```setup-alpine``` + ssh public key
![Screenshot 2025-04-14 at 18.23.46.png](assets/Screenshot%202025-04-14%20at%2018.23.46.png)
![Screenshot 2025-04-14 at 18.24.22.png](assets/Screenshot%202025-04-14%20at%2018.24.22.png)
![Screenshot 2025-04-14 at 18.24.48.png](assets/Screenshot%202025-04-14%20at%2018.24.48.png)

### Запустимо встановлену систему (прибравши cdrom iso та змінивши boot device)
```zsh
qemu-system-aarch64 \
-machine virt \
-cpu host \
-accel hvf \
-m 1024 \
-bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd \
-drive if=none,file=alpine-aarch64.qcow2,id=hd0 \
-device virtio-blk-device,drive=hd0 \
-boot c \
-nic user,model=virtio-net-pci \
-nographic
```
![Screenshot 2025-04-14 at 18.29.50.png](assets/Screenshot%202025-04-14%20at%2018.29.50.png)
![Screenshot 2025-04-14 at 18.31.11.png](assets/Screenshot%202025-04-14%20at%2018.31.11.png)
### ```alpine:~# cat /etc/os-release```
> NAME="Alpine Linux" \
ID=alpine \
VERSION_ID=3.21.3 \
PRETTY_NAME="Alpine Linux v3.21" \
HOME_URL="https://alpinelinux.org/" \
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues" \
9. Кайфи, от тільки безпосередньо підключити PPA у Alpine Linux неможливо 😋,
   бо це Ubuntu-specific сховище .deb-пакетів, які не сумісні з Alpine
10. Упупу, ну що ж, ubuntu вже встановлювали, тож запустимо через vagrant
11. Vagrantfile
12. Підготуємо віртуальну машину```vagrant up --no-provision```
![Screenshot 2025-04-14 at 19.03.37.png](assets/Screenshot%202025-04-14%20at%2019.03.37.png)
13. Встановити й налаштувати вебсервер Nginx через офіційний репозиторій.
![Screenshot 2025-04-14 at 19.08.41.png](assets/Screenshot%202025-04-14%20at%2019.08.41.png)
![Screenshot 2025-04-14 at 19.15.37.png](assets/Screenshot%202025-04-14%20at%2019.15.37.png)
![Screenshot 2025-04-14 at 19.14.48.png](assets/Screenshot%202025-04-14%20at%2019.14.48.png)
14. Додати PPA-репозиторій для Nginx та встановити Nginx з нього.
Згідно документації https://launchpad.net/~nginx/+archive/ubuntu/stable остання підтримувана версія ubuntu 20.04, тому на новіших версіях отримуємо помилку
```
default: E: The repository 'https://ppa.launchpadcontent.net/nginx/stable/ubuntu jammy Release' does not have a Release file.
```
Запускаємо на 20.04 (запущено на qemu та на імейджі "perk/ubuntu-20.04-arm64" через несумість з arm чи virtualbox)
```
 default: Get:1 http://ports.ubuntu.com/ubuntu-ports focal/universe arm64 geoip-database all 20191224-2 [3029 kB]
 default: Get:2 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 nginx-core arm64 1.18.0-3ubuntu1+focal2 [431 kB]
 default: Get:3 http://ports.ubuntu.com/ubuntu-ports focal/universe arm64 libgeoip1 arm64 1.6.12-6build1 [69.4 kB]
 default: Get:4 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 nginx all 1.18.0-3ubuntu1+focal2 [35.6 kB]
 default: Get:5 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 libnginx-mod-stream arm64 1.18.0-3ubuntu1+focal2 [94.0 kB]
 default: Get:6 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 libnginx-mod-mail arm64 1.18.0-3ubuntu1+focal2 [70.2 kB]
 default: Get:7 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 libnginx-mod-http-image-filter arm64 1.18.0-3ubuntu1+focal2 [44.1 kB]
 default: Get:8 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 libnginx-mod-http-xslt-filter arm64 1.18.0-3ubuntu1+focal2 [42.9 kB]
 default: Get:9 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 nginx-common all 1.18.0-3ubuntu1+focal2 [68.6 kB]
 default: Get:10 http://ppa.launchpad.net/nginx/stable/ubuntu focal/main arm64 libnginx-mod-stream-geoip arm64 1.18.0-3ubuntu1+focal2 [40.2 kB]
```
![Screenshot 2025-04-14 at 20.17.41.png](assets/Screenshot%202025-04-14%20at%2020.17.41.png)
![Screenshot 2025-04-14 at 20.18.02.png](assets/Screenshot%202025-04-14%20at%2020.18.02.png)
15. Повернутися до офіційної версії пакета за допомогою ppa-purge. Видалити PPA-репозиторій для Nginx
![Screenshot 2025-04-14 at 20.24.37.png](assets/Screenshot%202025-04-14%20at%2020.24.37.png)
![Screenshot 2025-04-14 at 20.24.47.png](assets/Screenshot%202025-04-14%20at%2020.24.47.png)
17. Написати й налаштувати власний systemd-сервіс для запуску простого скрипта (наприклад, скрипт, який пише поточну дату і час у файл щохвилини).
### /usr/local/bin/date_loop.sh
```bash
#!/usr/bin/env bash
while true; do
  echo "[$(date)] Service is running..." >> /var/log/date_loop.log
  sleep 60
done 
```
### /etc/systemd/system/date-loop.service
```bash
[Unit]
Description=Infinite loop logging date to /var/log/date_loop.log
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/date_loop.sh
Restart=always

[Install]
WantedBy=multi-user.target
```
![Screenshot 2025-04-14 at 20.27.52.png](assets/Screenshot%202025-04-14%20at%2020.27.52.png)
Перевіряємо статус сервісу
![Screenshot 2025-04-14 at 20.31.31.png](assets/Screenshot%202025-04-14%20at%2020.31.31.png)
Перевіряємо /var/log/date_loop.log (упупу, схоже date захардкодився в скрипті, але наче як не мало такого статися, буду рісьорчити потім)
![Screenshot 2025-04-14 at 20.32.26.png](assets/Screenshot%202025-04-14%20at%2020.32.26.png)
18. Через vim підфіксимо код
![Screenshot 2025-04-14 at 20.47.13.png](assets/Screenshot%202025-04-14%20at%2020.47.13.png)
```bash
sudo systemctl daemon-reload
sudo systemctl start date-loop.service
```
![Screenshot 2025-04-14 at 20.57.45.png](assets/Screenshot%202025-04-14%20at%2020.57.45.png)
![Screenshot 2025-04-14 at 20.56.20.png](assets/Screenshot%202025-04-14%20at%2020.56.20.png)
19. Налаштувати брандмауер за допомогою UFW або iptables. Заборонити доступ до порту 22 (SSH) з певного IP, але дозволити з іншого IP. Налаштувати Fail2Ban для захисту від підбору паролів через SSH.
![Screenshot 2025-04-14 at 21.08.30.png](assets/Screenshot%202025-04-14%20at%2021.08.30.png)
![Screenshot 2025-04-14 at 21.11.13.png](assets/Screenshot%202025-04-14%20at%2021.11.13.png)
![Screenshot 2025-04-14 at 21.13.12.png](assets/Screenshot%202025-04-14%20at%2021.13.12.png)
![Screenshot 2025-04-14 at 21.20.20.png](assets/Screenshot%202025-04-14%20at%2021.20.20.png)
![Screenshot 2025-04-14 at 21.22.04.png](assets/Screenshot%202025-04-14%20at%2021.22.04.png)

На скриншоті два запити перший червоний, так як підключення було невдале, друге після дозволу sudo ufw allow ssh:
![Screenshot 2025-04-14 at 21.23.07.png](assets/Screenshot%202025-04-14%20at%2021.23.07.png)
20. ss
### Створюємо віртуальний диск
```ruby
# Якщо файл додаткового диску ще не існує, створюємо його.
extra_disk = "extra-disk.qcow2"
unless File.exist?(extra_disk)
  puts "Створення додаткового диску #{extra_disk} розміром 5ГБ..."
  system("qemu-img create -f qcow2 #{extra_disk} 5G")
end
```
### Підключаємо віртуальний диск
```ruby
qemu.extra_qemu_args = [
   "-drive", "if=none,file=#{extra_disk},format=qcow2,id=hd2",
   "-device", "virtio-blk,drive=hd2"
]
```
### Наш диск vda (цікаво, чому не vdb)
![Screenshot 2025-04-14 at 22.04.49.png](assets/Screenshot%202025-04-14%20at%2022.04.49.png)
### Запускаємо скрипт
![Screenshot 2025-04-14 at 22.05.50.png](assets/Screenshot%202025-04-14%20at%2022.05.50.png)
### Перевіряємо (done)
![Screenshot 2025-04-14 at 22.07.03.png](assets/Screenshot%202025-04-14%20at%2022.07.03.png)
