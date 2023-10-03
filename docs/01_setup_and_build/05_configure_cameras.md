Настройка камер на роботе
---

Для выполнения настройки камер, необходимо, чтобы в системе был включен интерфейс rpi камеры.

**ВАЖНО: Перед выполнением настройки вставьте провод usb камеры в raspberry!** 


<details>
  <summary>
  1. Проверьте, что rpi камера корректно отображается в системе
  </summary>
  
  Проверьте наличие устройств /dev/video*:
    
    ls -ll /dev/video*
  
  ![ls /dev/video*](../images/ls_dev_video_rpi.jpg)
  
  Проверьте наличие камеры среди v4l устройств:
    
    v4l2-ctl --list-devices
  
  ![v4l2-ctl --list-devices](../images/v4l_list_devices.jpg)
</details>

<details>
  <summary>
  2. Проверьте, что usb камера корректно отображается в системе
  </summary>
  
  Проверьте наличие usb камеры в системе:
    
    v4l2-ctl --list-devices
   
</details>

<details>
  <summary>
  3. Создайте символьные ссылки для камер
  </summary>

  **С помощью скрипта:** 
  
    cd __setup/
    sudo bash 05_configure_cameras.sh
   
  После выполнения скрипта, необходимо перезагрузить raspberry. После перезагрузки, 
  правила udev должны примениться, а камеры станут доступны по пути `/dev/cams/usb` и `/dev/cams/rpi`. 
</details>

___

### Дополнительные полезные команды:

* Вывести список видеоустройств: `v4l2-ctl --list-devices`.
* Вывести список доступных контролов устройства: `v4l2-ctl --list-ctrls -d /dev/video0`.
* Вывести список доступных форматов видео: `v4l2-ctl --list-formats-ext -d /dev/video0`.
* Показать текущее значение контрола: `v4l2-ctl --get-ctrl=exposure_auto -d /dev/video0`.
* Изменить значение контрола: `v4l2-ctl --set-ctrl=exposure_auto=1 -d /dev/video0`.
* Показать список форматов с помощью ffmpeg: `ffmpeg -f v4l2 -list_formats all -i /dev/video0`.

[Список](https://github.com/jacksonliam/mjpg-streamer/blob/310b29f4a94c46652b20c4b7b6e5cf24e532af39/mjpg-streamer-experimental/utils.c#L97-L109) 
разрешений rpi камеры:

    { "QQVGA", 160,  120  },
    { "QCIF",  176,  144  },
    { "CGA",   320,  200  },
    { "QVGA",  320,  240  },
    { "CIF",   352,  288  },
    { "PAL",   720,  576  },
    { "VGA",   640,  480  },
    { "SVGA",  800,  600  },
    { "XGA",   1024, 768  },
    { "HD",    1280, 720  },        # 60 fps
    { "SXGA",  1280, 1024 },
    { "UXGA",  1600, 1200 },
    { "FHD",   1920, 1280 },




___ 

Отлично! Камеры настроены.

Робот готов к билду и запуску контейнеров CyberBot.

___ 
Далее: [Билд и запуск контейнеров CyberBot](06_build_and_run_cyberbot.md)

[[ Содержание ]](../README.md) | [[ На главную ]](../../README.md)
