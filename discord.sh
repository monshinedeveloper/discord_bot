#!/bin/bash

# Funktion zum Hinzufügen des Alias in die .bash_profile
add_alias_to_bash_profile() {
    if ! grep -q "alias discord=" ~/.bash_profile; then
        echo "alias discord='$PWD/discord.sh'" >> ~/.bash_profile
        source ~/.bash_profile
    fi
}

# Funktion zur Installation von Paketen auf Termux
install_termux_packages() {
    pkg install python python-tkinter
}

# Funktion zur Installation von Paketen auf Debian/Ubuntu
install_debian_packages() {
    sudo apt-get install python3 python3-tk
}

# Funktion zur Auswahl des Paketmanagers
select_package_manager() {
    PS3='Bitte wählen Sie Ihr Betriebssystem: '
    options=("Termux" "Debian/Ubuntu" "Abbrechen")
    select opt in "${options[@]}"
    do
        case $opt in
            "Termux")
                install_termux_packages
                break
                ;;
            "Debian/Ubuntu")
                install_debian_packages
                break
                ;;
            "Abbrechen")
                exit
                ;;
            *) echo "Ungültige Option $REPLY";;
        esac
    done
}

# Paketmanager auswählen
select_package_manager

# Erstellen Sie das Python-Skript für die GUI
cat << 'EOF' > setup_discord_bot.py
import tkinter as tk
from tkinter import messagebox
import os

def setup_bot():
    token = token_entry.get()
    # Führen Sie hier den eigentlichen Setup-Vorgang für den Discord-Bot durch
    messagebox.showinfo("Setup abgeschlossen", "Der Discord-Bot wurde erfolgreich eingerichtet!")

def create_command():
    command_name = command_entry.get()
    # Hier können Sie den Befehl erstellen und entsprechende Aktionen ausführen
    os.system(f"echo 'Der Befehl {command_name} wurde erstellt'")

# GUI erstellen
root = tk.Tk()
root.title("Discord Bot Setup")

token_label = tk.Label(root, text="Geben Sie den Bot-Token ein:")
token_label.pack()

token_entry = tk.Entry(root)
token_entry.pack()

setup_button = tk.Button(root, text="Setup durchführen", command=setup_bot)
setup_button.pack()

# Bot-Befehl erstellen
command_label = tk.Label(root, text="Geben Sie den Namen des Bot-Befehls ein:")
command_label.pack()

command_entry = tk.Entry(root)
command_entry.pack()

create_command_button = tk.Button(root, text="Befehl erstellen", command=create_command)
create_command_button.pack()

root.mainloop()
EOF

# Ausführbare Berechtigung erteilen
chmod +x setup_discord_bot.py

# Fügen Sie den Alias zur .bash_profile hinzu, wenn er nicht vorhanden ist
add_alias_to_bash_profile

# Ausführen des Skripts
./setup_discord_bot.py
