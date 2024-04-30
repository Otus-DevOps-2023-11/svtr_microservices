#!/bin/bash

/usr/bin/mongod --fork --logpath /var/log/mongodb.log --config /etc/mongodb.conf

source /reddit/db_config

cd /reddit && puma || exit
