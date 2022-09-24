SHELL := /bin/bash
.PHONY: help

PERM_MODEL='custom'
REGION=''

aws-instance-describe:
	@./Make.sh _aws_instance_describe
aws-instance-run:
	@./Make.sh _aws_instance_run $(PERM_MODEL) $(REGION)
aws-logs-show:
	@./Make.sh _aws_logs_show
aws-parse-specs:
	@./Make.sh _aws_parse_specs
aws-regions-list:
	@./Make.sh _aws_regions_list
aws-resource-types-get:
	@./Make.sh _aws_resource_types_get
aws-resource-types-list:
	@./Make.sh _aws_resource_types_list
aws-resources-list:
	@./Make.sh _aws_resources_list $(REGION) $(RESOURCETYPE)