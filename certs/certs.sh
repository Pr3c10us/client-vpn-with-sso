#####################################################
## OUKO BRIAN
## Generate server and client certs and copy to the 
## certs directory
#####################################################
git clone https://github.com/OpenVPN/easy-rsa.git
cp vars easy-rsa/easyrsa3
cd easy-rsa/easyrsa3
./easyrsa init-pki
echo "devops" | ./easyrsa build-ca nopass
mv vars pki
echo "yes" | ./easyrsa build-server-full server nopass
echo "yes" | ./easyrsa build-client-full client nopass
mv  pki/ca.crt ../../ && mv pki/private/* ../../ && mv pki/issued/* ../../

