# Variaveis de config

# separado por underline (_) e minusuculo. EX: nome_exemplo
:local nameFiles "nome_cliente"

# Separado, com primeira letra maiuscula. EX: Nome Exemplo
:local nameClientCapitalize "Nome Cliente"

# Separado, tudo maiusculo. EX: NOME EXEMPLO
:local nameClientBold "NOME CLIENTE"

:local startDate "2024-03-09"
:local startTime "03:00:00"

# Config de email
/tool/e-mail/set\
  from="Backup Geolan <monitoramento@geolan.com.br>"\
  password=profallan.com@@2021\
  port=465\
  server=mail.geolan.com.br\
  tls=yes\
  user=monitoramento@geolan.net.br

# Agenda tarefa
/system/scheduler/add\
  interval=1w name=backup_email on-event="# Variaveis de config\r\
  \n:local data [/system/clock/get date]\r\
  \n:local hora [/system/clock/get time]\r\
  \n\r\
  \n# Backup bin\E1rio\r\
  \n/system/backup/save name=\"backup_$nameFiles_binario\" password=geolink\
  lanrb2024\r\
  \n\r\
  \n# Backup de configura\E7\E3o\r\
  \n/export file=\"backup_$nameFiles_config\" show-sensitive compact\r\
  \n\r\
  \ndelay 15s\r\
  \n\r\
  \n/tool/e-mail/send to=\"suporte@geolan.com.br\"\\\r\
  \n  subject=\"Backup autom\E1tico MIKROTIK $nameClientBold\"\\\r\
  \n  file=backup_$nameFiles_binario.backup,backup_$nameFiles_config.rsc\\\r\
  \n  body=\"Em anexo, dois arquivos de backup do mikrotik $nameClientCapitalize \
  realizado em \$data as \$hora.\\\r\
  \n  \\n\\rUTLIZE O BACKUP BIN\C1RIO APENAS PARA RESTAURAR O MESMO DISPOSIT\
  IVO EM QUE ELE FOR GERADO!\\\r\
  \n  \\n\\rEM OUTROS CASOS UTILIZE O BACKUP DE CONFIGURA\C7\C3O!\"\r\
  \n\r\
  \n/log/warning \"Enviando e-mail de backup!!!\"\r\
  \n\r\
  \n/delay 15s\r\
  \n\r\
  \n/file/remove backup_$nameFiles_binario.backup,backup_$nameFiles_config.rsc\r\n"\
  policy=ftp,read,write,policy,test,sensitive\
  start-date=$startDate start-time=$startTime
