#!/bin/bash
read -a ip -p 'Введите IP киоска > '
read -a town -p 'Введите название города > '
read -a cinematheater -p 'Введите название кинотеатра > '
read -a serial_kiosk -p 'Введите номер киоска > '
full_name_ovpn_file=$ip'_'$town'_'$cinematheater
echo $full_name_ovpn_file

ansible-playbook -i hosts.yml create_and_dowload_ovpn.yaml  -e "fullnamekiosk=$full_name_ovpn_file" #Ансибл создает и забирает на локальный пк ovpn конфиг файл

mv /home/vlad/seed240/home/denis/ovpns/"$full_name_ovpn_file".ovpn /home/vlad/vpn_file_for_kiosk/"$full_name_ovpn_file".conf #Переименовываем полученный файл для автозапуска ovpn

echo -e "script-security 2 \nup /etc/openvpn/update-resolv-conf \ndown /etc/openvpn/update-resolv-conf" >> /home/vlad/vpn_file_for_kiosk/"$full_name_ovpn_file".conf # Добавляем необходимые настройки в конф файл

ansible-playbook -i inventory.ini -e "serial_kiosk=$serial_kiosk fullnamekiosk=$full_name_ovpn_file" work_on_kiosk.yaml





