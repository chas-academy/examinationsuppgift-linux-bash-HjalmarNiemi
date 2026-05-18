#!/bin/bash

#kontrollera att användaren är root (0) (EUID -not equal to 0 så stängs scriptet ned) 

if [ "$EUID" -ne 0 ]; then
	echo "Fel: Måste köras som root."
	exit 1
fi

echo "Scriptet körs som root."

# Skapa användare som skickas in genom lista

for username in "$@"; do
done
# Skapar hemkatalog till användaren

useradd -m "$username"



