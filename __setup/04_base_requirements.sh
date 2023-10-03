#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi
clear

export DEBIAN_FRONTEND=noninteractive

export HOME_DIR=/home/pi/
export CYBERBOT_SRC_DIR=$HOME_DIR/cyberbot_sources/

mkdir -p $CYBERBOT_SRC_DIR


main() {

  #change_current_hostname
  ###change_raspi_config_interfaces

  ###run_rpi_update
  install_project_requirements

  enable_hdmi_hotplug
  ###install_connection_manager
  install_kernel_headers
  modprobe_bcm2835_v4l2

  install_v4l2loopback
  set_v4l2loopback_dummy_device

  install_portainer
  install_openvpn

  printf "
  #######################################################
  DONE
  #######################################################

  Now you should reboot the robot!
  "
}


change_current_hostname() {
    printf "
#######################################################
GET_CURRENT_HOSTNAME
#######################################################
"
  printf "
  Введите новый hostname для этого робота.
  Для получения валидного hostname обратитесь к вашему
  администратору.
  В случае ввода некорректного hostname скрипт установки
  может завершится с ошибкой, а ПО на роботе не будет работать.

  "
  echo -n "Введите новый hostname: "
  read new_hostname
  if [ ${#new_hostname} -lt 3 ];
  then
    printf "

  Длина hostname должна быть больше 3 символов!
  " ; exit
  else
    printf ""
  fi

  current_hostname=`raspi-config nonint get_hostname`
  printf "
  Вы ввели hostname: $new_hostname
  Настоящий hostname: $current_hostname
  ------------------------------------
  [...] - Пробуем сменить
  ------------------------------------
  "
  raspi-config nonint nonint do_hostname $new_hostname
  current_hostname=`raspi-config nonint get_hostname`
  printf "
  Обновленный hostname: $current_hostname
  "
}


get_raspiconf_info() {
  # https://forums.raspberrypi.com/viewtopic.php?t=21632
  current_hostname=`raspi-config nonint get_hostname`
  current_ssh=`raspi-config nonint get_ssh`
  current_vnc=`raspi-config nonint get_vnc`
  current_serial=`raspi-config nonint get_serial`
  current_camera=`raspi-config nonint get_camera`
  current_spi=`raspi-config nonint get_spi`
  current_i2c=`raspi-config nonint get_i2c`
  current_onewire=`raspi-config nonint get_onewire`
  current_rgpio=`raspi-config nonint get_rgpio`
  current_wifi_country=`raspi-config nonint get_wifi_country`

    printf "
  ------------------------------------
  hostname:     ${current_hostname}
  ------------------------------------
  [ 0 - enable  | 1 - disable ]

  ssh:          ${current_ssh}
  vnc:          ${current_vnc}
  serial:       ${current_serial}
  camera:       ${current_camera}
  spi:          ${current_spi}
  i2c:          ${current_i2c}
  onewire:      ${current_onewire}
  rgpio:        ${current_rgpio}
  wifi_country: ${current_wifi_country}

"
}


change_raspi_config_interfaces() {
    printf "
#######################################################
CHANGE RASPI-CONFIG INTERFACES
#######################################################
"
  get_raspiconf_info

  # 0 - enable
  # 1 - disable
  raspi-config nonint do_ssh 0            # enable ssh
  raspi-config nonint do_vnc 0            # enable vnc
  raspi-config nonint do_serial 0         # enable serial
  raspi-config nonint do_camera 0         # enable camera
  raspi-config nonint do_spi 1            # disable spi
  raspi-config nonint do_i2c 1            # disable i2c
  raspi-config nonint do_onewire 1        # disable onewire
  raspi-config nonint do_rgpio 1          # disable rgpio
  raspi-config nonint do_wifi_country RU  # set wifi country RU

  get_raspiconf_info


}

enable_hdmi_hotplug() {
    printf "
#######################################################
ENABLE HDMI HOTPLUG
#######################################################
"

printf "
hdmi_force_hotplug=1   # to show virtual display without hdmi through vnc
hdmi_group=1           # 1  - Raspberry Pi is connected to a TV
hdmi_mode=16           # 16 - 1080p 60Hz aspect 16:9
#hdmi_drive=2          # 2  - Enable the HDMI sound output ()
" >> /boot/config.txt
}


run_rpi_update() {
  printf "
#######################################################
RUN RPU UPDATE
#######################################################
"
  sudo rpi-update b976c54917e240630c05a9b383010f1492bc61b4 -yqq
}

install_project_requirements() {
  printf "
#######################################################
BASE REQUIREMENTS
#######################################################
"
  apt update
  apt install -yqq software-properties-common
  apt install -yqq software-properties-common curl wget \
                          git nano dos2unix python3 python3-pip \
                          htop tmux net-tools openvpn \
                          mc dos2unix cmake docker docker-compose
  export tmux_file_path=$HOME_DIR/.tmux.conf && \
  echo "set -g mouse on " > ${tmux_file_path}
  printf "
tmux source-file ${tmux_file_path}
export DISPLAY=:0
xhost +" >> $HOME_DIR/.bashrc
}


install_connection_manager() {
  printf "
#######################################################
INSTALL CONNECTION MANAGER
#######################################################
"
  yes | apt-get install -yqq --reinstall libgtk2.0-0
  yes | apt-get install -yqq --reinstall lxsession

  yes | apt purge -yqq dhcpcd5
  yes | apt-get purge -yqq network-manager \
                           network-manager-gnome \
                           network-manager-l2tp \
                           network-manager-l2tp-gnome \
                           network-manager-vpnc

  yes | apt install -yqq network-manager \
                         network-manager-gnome \
                         network-manager-l2tp \
                         network-manager-l2tp-gnome \
                         network-manager-vpnc

  yes | apt install -yqq openrc \
                         libreswan \
                         xl2tpd \
                         ppp
}

modprobe_bcm2835_v4l2() {
  printf "
#######################################################
modprobe bcm2835-v4l2
#######################################################
"
  # https://urpylka.com/posts/post-59/
  modprobe bcm2835-v4l2
}


install_portainer() {
  printf "
#######################################################
INSTALL PORTAINER
#######################################################
"
  docker volume create portainer_data
  docker run -d \
             -p 9000:9000 \
             --name=portainer \
             --restart=always \
             -v /var/run/docker.sock:/var/run/docker.sock \
             -v portainer_data:/data \
             portainer/portainer
}


install_openvpn() {
  printf "
#######################################################
INSTALL OPENVPN
#######################################################
"
  apt-get install openvpn
}


install_kernel_headers() {
  printf "
#######################################################
INSTALL KERNEL HEADERS
#######################################################
"
  #yes | apt install -yqq raspberrypi-kernel-headers
  cd $CYBERBOT_SRC_DIR

  wget -O raspberrypi-kernel-headers.deb wget https://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/raspberrypi-kernel-headers_1.20220120-1_arm64.deb
  dpkg -i raspberrypi-kernel-headers.deb
}


install_v4l2loopback() {
  printf "
#######################################################
install v4l2loopback
#######################################################
"
  cd $CYBERBOT_SRC_DIR

  git clone https://github.com/umlaeute/v4l2loopback
  cd v4l2loopback
  git checkout c7a5cd4
  sleep 5
  make clean
  make
  make install
  depmod -a
}

set_v4l2loopback_dummy_device() {
  printf "
#######################################################
setting dummy device with v4l2loopback
#######################################################
"
  # https://github.com/umlaeute/v4l2loopback
  modprobe -r v4l2loopback            # remove old dummy devices
  #  # set new device
  #  # id=3  | /dev/video3   | card_labe
  #  modprobe v4l2loopback video_nr=3 card_label="usb processed"
  #  #modprobe v4l2loopback devices=1

  # SET V4L2LOOPBACK TO CREATE DUMMY DEVICE ON SYSTEM STARTUP:
  # One can avoid manually loading the module by letting systemd load the module at boot,
  # by creating a file /etc/modules-load.d/v4l2loopback.conf
  # with just the name of the module:
  loopback_module_boot_config=/etc/modules-load.d/v4l2loopback.conf
  printf "v4l2loopback" > $loopback_module_boot_config

  # This is especially convenient when v4l2loopback is installed with DKMS
  # or with a package provided by your Linux distribution.
  #
  #If needed, one can specify default module options by
  # creating /etc/modprobe.d/v4l2loopback.conf in the following form:
  loopback_module_device_config=/etc/modprobe.d/v4l2loopback.conf
  printf '
options v4l2loopback video_nr=3
options v4l2loopback card_label="USB processed streamer device"
' > $loopback_module_device_config

  #  #If your system boots with an initial ramdisk, which is the case
  #  # for most modern distributions, you need to update this ramdisk with the settings above,
  #  # before they take effect at boot time. In Ubuntu, this image is updated
  #  # with sudo update-initramfs.
  #  # The equivalent on Fedora is sudo dracut -f.
  #  update-initramfs
}



main
