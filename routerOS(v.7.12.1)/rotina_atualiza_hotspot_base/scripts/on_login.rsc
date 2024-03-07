################################### VARIÁVEIS LOCAIS: ###################################
# $user - O nome de usuário do cliente conectado.
# $password - A senha do cliente conectado.
# $address - O endereço IP do cliente.
# $"mac-address" - O endereço MAC do dispositivo do cliente.
# $interface - A interface pela qual o cliente está conectado.
# $server - O nome do servidor hotspot ao qual o cliente está conectado.
# $profile - O perfil de usuário atribuído ao cliente.

################################## VARIAVEIS DE CONFIG ##################################

# Pega data e hora atuais
:local date [/system/clock/get date]
:local time [/system/clock/get time]
:local timestamp [:timestamp]
:local newComment ""

############################## ADD LAST SEEN CASO NÃO TENHA ##############################
/ip/hotspot/user

:local comment [get $user comment]
:local hasLS ([:find $comment "Last seen" -1])

# Caso a var $hasLS seja igual a 0 quer dizer que já tem LastSeen então soma com 1 para ser true na verificação booleana
:if (($hasLS = 0)) do={
  :set hasLS ($hasLS + 1)
}

# Define que o usuário trial tem LastSeen para que seja ignorado
:if ($user = "default-trial") do={
  :set hasLS 1
}

# Caso não tenha LastSeen cai nessa condição que nega o valor de hasLS para ignorar todos que já tem LS
:if ([(![:tobool ($hasLS)])]) do={
  # Caso não tenha nenhum comentário então apenas adiciona as informações de Last seen
  :if ($comment = "") do={
    :set newComment "Last seen: $date $time ($timestamp)"
  } else={
    # Caso tenha comentário, concatena com as informações de Last seen
    :set newComment "$comment | Last seen: $date $time ($timestamp)"
  }

  # Após a verificação e criação adequada do novo comentário ele é inserido no usuário
  # Está envolto de uma função para capturar erros e exibir um log
  :do { set $user comment=$newComment } on-error={ /log/error "erro ao modificar user $name" }
} else={
  /log/warning "$user JÁ TEM LAST SEEN"
  :local cutComment [:pick $comment 0 ($hasLS - 1)]

  :if ([([:tobool ($cutComment)])]) do={
    :set newComment "Last seen: $date $time ($timestamp)"
  /log/warning "Last seen: $date $time ($timestamp)"
  } else={
    :set newComment "$cutComment Last seen: $date $time ($timestamp)"
  /log/warning "$cutComment Last seen: $date $time ($timestamp)"
  }

  # Após a verificação e criação adequada do novo comentário ele é inserido no usuário
  # Está envolto de uma função para capturar erros e exibir um log
  :do { set $user comment=$newComment } on-error={ /log/error "erro ao modificar user $name" }
}