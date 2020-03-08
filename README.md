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

CORS needs to be installed for PouchDB to work. Ensure nodejs and npm are installed first
```sh
sudo apt install nodejs npm
npm i -g add-cors-to-couchdb
sudo -u couchdb add-cors-to-couchdb
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


# Serf Requirements

When Serf is fixed (or to try and fix it) use
```sh
sudo apt install go gox
go get -u github.com/hashicorp/serf
cd go/src/github.com/hashicorp/serf/
make bin
cd go/src/github.com/hashicorp/serf/pkg/linux_arm/serf /usr/local/bin/serf
```

--Download (https://www.serf.io/downloads.html)--

At the time of writing, serf is up-to-date and broken for the mdns discovery feature

Install to /usr/local/bin/serf

Add service file to /lib/systemd/system/
```sh
sudo cp serf.service /lib/systemd/system/
sudo chmod 644 /lib/systemd/system/serf.service
sudo systemctl daemon-reload

sudo systemctl enable serf.service
sudo systemctl start serf.service
```

Congigure serf to use a specific IP for the cluter
