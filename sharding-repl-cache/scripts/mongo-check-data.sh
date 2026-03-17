#!/bin/bash

###
# Проверка наполнения
###

docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard1-repl1 mongosh --port 27101 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard2-repl2 mongosh --port 27202 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF