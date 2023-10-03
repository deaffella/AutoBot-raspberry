Установка Raspbian на чистую microSD
---

Для прошивки роботов используется 64-bit версия
[Raspberry Pi OS with desktop](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit).


**ВАЖНО:** 

_Возможно использование образов `bullseye` и `buster`. 
Так как версия `buster` является устаревшей, при использовании 
не гарантируется полная работоспособность всех микросервисов.
Аналог стримера, работоспособность которого не гарантируется в `bullseye`: 
[camera-streamer](https://github.com/ayufan-research/camera-streamer)._
 
___ 

## Как прошить sd карту:

<details>
  <summary>
  1. Скачивем образ Raspbian.
  </summary>
  
  Образы доступны на официальном [сайте](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit)
  или на [Яндекс.Диске](https://disk.yandex.ru/d/arZfvrgcoGb-0Q).
  
  Необходимо выбрать образ `Raspberry Pi OS with desktop and recommended software`:
  
  1. [Torrent](https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-02-22/2023-02-21-raspios-bullseye-arm64.img.xz.torrent)
  
  2. [2023-02-21-raspios-bullseye-arm64.img.xz](https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-02-22/2023-02-21-raspios-bullseye-arm64.img.xz)
  
</details>

<details>
  <summary>
  2. Скачиваем утилиту для прошивки sd карт.
  </summary>
  
  Рекомендуется использовать кроссплатформенный [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
</details>

<details>
  <summary>
  3. Прошиваем карту.
  </summary>
  
  При использовании [Raspberry Pi Imager](https://www.raspberrypi.com/software/) 
  следует воспользоваться официальной [инструкцией](https://raspberrytips.com/raspberry-pi-imager-guide/).
</details>

<details>
  <summary>
  4. Выполняем первичную конфигурацию системы.
  </summary>
  
  После завершения прошивки карты, вставляем её в raspberry и ждем загрузки системы.
  Перед включением, необходимо подключить монитор, клавиатуру и мышь к raspberry, так как
  дальнейшая установка будет выполняться с помощью гуи. Необходимо также подключить и ethernet кабель,
  так как для дальнейшей работы с raspberry будут использоваться vnc и ssh.
  
  На этапе конфигурации системы рекомендуется выбрать country - `Russian Federation`, 
  language - `Russian`, timezone - `Moscow`, отметить галочками `Use English language` и `Use US keyboard`.
  Выбор имени пользователя и пароля выполняется по желанию, но рекомендуется связка `pi:raspberry`.
  Рекомендуется пропустить диалог с выбором доступной wifi сети, а также ответить **СОГЛАСИЕМ** в
  диалоге обновления системы.
  
  После продолжительного процесса обновления система загрузится и будет готова к дальнейшим действиям.
</details>

<details>
  <summary>
  5. Включаем интерфейсы и меняем hostname.
  </summary>
  
  Для включения интерфейсов rpi камеры, serial, ssh, vnc, а также для смены
  hostname необходимо открыть терминал (сочетание клавиш `ctrl + shift + t`) и ввести
  командку `sudo raspi-config`. В открывшемся меню в разделе `System Options` необходимо
  выбрать `Hostname` и ввести новое имя. В разделе главного меню `Interface Options`
  находятся настройки интерфейсов rpi камеры, serial, ssh, vnc и др.
  
  ![Главное меню raspi-config](../images/raspi_config_main_menu.jpg)
</details>

<details>
  <summary>
  6. Перезагружаем raspberry.
  </summary>
  
  После перезагрузки raspberry поменяет hostname, а интерфейсы включатся.
</details>


___ 

Отлично! Система установлена и готова к дальнейшей установке базовых зависимостей.

___ 
Далее: [Установка базовых зависимостей](02_install_base_requirements.md)

[[ Содержание ]](../README.md) | [[ На главную ]](../../README.md)
