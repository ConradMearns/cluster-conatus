# Run as root

mkdir -p /etc/couchdb/cert/
cd /etc/couchdb/cert/
openssl genrsa > privkey.pem
openssl req -new -x509 -key privkey.pem -out couchdb.pem -days 1095
chmod 600 privkey.pem couchdb.pem
chown couchdb privkey.pem couchdb.pem

#[ssl]
#enable = true
#cert_file = /etc/couchdb/cert/couchdb.pem
#key_file = /etc/couchdb/cert/privkey.pem
