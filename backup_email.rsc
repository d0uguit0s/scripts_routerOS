# Agenda tarefa
/system scheduler add interval=1w name=backup_email on-event=backup_email policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=2021-07-10 start-time=23:00:00

# Backup binário
/system backup save name=backup_anglo_morumbi_binario password=geolinklanrb2024

# Backup de configuração
/export file=backup_anglo_morumbi_config show-sensitive compact

delay 5s

:local data [/system/clock/get date]
:local hora [/system/clock/get time]

/tool e-mail send to="suporte@geolan.com.br"\
  subject="Backup automático MIKROTIK ANGLO MORUMBI"\
  file=backup_anglo_morumbi_binario.backup,backup_anglo_morumbi_config.rsc\
  body="Em anexo, dois arquivos de backup do mikrotik Anglo Morumbi realizado em $data as $hora."

log warning "Enviando e-mail de backup!!!"