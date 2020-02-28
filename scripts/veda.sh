#!/bin/bash
company=company_name
message="Sevgili çalışma arkadaşlarım, bugün itibariyle görevimden ayrılmış bulunuyorum. 1,5 yıl içerisinde yolumuzun kesiştiği, bişeyler paylaştığımız, herbiri birbirinden değerli yol arkadaşlarıma saygılarımı ve teşekkürlerimi sunuyorum. İnşallah tekrardan yolumuz kesişir, tekrardan beraber çalışma fırsatı buluruz. Saygılarımla."

for employee in $company; do
    send-message $message to $employee
    if [[ ! $? -eq 0 ]]; then
        echo 'CRITICAL: mail sending stucked at ' $employee
        exit 2
    else
        echo 'İletildi: ' $employee
    fi
done

DEVOPS[0]=x && DEVOPS[1]=ahmet && DEVOPS[2]=z
unset DevOps[1] #DevOps'dan 1. terim unset edildi.
rm -rf /companies/$company/ahmet.yuksel

@ahmetmyuksel
LinkedIn & Instagram & GitHub
