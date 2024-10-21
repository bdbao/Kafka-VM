# Kafka Setup on Virtual Machine using Multipass
---
# Demo 1: With `kafka-python` library
## Quick start
```bash
brew install --cask multipass
VM_NAME="kafka-vm"
multipass launch --name "$VM_NAME" --disk 6G --mem 2.5G
multipass shell "$VM_NAME"
```
Now, switch to **Ubuntu shell**:
```bash
sudo adduser kafka # e.g: password is 1234
sudo adduser kafka sudo
su -l kafka

sudo apt update
sudo apt install openjdk-11-jre-headless -y

cd ~ && git clone https://github.com/bdbao/Kafka-VM
curl "https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz" -o kafka.tgz
mkdir kafka && cd kafka
tar -xvzf ~/kafka.tgz --strip 1
cp ~/Kafka-VM/config/server.properties ./config
cp -r ~/Kafka-VM/scripts .
sudo cp ~/Kafka-VM/system/* /etc/systemd/system

# get python 3.8
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
python3.8 --version

# Create Virtual Environment
sudo apt install python3.8-venv
python3.8 -m venv myenv && source myenv/bin/activate
# pip install --upgrade pip
pip install kafka-python
# rm -rf ~/kafka/myenv

sudo systemctl enable zookeeper
sudo systemctl start zookeeper
sudo systemctl status zookeeper
sudo systemctl enable kafka
sudo systemctl start kafka
sudo systemctl status kafka
```
Open 2 terminals for these 2 commnands:
```bash
python3.8 scripts/consumer.py
python3.8 scripts/producer.py
```

## Build from scratch
```bash
multipass launch --name kafka-vm --disk 6G --mem 2.5G
multipass shell kafka-vm
```
Move to Ubuntu shell
```bash
sudo adduser kafka
sudo adduser kafka sudo
su -l kafka
    1234

sudo apt update
sudo apt install openjdk-11-jre-headless -y
java --version

mkdir ~/Downloads
curl "https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz" -o ~/Downloads/kafka.tgz
mkdir ~/kafka && cd ~/kafka
tar -xvzf ~/Downloads/kafka.tgz --strip 1
readlink -f $(which java)
```
Modify the file `nano ~/kafka/config/server.properties`:
```
listeners=PLAINTEXT://localhost:9092 # uncomment
advertised.listeners=PLAINTEXT://localhost:9092 # uncomment, ip addr show
log.dirs=/home/kafka/logs # change dir
delete.topic.enable = true # add at EOF
```
Add to file `sudo nano /etc/systemd/system/kafka.service`:
```
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64"
ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /home/kafka/kafka/kafka.log 2>&1'
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
Add to file `sudo nano /etc/systemd/system/zookeeper.service`:
```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
```bash
sudo systemctl enable zookeeper
sudo systemctl start zookeeper
sudo systemctl status zookeeper
sudo systemctl enable kafka
sudo systemctl start kafka
sudo systemctl status kafka

# get python 3.8:
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
python3.8 --version

# Create Virtual Environment
sudo apt install python3.8-venv
python3.8 -m venv kafkaenv && source kafkaenv/bin/activate && pip install --upgrade pip && pip install kafka-python && deactivate
# rm -rf ~/kafka/kafkaenv # delete venv
```
Open 2 terminals for these 2 commnands:
```bash
python3.8 consumer.py
python3.8 producer.py
```

## [Optional] Another demo ([DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-apache-kafka-on-ubuntu-20-04)):
Something more:
```bash
# install java, mem >= 2GB
sudo apt update
sudo apt install openjdk-11-jre-headless -y
java --version

# For kafka 3.x
curl "https://downloads.apache.org/kafka/3.8.0/kafka_2.12-3.8.0.tgz" -o ~/Downloads/kafka.tgz

~/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic TutorialTopic
~/kafka/bin/kafka-topics.sh --delete --bootstrap-server localhost:9092 --topic TutorialTopic # delete topic
```
