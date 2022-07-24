SHELL := /bin/bash
.PHONY: help


help:
	@echo ""
	@echo "Targets:"
	@echo "- make help                         Print this menu"
	@echo "- make cloud-aws-instance-describe  Ask AWS to describe this instance"
	@echo "- make cloud-aws-instance-run       Concatenate logs and display them"
	@echo "- make cloud-aws-logs-show          Run the instance on AWS"
	@echo "- make cloud-aws-parse-specs        Parse specifications with configs for running and EC2 instance"
	@echo "- make container-db-logs            Get database container logs"
	@echo "- make container-db-shell           Open BASh shell in database container"
	@echo "- make container-wp-logs            Get Wordpress container logs"
	@echo "- make container-wp-shell           Open BASh shell in Wordpress container"
	@echo "- make containers-down              Destroy containers"
	@echo "- make containers-stop              Stop containers"
	@echo "- make containers-up                Start containers and pull if necessary"
	@echo ""


cloud-aws-instance-describe:
	@./Make.sh _cloud_aws_instance_describe

cloud-aws-instance-run:
	@./Make.sh _cloud_aws_instance_run

cloud-aws-logs-show:
	@./Make.sh _cloud_aws_logs_show

cloud-aws-parse-specs:
	@./Make.sh _cloud_aws_parse_specs

container-db-logs:
	@./Make.sh _container_db_logs

container-db-shell:
	@./Make.sh _container_db_shell

container-wp-logs:
	@./Make.sh _container_wp_logs

container-wp-shell:
	@./Make.sh _container_wp_shell

containers-down:
	@./Make.sh _containers_down

containers-stop:
	@./Make.sh _containers_stop

containers-up:
	@./Make.sh _containers_up

