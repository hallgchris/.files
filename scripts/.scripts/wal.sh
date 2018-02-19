#! /bin/bash

wal -i $1 -a 90
wal_steam -w
~/.scripts/intellijPywal/intellijPywalGen.sh $HOME/.PyCharm2017.3/config

