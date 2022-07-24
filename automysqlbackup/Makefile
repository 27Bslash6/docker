IMAGE := funkygibbon/automysqlbackup

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -ti \
		-e "DATABASES=fish" \
		-e "CRON_SCHEDULE=15,25 * * * *" \
		-e "EMAIL_TO=test@example.com" \
		--name automysqlbackup \
		$(IMAGE)

exec:
	docker exec automysqlbackup automysqlbackup
