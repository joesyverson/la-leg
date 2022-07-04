SHELL := /bin/bash
.PHONY: help

help:
	@echo ""
	@echo "Targets:"
	@echo "- make help            Print this menu"
	@echo "- make aws-instance-describe        Ask AWS to describe this instance"
	@echo "- make aws-instance-run       Concatenate logs and display them"
	@echo "- make aws-logs-show    Run the instance on AWS"
	@echo "- make aws-parse-specs     Parse specifications with configs for running and EC2 instance"
	@echo ""


cloud-aws-instance-describe:
	@./Make.sh _cloud_aws_instance_describe

cloud-aws-instance-run:
	@./Make.sh _cloud_aws_instance_run

cloud-aws-logs-show:
	@./Make.sh _cloud_aws_logs_show

cloud-aws-parse-specs:
	@./Make.sh _cloud_aws_parse_specs
