SHELL := /bin/bash
.PHONY: help

REGION=''
RESOURCETYPE='all'

help:
	@echo ""
	@echo "Targets:"
	@echo "- make help                           Print this menu"
	@echo "- make cloud-aws-instance-describe    Ask AWS to describe this instance"
	@echo "- make cloud-aws-instance-run         Concatenate logs and display them"
	@echo "- make cloud-aws-logs-show            Run the instance on AWS"
	@echo "- make cloud-aws-parse-specs          Parse specifications with configs for running and EC2 instance"
	@echo "- make cloud-aws-regions-list         List all AWS regions"
	@echo "- cloud-aws-resource-types-get        Refresh list from AWS using CURL"
	@echo "- make cloud-aws-resource-types-list  List all resource types in AWS"
	@echo "- make cloud-aws-resources-list       Describe all the resources in a region"
	@echo "- make container-db-logs              Get database container logs"
	@echo "- make container-db-shell             Open BASh shell in database container"
	@echo "- make container-wp-logs              Get Wordpress container logs"
	@echo "- make container-wp-shell             Open BASh shell in Wordpress container"
	@echo "- make containers-down                Destroy containers"
	@echo "- make containers-stop                Stop containers"
	@echo "- make containers-up                  Start containers and pull if necessary"
	@echo ""



cloud-aws-instance-describe:
	@./Make.sh
	@make --directory=./cloud/ aws-instance-describe

cloud-aws-instance-run:
	@./Make.sh
	@make --directory=./cloud/ aws-instance-run

cloud-aws-logs-show:
	@./Make.sh
	@make --directory=./cloud/ aws-logs-show

cloud-aws-parse-specs:
	@./Make.sh
	@make --directory=./cloud/ aws-parse-specs

cloud-aws-regions-list:
	@./Make.sh
	@make --directory=./cloud/ aws-regions-list

cloud-aws-resource-types-get:
	@./Make.sh
	@make --directory=./cloud/ aws-resource-types-get

cloud-aws-resource-types-list:
	@./Make.sh
	@make --directory=./cloud/ aws-resource-types-list

cloud-aws-resources-list:
	@./Make.sh
	@make --directory=./cloud/ aws-resources-list $(REGION) $(RESOURCETYPE)

container-db-logs:
	@./Make.sh
	@make --directory=container container-db-logs

container-db-shell:
	@./Make.sh
	@make --directory=container container-db-shell

container-wp-logs:
	@./Make.sh
	@make --directory=container container-wp-logs

container-wp-shell:
	@./Make.sh
	@make --directory=container container-wp-shell

containers-down:
	@./Make.sh
	@make --directory=container containers-down

containers-stop:
	make --directory=container containers-stop

containers-up:
	make --directory=container containers-up

