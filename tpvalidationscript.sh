#!/bin/sh

#Vérification si virtualbox est installé
dpkg -s $virtualbox &> /dev/null

if [ $virtualbox != 0 ]; then
	echo "installation de virtualbox"
	sudo apt-get install virtualbox-qt
	sudo apt-get install virtualbox-dkms
else
	echo "virtualbox déjà installé"
fi

#Vérification si vagrant est installé
dpkg -s $vagrant &> /dev/null

if [[ $vagrant != 0 ]]; then
	echo "installation de vagrant"
	sudo apt-get install vagrant
else
	echo "virtualbox déjà installé"
fi

read -p "Voulez-vous une configuration automatique [1] ou manuel [2] de vagrant
" choice

if [[ "$choice" = "1" ]]; then
	vagrant init
	sed -i -e 's/base/ubuntu\/xenial64/g' Vagrantfile
	sed -i -e 's/  \# config.vm.network \"private_network\", ip: \"192.168.33.10\"/  config.vm.network \"private_network\", ip: \"192.168.33.10\"/g' Vagrantfile
	sed -i -e 's/  \# config.vm.synced_folder \"..\/data\", \"\/vagrant_data\"/  config.vm.synced_folder \"data\", \"\/var\/www\/html\"/g' Vagrantfile	
	mkdir data
elif [[ "$choice" = "2" ]]; then
	read -p "Quel box voulez-vous choisir
	1- xenial64
	2- trusty64
	" box
	if [[ "$box" = "1" ]]; then
		vagrant init
		sed -i -e 's/base/ubuntu\/xenial64/g' Vagrantfile
		sed -i -e 's/  \# config.vm.network \"private_network\", ip: \"192.168.33.10\"/  config.vm.network \"private_network\", ip: \"192.168.33.10\"/g' Vagrantfile
		sed -i -e 's/  \# config.vm.synced_folder \"..\/data\", \"\/vagrant_data\"/  config.vm.synced_folder \"data\", \"\/var\/www\/html\"/g' Vagrantfile	
		mkdir data
	elif [[ "$box" = "2" ]]; then
		vagrant init
		sed -i -e 's/base/ubuntu\/trusty64/g' Vagrantfile
		sed -i -e 's/  \# config.vm.network \"private_network\", ip: \"192.168.33.10\"/  config.vm.network \"private_network\", ip: \"192.168.33.10\"/g' Vagrantfile
		sed -i -e 's/  \# config.vm.synced_folder \"..\/data\", \"\/vagrant_data\"/  config.vm.synced_folder \"data\", \"\/var\/www\/html\"/g' Vagrantfile	
		mkdir data
	else
		echo "Veuillez choisir uniquement 1 ou 2"
	fi
else
	echo "Veuillez choisir uniquement 1 ou 2"
fi

echo "Lancement de Vagrant"
vagrant up && vagrant global-status

read -p "Voulez-vous arrêter la vagrant Y/n
" stop
while [[ "$stop" = "n" ]]; do
	if [[ "$stop" = "Y" ]]; then
	vagrant halt
	echo "Arrêt de vagrant"
elif [[ "$stop" = "n" ]]; then
	echo "on continue"
	read -p "Voulez-vous arrêter la vagrant Y/n
" stop
else
	echo "Veuillez choisir uniquement Y ou n"
fi
done