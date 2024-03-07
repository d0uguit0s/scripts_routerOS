/ip/hotspot/user

# Pega data e hora atuais
:local date [/system/clock/get date]
:local time [/system/clock/get time]
:local timestamp [:timestamp]
:local newComment ""

# Percorre todos os usuários do hotspot
:foreach user in=[find] do={
  :local name [get $user name]
  :local comment [get $user comment]
  :local hasLS ([:find $comment "Last seen" -1])

  # Caso a var $hasLS seja igual a 0 quer dizer que já tem LastSeen então soma com 1 para ser true na verificação booleana
  :if (($hasLS = 0)) do={
    :set hasLS ($hasLS + 1)
  }

  # Define que o usuário trial tem LastSeen para que seja ignorado
  :if ($name = "default-trial") do={
    :set hasLS 1
  }

  # Caso não tenha LastSeen cai nessa condição que nega o valor de hasLS para ignorar todos que já tem LS
  :if ([(![:tobool ($hasLS)])]) do={
    # Caso não tenha nenhum comentário então apenas adiciona as informações de Last seen
    :if ($comment = "") do={
      :set newComment "Last seen: $date $time ($timestamp)"
    } else {
      # Caso tenha comentário, concatena com as informações de Last seen
      :set newComment "$comment | Last seen: $date $time ($timestamp)"
    }

    # Após a verificação e criação adequada do novo comentário ele é inserido no usuário
    # Está envolto de uma função para capturar erros e exibir um log
    :do { set $user comment=$newComment } on-error={ /log/error "erro ao modificar user $name" }
  }
}
