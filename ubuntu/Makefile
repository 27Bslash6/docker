IMAGE := funkygibbon/ubuntu

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

run:
	docker run --rm -ti \
		-e "DATABASES=fish" \
		-e "CRON_SCHEDULE=15,25 * * * *" \
		--name automysqlbackup \
		$(IMAGE)

exec:
	docker exec automysqlbackup automysqlbackup
