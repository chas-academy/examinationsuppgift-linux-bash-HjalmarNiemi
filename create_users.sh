#!/bin/bash

#kontrollera att användaren är root (0) (EUID -not equal to 0 så stängs scriptet ned) 

if [ "$EUID" -ne 0 ]; then
	echo "Fel: Måste köras som root."
	exit 1
fi

# Skapa användare som skickas in genom lista som argument

for username in "$@"; do
	if id "$username" &>/dev/null; then
		echo "Användaren $username finns redan."
		continue
	fi

	useradd -m "$username"


	if [ $? -ne 0 ]; then
		echo "Användaren $username kunde inte skapas."
		continue
	fi
done

for username in "$@"; do
	if ! id "$username" &>/dev/null; then
		continue
	fi


# Skapar användarens hemkatalog

mkdir -p "/home/$username/Documents"
mkdir -p "/home/$username/Downloads"
mkdir -p "/home/$username/Work"

# Ge rättigheter på katalogerna till ägaren

chown -R "$username:$username" "/home/$username/Documents" "/home/$username/Downloads" "/home/$username/Work"
chmod 700 "/home/$username/Documents" "/home/$username/Downloads" "/home/$username/Work"

# Välkomstmeddelande

echo "Välkommen $username" > "/home/$username/welcome.txt"

# Lista över andra användare & filtrera bort de med UID under 1000 (systemanvändare tex root)

awk -F: '$3 >= 1000 {print $1}' /etc/passwd | grep -v "^$username$" >> "/home/$username/welcome.txt"

# Ge rättigheter till ägaren för welcome.txt

chown "$username:$username" "/home/$username/welcome.txt"
chmod 600 "/home/$username/welcome.txt"

echo "Användaren $username skapades."

done

