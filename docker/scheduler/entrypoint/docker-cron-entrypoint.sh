#!/bin/bash

chmod 644 /etc/cron.d/laravel
chown root.root /etc/cron.d/laravel

/usr/bin/supervisord -n
