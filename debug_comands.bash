# Comandos válidos para Oracle 9
# Validando arquivos de configuração
# Exibe a linha onde está o erro de configuração referente a X serviço do bacula, caso não exiba nada ao executar o comando, a configuração está correta.
# Adapte o caminho do arquivo de configuração a sua necessidade, em algumas instalações do Bacula, os caminhos podem ser diferentes como em /etc ao invés de /opt.

bacula-dir -tc /opt/bacula/etc/bacula-dir.conf
bacula-sd -tc /opt/bacula/etc/bacula-sd.conf
bacula-fd -tc /opt/bacula/etc/bacula-fd.conf

# Reinicialização de serviços

systemctl restart bacula-dir.service
systemctl restart bacula-sd.service
systemctl restart bacula-fd.service

# Verificando serviços rodando

ps aux | grep bacula

# Portas do firewall que o bacula escuta
netstat -tulnp | grep -i bacula
