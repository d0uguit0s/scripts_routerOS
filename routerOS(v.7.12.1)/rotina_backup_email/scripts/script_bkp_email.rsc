# Variaveis de config
:local data [/system/clock/get date]
:local hora [/system/clock/get time]

# Backup binário
/system/backup/save name="backup_$nameFiles_binario" password=geolinklanrb2024

# Backup de configuração
/export file="backup_$nameFiles_config" show-sensitive compact

/delay 15s

/tool/e-mail/send to="suporte@geolan.com.br"\
  tls=yes\
  subject="Backup automático MIKROTIK $nameClientBold"\
  file=backup_$nameFiles_binario.backup,backup_$nameFiles_config.rsc\
  body="Em anexo, dois arquivos de backup do mikrotik $nameClientCapitalize realizado em $data as $hora.\
  \n\rUTLIZE O BACKUP BINÁRIO APENAS PARA RESTAURAR O MESMO DISPOSITIVO EM QUE ELE FOR GERADO!\
  \n\rEM OUTROS CASOS UTILIZE O BACKUP DE CONFIGURAÇÃO!"

/log/warning "Enviando e-mail de backup!!!"

/delay 15s

/file/remove backup_$nameFiles_binario.backup,backup_$nameFiles_config.rsc
