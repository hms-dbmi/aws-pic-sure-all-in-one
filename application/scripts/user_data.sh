mkdir /etc/sft
mkdir /var/lib/sftd
echo "CanonicalName: ${environment_name}" > /etc/sft/sftd.yaml

curl -C - https://pkg.scaleft.com/scaleft_yum.repo | sudo tee /etc/yum.repos.d/scaleft.repo
rpm --import https://dist.scaleft.com/pki/scaleft_rpm_key.asc
yum -y install scaleft-server-tools

yum -y install git
mkdir -p /usr/local/docker-config
cd /usr/local/docker-config
git clone https://github.com/pic-sure-all-in-one
cd pic-sure-all-in-one/initial-configuration
./install-dependencies.sh

