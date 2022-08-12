#!/bin/bash

ansible --list-hosts -i host.yaml all | grep -v host | awk '{print $1}' > list

export CERT_DIR=${PWD}/ssl
export CA_KEY_PASSWORD=confluent
export KEY_PASSWORD=confluent
export CA_CN="Justin Internal CA"

mkdir -p ${CERT_DIR}

openssl req \
  -x509 \
  -sha256 \
  -newkey \
  rsa:4096 \
  -keyout ${CERT_DIR}/ca.key \
  -out ${CERT_DIR}/ca.crt \
  -days 356 \
  -passout pass:${CA_KEY_PASSWORD} \
  -subj "/CN=${CA_CN}"

for f in $(cat list);
do
export CN=${f}
export FILENAME=${f}

export PUBLIC_IP=$(ssh ${f} curl -s ifconfig.co)
export PUBLIC_DNS=$(ssh ${f} curl -s 169.254.169.254/latest/meta-data/public-hostname)

openssl req \
  -new \
  -newkey \
  rsa:4096 \
  -keyout ${CERT_DIR}/${FILENAME}.key \
  -out ${CERT_DIR}/${FILENAME}.csr \
  -passout pass:${KEY_PASSWORD} \
  -subj "/CN=${CN}"

tee ${CERT_DIR}/${FILENAME}.ext <<EOF
subjectAltName = @alt_names
[alt_names]
DNS.1=${f}
DNS.2=${PUBLIC_DNS}
DNS.3=localhost
IP.1=${PUBLIC_IP}
# IP.2=${PRIVATE_IP}
IP.3=127.0.0.1
EOF

openssl x509 \
  -req \
  -sha256 \
  -days 365 \
  -in ${CERT_DIR}/${FILENAME}.csr \
  -CA ${CERT_DIR}/ca.crt \
  -CAkey ${CERT_DIR}/ca.key \
  -extfile ${CERT_DIR}/${FILENAME}.ext \
  -passin pass:${CA_KEY_PASSWORD} \
  -CAcreateserial \
  -out ${CERT_DIR}/${FILENAME}.crt

openssl pkcs12 -export \
    -in ${CERT_DIR}/${FILENAME}.crt \
    -inkey ${CERT_DIR}/${FILENAME}.key \
    -out ${CERT_DIR}/${FILENAME}.keystore.jks \
    -name ${FILENAME} \
    -CAfile ${CERT_DIR}/ca.crt \
    -caname CARoot \
    -passin pass:${KEY_PASSWORD} \
    -password pass:${KEY_PASSWORD}

keytool -importcert \
    -keystore ${CERT_DIR}/${FILENAME}.keystore.jks \
    -alias CARoot \
    -file ${CERT_DIR}/ca.crt \
    -storepass ${KEY_PASSWORD} \
    -noprompt

keytool -importcert \
    -keystore ${CERT_DIR}/${FILENAME}.truststore.jks \
    -alias CARoot \
    -file ${CERT_DIR}/ca.crt \
    -storepass ${CA_KEY_PASSWORD} \
    -noprompt
done

# MDS Cert
openssl genrsa -out ${CERT_DIR}/mds.key 2048
openssl rsa -in ${CERT_DIR}/mds.key -outform PEM -pubout -out ${CERT_DIR}/mds.pem