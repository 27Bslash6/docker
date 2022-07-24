IMAGE := funkygibbon/automysqlbackup

EMAIL_TO ?= test@example.com

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -ti \
		-e "DATABASES=fish" \
		-e "CRON_SCHEDULE=*/5 * * * *" \
		-e "EMAIL_TO=$(EMAIL_TO)" \
		--name automysqlbackup \
		$(IMAGE)

exec:
	docker exec automysqlbackup automysqlbackup
