#!/bin/bash
mysql -h$SH_HOST -u$SH_USER -p$SH_PASS $SH_DB < structure.sql
