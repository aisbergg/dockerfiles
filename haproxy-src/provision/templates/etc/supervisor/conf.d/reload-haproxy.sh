#!/bin/bash

if [[ -n "`supervisorctl status haproxy1 | grep EXITED`" ]]; then
    supervisorctl start haproxy1
else
    supervisorctl start haproxy2
fi
