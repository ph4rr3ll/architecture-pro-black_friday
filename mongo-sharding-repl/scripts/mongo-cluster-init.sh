#!/bin/bash

###
# Инициализируем клстер БД
###

docker compose exec -T config-srv mongosh --port 27017 <<EOF
rs.initiate({_id : "config_server", configsvr: true, members: [{ _id : 0, host : "config-srv:27017"}]});
EOF

docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate({_id : "shard1", members: [{ _id : 0, host : "shard1:27018" }, { _id : 1, host : "shard1-repl1:27101" }, { _id : 2, host : "shard1-repl2:27102" }, { _id : 3, host : "shard1-repl3:27103" }]});
EOF

docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.initiate({_id : "shard2", members: [{ _id : 0, host : "shard2:27019" }, { _id : 1, host : "shard2-repl1:27201" }, { _id : 2, host : "shard2-repl2:27202" }, { _id : 3, host : "shard2-repl3:27203" }]});
EOF

docker compose exec -T mongos-router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF