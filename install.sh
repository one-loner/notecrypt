#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to install." 1>&2
   exit
fi
echo "Installing requirements."
apt-get install -y --no-install-recommends secure-delete nano gpg
echo "Installing notecrypt."
cp notecrypt.sh /usr/bin/notecrypt
echo Done.
