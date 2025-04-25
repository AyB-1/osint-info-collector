#!/bin/bash

# Colors
blue="\e[34m"
green="\e[32m"
purple="\e[35m"
cyan="\e[36m"
reset="\e[0m"

# Main Menu
while true; do
    clear
    echo -e "${cyan}"
    echo "    __        _______ ____   ____ ___  __  __ _____ "
    echo "    \ \      / / ____|  _ \ / ___/ _ \|  \/  | ____|"
    echo "     \ \ /\ / /|  _| | |_) | |  | | | | |\/| |  _|  "
    echo "      \ V  V / | |___|  _ <| |__| |_| | |  | | |___ "
    echo "       \_/\_/  |_____|_| \_\\____\___/|_|  |_|_____|"
    echo -e "${reset}"
    echo -e "${purple}             ~ OSINT Info Collector by LuCass ~${reset}"

    echo ""
    echo "[1] WHOIS Lookup"
    echo "[2] WAF Detection"
    echo "[3] DNS Records Lookup"
    echo "[4] GeoIP Lookup"
    echo "[5] Email Breach Checker"
    echo "[6] Username Checker"
    echo "[7] Reverse IP Lookup"
    echo "[8] My IP GeoLookup"
    echo "[9] Exit"
    echo ""

    read -p ">> Choose an option [1-9]: " option

    if [ "$option" == "1" ]; then
        read -p "Enter the domain (example.com): " domain
        echo -e "$blue[+] Running WHOIS Lookup on $domain...$reset"
        whois "$domain"
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "2" ]; then
        read -p "Enter the URL (https://example.com): " url
        echo -e "$blue[+] Running WAF Detection on $url...$reset"
        wafw00f "$url"
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "3" ]; then
        read -p "Enter the domain (example.com): " domain
        echo -e "$blue[+] Running DNS Records Lookup on $domain...$reset"
        dig "$domain" ANY +noall +answer
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "4" ]; then
        read -p "Enter the IP address: " ip
        echo -e "$blue[+] Running GeoIP Lookup on $ip...$reset"
        curl -s "ipwho.is/$ip" | jq .
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "5" ]; then
        read -p "Enter the email address: " email
        echo -e "$blue[+] Checking for breaches on $email...$reset"
        curl -s "https://haveibeenpwned.com/api/v3/breachedaccount/$email" \
            -H "hibp-api-key: YOUR_API_KEY" | jq .
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "6" ]; then
        read -p "Enter the username: " username
        echo -e "$blue[+] Searching for $username on social platforms...$reset"
        echo "[~] Try using Sherlock or Maigret manually."
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "7" ]; then
        read -p "Enter the domain or IP: " target
        echo -e "$blue[+] Running Reverse IP Lookup on $target...$reset"
        curl -s "https://api.hackertarget.com/reverseiplookup/?q=$target"
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "8" ]; then
        echo -e "$blue[+] Getting your public IP and location...$reset"
        ip=$(curl -s ifconfig.me)
        echo -e "$green[+] Your Public IP: $ip$reset"
        curl -s "ipwho.is/$ip" | jq .
        echo -e "\nPress Enter to return to the menu..."
        read

    elif [ "$option" == "9" ]; then
        clear
        echo -e "$purple[!] Exiting... Showing animation 👇$reset"
        sleep 1

        lucass_animation() {
            frames=(
"     (\_/)
     ( •_•)
    />💻    "
"     (\_/)
     ( •_•)  🔍
    />      "
"     (\_/)
     ( •_•)💡
    />       "
"     (\_/)
     ( •_•)📡
    />        "
"     (\_/)
     ( •_•)☠️
    />        "
            )
            for frame in "${frames[@]}"; do
                clear
                echo -e "\e[1;36m$frame\e[0m"
                sleep 0.5
            done

            echo -e "\n\e[1;35m~ Crafted with pride by LuCass 💻\e[0m"
        }

        lucass_animation
        exit 0

    else
        echo -e "$purple[!] Invalid option. Try again.$reset"
        sleep 2
    fi
done
