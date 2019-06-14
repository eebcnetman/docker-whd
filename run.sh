#!/bin/bash
echo -------------------------------------------
supervisord --nodaemon -c /opt/supervisord.conf
echo Started Supervisor 
echo -------------------------------------------