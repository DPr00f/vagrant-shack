#!/usr/bin/env bash

DB=$1;
mysql -uroot -proot -e "DROP DATABASE IF EXISTS $DB";
mysql -uroot -proot -e "CREATE DATABASE $DB";