# Cluster Conatus

Just trying some things out here


# Other CouchDB Setup requirements
- Make the instal script better
- Per-node configuration is required
```
-name couchdb@127.0.0.1
-to-
-name hostname@hostname.local
```

Log settings get added to local.ini - they look like this

```
[log]
file = /var/log/couchdb/couch.log
writer = file
```

admin name and hash must be the same across nodes

## List hosts's members
```sh
curl -X GET "http://$(hostname).local:5984/_membership" --user admin
```


## Add node to host's cluster
```sh
# <other hostname>@<other hostname>.local
curl -X PUT "http://$(hostname).local:5984/_node/_local/_nodes/oh@oh.local" -d {} --user admin
```


## Remove node
```sh
curl "http://xxx.xxx.xxx.xxx/_node/_local/_nodes/node2@yyy.yyy.yyy.yyy"
(Get _rev)
curl -X DELETE "http://xxx.xxx.xxx.xxx/_node/_local/_nodes/node2@yyy.yyy.yyy.yyy?rev=1-967a00dff5e02add41820138abb3284d"
```
