#!/bin/bash

# функция для создания udev правила для USB камеры
function create_usb_udev_rule {
    usb_camera_SYMLINK=cams/usb_src
    usb_cam_rule_file=/etc/udev/rules.d/99-usbcam.rules

    # ищем устройство с указанием на USB шину
    usb_device=$(v4l2-ctl --list-devices | grep -A 1 'usb-' | grep -o '/dev/video[0-9]*')
    cam_idx=$(echo $usb_device | sed 's/[^0-9]*//g')

    if [[ -n "$usb_device" ]]; then
        # извлекаем idVendor и idProduct из вывода udevadm
        ID_VENDOR_ARRAY=`udevadm info -a -n $usb_device |grep "ATTRS{idVendor}"`
        ID_PRODUCT_ARRAY=`udevadm info -a -n $usb_device |grep "ATTRS{idProduct}"`
        FIRST_ID_VENDOR=($(echo $ID_VENDOR_ARRAY | tr "    " "\n"))
        FIRST_ID_PRODUCT=($(echo $ID_PRODUCT_ARRAY | tr "    " "\n"))
        id_vendor=($(echo $FIRST_ID_VENDOR | sed "s/ATTRS{idVendor}==\"//g" | sed "s/\"//g"))
        id_product=($(echo $FIRST_ID_PRODUCT | sed "s/ATTRS{idProduct}==\"//g" | sed "s/\"//g"))

        if [[ -n "$id_vendor" && -n "$id_product" ]]; then
            # создаем новое udev правило
            echo "$usb_device"
            echo "Создание udev правила для USB камеры с idVendor=$id_vendor и idProduct=$id_product..."
            #echo "SUBSYSTEM==\"video4linux\", ATTRS{idVendor}==\"$id_vendor\", ATTRS{idProduct}==\"$id_product\", GROUP=\"video\", ATTR{index}==\"${cam_idx}\", MODE=\"0664\", SYMLINK+=\"${usb_camera_SYMLINK}\"" > $usb_cam_rule_file
            echo "SUBSYSTEM==\"video4linux\", ATTRS{idVendor}==\"$id_vendor\", ATTRS{idProduct}==\"$id_product\", GROUP=\"video\", ATTR{index}==\"0\", MODE=\"0664\", SYMLINK+=\"${usb_camera_SYMLINK}\"" > $usb_cam_rule_file
            echo "Перезапись файла $usb_cam_rule_file завершена."
        else
            echo "Ошибка: Не удалось извлечь idVendor и idProduct из вывода v4l2-ctl."
        fi
    else
        echo "Ошибка: Не найдено устройство с указанием на USB шину."
    fi
}

# функция для создания сервиса для проверки существования символьной ссылки для rpi камеры
function create_rpi_symlink_check_service {
    rpi_camera_device_name="mmal service"
    rpi_camera_SYMLINK=cams/rpi_src

    echo "Создание службы systemd для проверки символьной ссылки /dev/$rpi_camera_SYMLINK"
    # Создаем файл службы в /etc/systemd/system/
    echo "[Unit]
Description=Check for presence of rpi cam mmal service 16.1 symlink
After=dev-cams-rpi.device

[Service]
Type=oneshot
Restart=on-failure
RestartSec=2s
ExecStart=/bin/bash -c \"mkdir -p /dev/cams && rpi_path=\$(v4l2-ctl --list-devices | grep -A 1 '$rpi_camera_device_name' | grep -o '/dev/video[0-9]*');if [[ ! -e /dev/$rpi_camera_SYMLINK ]]; then ln -s \$rpi_path /dev/$rpi_camera_SYMLINK; fi\"

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/check-rpi-cam.service
    # Обновляем список служб
    systemctl daemon-reload
    # Включаем службу при загрузке системы
    systemctl enable check-rpi-cam.service
    echo "Создание службы завершено."
}

# проверяем, запущен ли скрипт с помощью sudo
if [[ $(id -u) -ne 0 ]]; then
    echo "Ошибка: Скрипт должен быть запущен с помощью sudo."
    exit 1
fi

# вызываем функции для создания udev правил и символьной ссылки
create_usb_udev_rule
create_rpi_symlink_check_service

echo "Настройка камер завершена."

