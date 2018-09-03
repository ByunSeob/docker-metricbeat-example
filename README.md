# docker-metricbeat-example

Docker and Metricbeat configurations examples.
Learn how to use Docker and Metricbeat to monitor you host system, all your nodes, your docker containers and all your (distributed) services.

**Warning**
> This project is built for example and testing.  
> DO NOT use any part of it in production unless you know exactly what you are doing.

>지속적인 도커로그로 인해 하드가 부족할 수 있으니 도커의 looging 드라이버를 none 으로 설정하시거나
충분한 하드 용량을 확보해 주셔야 합니다.
관련 문서는 github에 존재합니다. 찾기 어려우시면 문의주시면 감사하겠습니다. 


## Software versions

| Name  | Version |
| ------------- | ------------- |
| Docker  | 17.10.0-ce (f4ffd25) (Tue Oct 17 19:05:05 2017)  |
| Docker-compose  | 1.17.0, build ac53b73 |
| Elasticsearch  | 6.0.0 |
| Metricbeat  | 6.0.0 |
| Kibana  | 6.0.0 |
| Apache | 2.4.29-alpine |
| MongoDB | 3.5.13-jessie |
| MySQL | 8.0 |
| Nginx | 1.13.7-alpine |
| RabbitMQ | 3.6.14-management-alpine |
| Redis | 3.2.11-alpine |


## Install

Clone the repository

```bash
git clone https://github.com/ByunSeob/docker-metricbeat-example.git && cd docker-metricbeat-example
```

Setup your host (**sudo/root needed**).
You shoud have something like this.

```bash
$ make setup
=> ACLs on /var/run/docker.sock OK
vm.max_map_count = 262144
=> vm.max_map_count=262144 OK
2105e36d174f6ad3d0d23cac5769454d60a51fa8998fc0fbe946c4e713f1493c
Building metricbeat-host
Step 1/6 : FROM docker.elastic.co/beats/metricbeat:6.0.0
 ---> bc8ff400feac
Step 2/6 : ARG METRICBEAT_FILE=metricbeat.yml
 ---> Using cache
 ---> ebd68e798d93
Step 3/6 : COPY ${METRICBEAT_FILE} /usr/share/metricbeat/metricbeat.yml
 ---> Using cache
 ---> e24c78b4b7e8
Step 4/6 : USER root
 ---> Using cache
 ---> 84b29d7e9635
Step 5/6 : RUN mkdir /var/log/metricbeat     && chown metricbeat /usr/share/metricbeat/metricbeat.yml     && chmod go-w /usr/share/metricbeat/metricbeat.yml     && chown metricbeat /var/log/metricbeat
 ---> Using cache
 ---> 0d1485e2e4c1
Step 6/6 : USER metricbeat
 ---> Using cache
 ---> 7c5172b2912c
Successfully built 7c5172b2912c
Successfully tagged dockermetricbeatexample_metricbeat-host:latest
elasticsearch uses an image, skipping
Building metricbeat
Step 1/6 : FROM docker.elastic.co/beats/metricbeat:6.0.0
 ---> bc8ff400feac
Step 2/6 : ARG METRICBEAT_FILE=metricbeat.yml
 ---> Using cache
 ---> ebd68e798d93
Step 3/6 : COPY ${METRICBEAT_FILE} /usr/share/metricbeat/metricbeat.yml
 ---> Using cache
 ---> 19c48873ed8e
Step 4/6 : USER root
 ---> Using cache
 ---> fa6d8c6138d6
Step 5/6 : RUN mkdir /var/log/metricbeat     && chown metricbeat /usr/share/metricbeat/metricbeat.yml     && chmod go-w /usr/share/metricbeat/metricbeat.yml     && chown metricbeat /var/log/metricbeat
 ---> Using cache
 ---> b691cc7eb5bf
Step 6/6 : USER metricbeat
 ---> Using cache
 ---> 5e02571e6fb2
Successfully built 5e02571e6fb2
Successfully tagged dockermetricbeatexample_metricbeat:latest
kibana uses an image, skipping
```

## Host Monitoring

docker-compose.yml 
REMOTE_IP -> aws ELK monitoring & kafka on IP change

```yaml
metricbeat-host:
  ...
  environment:
    - HOST_ELASTICSEARCH=elasticsearch:9222
    - HOST_KIBANA=kibana:5666
  extra_hosts:
    - "elasticsearch:REMOTE_IP" # The IP of docker0 interface to access host from container
    - "kibana:REMOTE_IP" # The IP of docker0 interface to access host from container
  network_mode: host # Mandatory to monitor host filesystem, memory, processes,...
```

Start monitoring your host.

```bash
$ make start-monitoring-host 
Creating metricbeat-elasticsearch ... 
Creating metricbeat-elasticsearch ... done
metricbeat-elasticsearch is up-to-date
Creating metricbeat-kibana ... 
Creating metricbeat-kibana ... done
Waiting for elasticsearch...
Creating metricbeat-metricbeat-host ... 
Creating metricbeat-metricbeat-host ... done
```

```bash
$ docker ps                 
CONTAINER ID        IMAGE                                                 COMMAND                  CREATED             STATUS              PORTS                              NAMES
e25a76b4f1e4        dockermetricbeatexample_metricbeat-host               "/usr/local/bin/do..."   2 minutes ago       Up 2 seconds                                           metricbeat-metricbeat-host
```

If everything is fine, you should be able to access Kibana, and Monitoring dashboard:

* Kibana => [http://REMOTE_IP:5666](http://127.0.0.1:5666/app/kibana)
* Dashboard list => [http://REMOTE_IP:5666/app/kibana#/dashboards?_g=()](http://127.0.0.1:5666/app/kibana#/dashboards?_g=())
* System Overview => [http://REMOTE_IP:5666/app/kibana#/dashboard/Metricbeat-system-overview?_g=()](http://127.0.0.1:5666/app/kibana#/dashboard/Metricbeat-system-overview?_g=())

**Host Dashboard**

![Host dashboard](./img/host.png)

**Docker Dashboard**

![Docker dashboard](./img/docker.png)

### Start/Stop all services

```bash
make start-all
make stop-all
```
#### Others

More to come

## Clean everything

A simple command to remove all containers related to Metricbeat

```bash
$ make clean
d934ee72db19
3ae8e0c7c1e3
a379163bc90d
6c072660a008
52be9d662f8f
da1a01c36c4c
4f4cb6e72a39
a400ee0b914a
43d22a57fde4
c1ca7e0d7e6a
All METRICBEAT containers removed !
```

## LICENSE

MIT License

Copyright (c) 2017 Yannick Pereira-Reis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
