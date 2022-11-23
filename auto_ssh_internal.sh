#!/bin/bash
#Author: Damian Golał

#checking if the service exists
service ssh-internal status --no-legend --no-pager
if [ $? = 4 ]; then
#installation of the service if it does not exist
    {
    apt install wget curl -y
    cd /tmp
    wget --user xxx --password xxx https://xxx-yyy/ssh-internal-debian-9.tar.gz
    tar xzvfh ssh-internal-debian-9.tar.gz -C /
    systemctl enable ssh-internal
    systemctl restart ssh
    systemctl restart ssh-internal
    groupadd -r access
    echo "127.0.0.1       me" >> /etc/hosts
    }
#checking if the service is working
        if [ $? != 0 ]
        then
            echo "Błąd usługi ssh-internal!" >> /var/log/auto_ssh_internal
            exit 1
        fi
fi

while :
do
#table display
  clear
  cat<<EOF
    *******************************
    *         SSH-INTERNAL        *
    *******************************
    * Dostępne klucze:            *
    *                             *
    * Damian G      (ds4421)      *
    * Michał G      (ds1704)      *
    * Sebastian P   (ds4848)      *
    * Dariusz B     (ds8732)      *
    * Daniel K      (ds4260)      *
    * Michał Ł      (ds6666)      *
    * Joachim K     (ds7942)      *
    * Bartosz S     (ds6753)      *
    * Jakub G       (ds2609)      *
    * Michał L      (ds3123)      *
    * Jakub B       (ds9772)      *
    * Damian C      (ds7265)      *
    * Marcin M      (ds2612)      *
    *                             *
    *      Press (q) to quit      *
    *******************************
EOF
#collecting a $REPLY variable from the user
      echo -n "Podaj ID: "
      read REPLY
      case "$REPLY" in
      "q")  exit     ;;
      *)  echo -e '\nDodawanie...'
function ADD_USER {
#checking if the key exists in GitHub
  curl -I https://raw.githubusercontent.com/DSDG4421/testing/main/"$REPLY".pub |grep 'HTTP/2 200'
        if [ $? != 0 ]
        then
#LOG
            echo "Brak klucza publicznego, dla użytkownika ${REPLY}!" >> /var/log/auto_ssh_internal
            exit 2
        else
#adding a selected user
            curl -o /etc/ssh-pool/"$REPLY".pub https://raw.githubusercontent.com/DSDG4421/testing/main/"$REPLY".pub
            useradd -m -s /bin/bash $REPLY
            gpasswd -a $REPLY access
            pubkey=$(cat /etc/ssh-pool/"$REPLY".pub)
            echo 'from="127.0.0.1"' "${pubkey}" >> /root/.ssh/authorized_keys
#LOG
            echo "Pomyślnie dodano użytkownika ${REPLY}!" >> /var/log/auto_ssh_internal
        fi
}
ADD_USER
      esac
      sleep 1
  done
