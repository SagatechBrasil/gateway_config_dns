# Gateway LoRa.

## Comandos para o terminal SSH.

### Download dos arquivos e inicialização dos serviços.
```
opkg update
opkg install coreutils-nohup
opkg install mosquitto
opkg install mosquitto-client
opkg install libmosquitto

/etc/init.d/mosquitto enable
/etc/init.d/mosquitto start

cd /usr/sbin/
wget ./chirpstack-gateway-bridge
chmod +x chirpstack-gateway-bridge

mkdir /etc/chirpstack-gateway-bridge/
cd /etc/chirpstack-gateway-bridge/
wget ./chirpstack-gateway-bridge.toml
chmod +x chirpstack-gateway-bridge.toml

cd /etc/init.d/
wget ./script/chirpstack-gateway-bridge
chmod +x chirpstack-gateway-bridge

/etc/init.d/chirpstack-gateway-bridge start
/etc/init.d/chirpstack-gateway-bridge enable
cd /app/cfg/
rm global_conf.json
wget ./global_conf.json
chmod +x global_conf.json
```

### Configuração do MAC.
Altere o endereço MAC substituindo 00007076FF02AB1D pelo MAC.
```
sed -i 's/000080029c45743e/00007076FF02AB1D/' /app/cfg/global_conf.json
```

### Agendamento da inicilização LoRa
```
cd /sbin/
wget ../script/check_lora_init_process.sh
chmod +x check_lora_init_process.sh
(crontab -l ; echo "*/1 * * * * /sbin/check_lora_init_process.sh") | crontab -
(crontab -l ; echo "0 0 * * * /sbin/reboot now") | crontab -
```

##

## Configuração da conexão de Rede

Abra o arquivo de configuração e substituia as configurações de interface WAN conforme a operadora que será utilizada.
```
vi /etc/config/network 
```

### Configuração Vivo
```
config interface 'wan'
	option pincode '1234'
	option device '/dev/ttyUSB0'
	option apn 'zap.vivo.com.br'
	option proto '3g'
	option username 'vivo'
	option password 'vivo'
	option at_port '/dev/ttyUSB0'
```

### Script para teste da conexão

Crie e abra o arquivo check_no_connection_reboot.sh
```
cd /sbin
touch check_no_connection_reboot.sh
vi check_no_connection_reboot.sh 
```

Adicione as linhas no arquivo.
```
#!/bin/bash
# Set target host IP or hostname
TARGET_HOST='google.com.br'
count=$(ping -c 10 $TARGET_HOST | grep from* | wc -l)
if [ $count -eq 0 ]; then
    echo "$(date)" "Target host" $TARGET_HOST "unreachable, Rebooting!" >>/var/log/check_no_connection_reboot.log
    /sbin/shutdown -r 0
else
    echo "$(date) ===-> OK! " >>/var/log/check_no_connection_reboot.log
fi
```

### Agendamento do Script de teste da conexão.
```
chmod +x check_no_connection_reboot.sh
(crontab -l ; echo "*/3 * * * * nohup /sbin/check_no_connection_reboot.sh") | crontab -
reboot
```
