#!/bin/bash
echo "1) Subdomain Scanner"
echo "2) Hidden Directories Scanner"
echo "3) Email & Info Collector"
echo "4) WAF Detector"
echo "5) Full Recon"
echo "6) Exit"

read -p "اختيارك [1-5]: " choice

case $choice in
  1)read -p "أدخل اسم الدومين (مثال: example.com): " domain
echo "[*] نبحث في crt.sh عن subdomains لـ $domain ..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sort -u
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sort -u | tee "${domain}_subdomains.txt"
echo "[+] Use assetfinder to gather more subdomains? (y/n)"
read extra
if [[ $extra == "y" ]]; then
    if ! command -v assetfinder &> /dev/null; then
        echo "[!] assetfinder not found. Install it using: go install github.com/tomnomnom/assetfinder@latest"
        exit 1
    fi
    assetfinder --subs-only $domain >> ${domain}_subdomains.txt
    sort -u ${domain}_subdomains.txt -o ${domain}_subdomains.txt
fi
    echo "[+] اخترت Subdomain Scanner"
    ;;
  2) # First Gobuster Scan
    read -p "🌐 إدخل رابط الموقع (مثال: https://example.com): " url
    read -p "📂 إدخل مسار ملف wordlist (مثال: /usr/share/wordlists/dirb/common.txt): " wordlist
    echo "[*] جاري فحص المجلدات المخفية في $url ..."
    gobuster dir -u "$url" -w "$wordlist" -t 50 -o hidden_dirs.txt
    echo "[+] تم حفظ النتائج في hidden_dirs.txt ✅"

    # Second Gobuster Scan 
    echo -n "🌐 إدخل رابط الموقع (مثال: https://example.com): "
    read url
    echo -n "📂 إدخل wordlist (المسار الكامل): "
    read wordlist
    echo "[*] جاري البحث على مجلدات مخفية في $url ..."
    gobuster dir -u "$url" -w "$wordlist" -t 50 -o gobuster_results.txt
    echo "[+] تم الحفظ في gobuster_results.txt ✅"
    echo "[+] Hidden Directories Scanner ✅"
    ;;
  3)echo "[+] 📨 Email & Info Collector"
read -p "📍 أدخل اسم الدومين (مثال: example.com): " domain
read -p "🌐 أدخل مصدر البحث (مثال: google, bing, linkedin): " source

echo "[*] جاري جمع الإيميلات والمعلومات من $source ..."
theHarvester -d "$domain" -b "$source" -f "${domain}_info.html"

echo "[+] Email info محفوظة في ${domain}_info.html ✅"
xdg-open "${domain}_info.html" 2>/dev/null &
    ;;
  4)echo "[+] WAF Detector 🛡️"
    read -p "🌐 أدخل رابط الموقع (مثال: https://example.com): " url
    echo "[*] جاري التحقق من وجود WAF في $url ..."
    wafw00f "$url" | tee waf_detection.txt
    echo "[+] النتائج تم حفظها في waf_detection.txt ✅"
    ;;
    5)
echo "[+] 🔄 Starting Full Recon 🔍"

read -p "🌐 أدخل اسم الدومين (مثال: example.com): " domain
read -p "📂 أدخل مسار ملف الwordlist (مثال: /usr/share/wordlists/dirb/common.txt): " wordlist
read -p "🌐 أدخل مصدر البحث (مثال: google, bing, linkedin): " source

# Subdomain Scanner
echo "[*] 🔎 جاري جمع الsubdomains ..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sort -u > "${domain}_subdomains.txt"
echo "[+] Subdomains تم حفظهم في ${domain}_subdomains.txt ✅"

# Gobuster Scan
echo "[*] 📁 جاري البحث على مجلدات مخفية ..."
gobuster dir -u "https://$domain" -w "$wordlist" -t 50 -o gobuster_results.txt
echo "[+] نتائج gobuster محفوظة في gobuster_results.txt ✅"

# Email & Info Collector
echo "[*] 📧 جاري جمع الإيميلات والمعلومات من $source ..."
theHarvester -d "$domain" -b "$source" -f "${domain}_info.html"
echo "[+] Email info محفوظ في ${domain}_info.html ✅"
xdg-open "${domain}_info.html" 2>/dev/null &

# WAF Detector
echo "[*] 🛡️ التحقق من وجود WAF ..."
wafw00f "https://$domain" | tee waf_detection.txt
echo "[+] WAF detection محفوظة في waf_detection.txt ✅"
;;
  6)
    echo "ByeBye AyB 👋"
    exit 0
    ;;
  *)
    echo "[!] اختيار غير صحيح، جرّب رقم من 1 إلى 5"
    ;;
esac
