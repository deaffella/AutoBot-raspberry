Билд и запуск контейнеров MegaBot
---

Перед билдом контейнеров обратите внимание, что USB камера и USB штекер 
микроконтроллера должны быть подключены к raspberry. Стоит проверить 
наличие камер внутри `/dev/video*` и с помощью `v4l2-ctl --list-devices`
___


### Установка vpn соединения
___

Необходимо скопировать сертификат, созданный на сервере (обратитесь к админу)
в папку на роботе `/etc/openvpn/` с произвольным именем и расширением `.conf`,
например:

    sudo nano /etc/openvpn/client.conf

Далее нужно перезапустить сервис openvpn:

    sudo service openvpn restart
    
    # или если не работает, то:
    
    sudo systemctl restart openvpn@client.service
    
    # или если не работает, то:
    
    sudo systemctl stop openvpn@client
    sudo systemctl enable openvpn@client.service
    sudo systemctl start openvpn@client

Проверка статуса клиента:

    sudo systemctl status openvpn@client.service
    
После рестарта стоит подождать секунд 10 и потом проверить наличие интерфейса `tun0`, 
а также полученный адрес с помощью команды `ifconfig`.

___



### Билд проекта
___

Находясь внутри директории `CyberBot/` выполните следующую команду, чтобы собрать проект:

      sudo bash build_project.sh

___ 

Отлично! Контейнеры собраны и запущены.

Робот готов к работе.

Рекомендуем вернуться на страницу с оглавлением и 
ознакомиться со следующей главой.

___ 

[[ Содержание ]](../README.md) | [[ На главную ]](../../README.md)
