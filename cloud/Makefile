SHELL := /bin/bash
.PHONY: help

aws-instance-describe:
	@./Make.sh _cloud_aws_instance_describe
aws-instance-run:
	@./Make.sh _cloud_aws_instance_run
aws-logs-show:
	@./Make.sh _cloud_aws_logs_show
aws-parse-specs:
	@./Make.sh _cloud_aws_parse_specs
aws-regions-list:
	@./Make.sh _cloud_aws_regions_list
aws-resource-types-get:
	@./Make.sh _cloud_aws_resource_types_get
aws-resource-types-list:
	@./Make.sh _cloud_aws_resource_types_list
aws-resources-list:
	@./Make.sh _cloud_aws_resources_list $(REGION) $(RESOURCETYPE)