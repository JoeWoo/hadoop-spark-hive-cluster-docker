#!/bin/bash
#first run hive should run schematool
schematool -dbType mysql -initSchema

nohup $HIVE_INSTALL/bin/hive --service metastore -p 10000 &
nohup $HIVE_INSTALL/bin/hive --service hiveserver2 &
nohup $HIVE_INSTALL/bin/hive --service hwi &
