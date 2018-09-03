

# ----------------------- SETUP -------------------------------------------------------------------
# Useful to configure a few things on the host machien to allow elasticsearch and metricbeat to work.
setup:
	@./scripts/setup.sh

# ------------------- METRICBEAT -------------------------------------------------------------------
stop-metricbeat:
	@echo "== Stopping METRICBEAT=="
	@/usr/local/bin/docker-compose stop metricbeat

start-monitoring:
	@/usr/local/bin/docker-compose up -d metricbeat
	@echo "================= Monitoring STARTED !!!"

stop-monitoring: stop-metricbeat
	@/usr/local/bin/docker-compose stop
	@echo "================= Monitoring STOPPED !!!"

stop-monitoring-host:
	@/usr/local/bin/docker-compose stop metricbeat-host
	@/usr/local/bin/docker-compose rm -f metricbeat-host || true

start-monitoring-host:
	@/usr/local/bin/docker-compose up -d metricbeat-host

build:
	@/usr/local/bin/docker-compose build


start-all: start-apache start-nginx start-redis start-rabbitmq start-mongodb start-mysql

stop-all: stop-apache stop-nginx stop-redis stop-rabbitmq stop-mongodb stop-mysql

clean:
	@./scripts/clean.sh


install: clean setup start-monitoring-host start-monitoring start-all