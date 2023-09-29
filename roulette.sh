#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm && exit 1
}

# Ctrl + C
trap ctrl_c INT
function helpPanel(){
	
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
	echo -e "\t${purpleColour}m)${endColour} ${grayColour} Indicar la cantidad de dinero a usar${endColour}"	
	echo -e "\t${purpleColour}t)${endColour} ${grayColour} Indicar la téncica a usar${endColour} ${purpleColour}(martingala/inverseLabrouchere)${endColour}"	
	echo -e "\t${purpleColour}h)${endColour} ${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function martingala(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money€${endColour}"
	echo -ne "\n${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -> ${endColour}" && read initialBet
	echo -ne "\n${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar (par/impar)? -> ${endColour}" && read parImpar
	
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad de ${endColour}${yellowColour}$initialBet€${endColour} 
			${grayColour} a ${endColour}${yellowColour}$parImpar${endColour}"
	
	jugadasTotal=0
	wins=0
	loseStrike=0
	maxBet=300
	bet=initialBet
	tput civis	
	while true; do
		
		if [ $bet -gt $maxBet ]; then
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} La apuesta maxima es de $maxBet y estas intentando apostar $bet la apuesta sera: ${endColour}${yellowColour}$maxBet€${endColour}"
			bet=$maxBet
		fi
	
		if [ $(($money-$bet)) -le 0 ]; then
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} No queda saldo para hacer más apuestas. Dinero actual: ${endColour}${yellowColour}$money€${endColour}"
			echo -e "\n${yellowColour}[STATS]${endColour}${blueColour} Jugadas Totales: $jugadasTotal ${endColour}${greenColour}Wins: $wins${endColour}${redColour} Última racha de pérdidas: $loseStrike${endColour}"
			break
		fi
		
		jugadasTotal=$(($jugadasTotal+1))
		randomNumber="$(($RANDOM % 37))"
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero: ${endColour}${yellowColour}$randomNumber${endColour}"
		if [ "$(($randomNumber % 2))" -eq 0 ]; then
			if [ $randomNumber -eq 0 ]; then
				jugada="lose"
			else
				jugada="par"
			fi
		else
			jugada="impar"
		fi
		
		if [ "$jugada" == "$parImpar" ]; then
			echo -e "${greenColour} [+] WIN! ${endColour}"
			money=$(($money+$bet))
			bet=$initialBet
			wins=$(($wins+1))
			loseStrike=0
		else
			echo -e "${redColour} [-] LOSE :( ${endColour}"
			money=$(($money-$bet))
			bet=$(($bet*2))
			loseStrike=$(($loseStrike+1))
		fi
		
		echo -e "${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money€${endColour}"
		
	done
	tput cnorm
}

while getopts "m:t:h" arg; do
	case $arg in
		m) money=$OPTARG;;
		t) technique=$OPTARG;;
		h) helpPanel;;
	esac
done

if [ $money ] && [ $technique ]; then
	if [ "$technique" == "martingala" ]; then
		martingala
	else
		echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}" 
	fi
else
	helpPanel
fi
