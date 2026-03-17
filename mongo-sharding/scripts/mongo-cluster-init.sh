#!/bin/bash

###
# Инициализируем клстер БД
###

docker compose exec -T config-srv mongosh --port 27017 <<EOF
rs.initiate({_id : "config_server", configsvr: true, members: [{ _id : 0, host : "config-srv:27017"}]});
EOF

docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate({_id : "shard1", members: [{ _id : 0, host : "shard1:27018" }]});
EOF

docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.initiate({_id : "shard2", members: [{ _id : 0, host : "shard2:27019" }]});
EOF

docker compose exec -T mongos-router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF