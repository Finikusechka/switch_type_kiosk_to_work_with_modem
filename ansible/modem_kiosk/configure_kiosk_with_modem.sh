#!/bin/bash
seed=seed244                                               # имя из hosts.yml
dir_of_script=/home/vlad/git_projects/ansible/modem_kiosk/ # Дирректория де лежит ансибл проект
ANSIBLE_CONFIG=/home/vlad/git_projects/ansible/modem_kiosk/ansible.cfg #Указываем ansible config file
export ANSIBLE_CONFIG                                      # Экспортируем переменную в окружение
read -a ip -p 'Введите IP киоска > '
read -a town -p 'Введите название города > '
read -a cinematheater -p 'Введите название кинотеатра > '
read -a serial_kiosk -p 'Введите номер киоска > '
full_name_ovpn_file=$ip'_'$town'_'$cinematheater
echo $full_name_ovpn_file

ansible-playbook -i "$dir_of_script"hosts.yml "$dir_of_script"create_and_dowload_ovpn.yaml  -e "fullnamekiosk=$full_name_ovpn_file" --vault-password-file /home/vlad/ansible/password_for_vault #Ансибл создает и забирает на локальный пк ovpn конфиг файл

mv /home/vlad/"$seed"/home/denis/ovpns/"$full_name_ovpn_file".ovpn /home/vlad/vpn_file_for_kiosk/"$full_name_ovpn_file".conf #Переименовываем полученный файл для автозапуска ovpn

echo -e "script-security 2 \nup /etc/openvpn/update-resolv-conf \ndown /etc/openvpn/update-resolv-conf" >> /home/vlad/vpn_file_for_kiosk/"$full_name_ovpn_file".conf # Добавляем необходимые настройки в конф файл

ansible-playbook -i "$dir_of_script"inventory.ini -e "serial_kiosk=$serial_kiosk fullnamekiosk=$full_name_ovpn_file" "$dir_of_script"work_on_kiosk.yaml --vault-password-file /home/vlad/ansible/password_for_vault





