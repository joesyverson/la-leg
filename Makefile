SHELL := /bin/bash
.PHONY: help


HASH=$(shell ./Make.sh _git_branch_current | cut -d ' ' -f 2)
PERM_MODEL='custom'
RSRC_TYPE='all'
REGION=''


help:
	@echo ""
	@echo "Parameters:"
	@echo "- PERM_MODEL=[env|custom]                                    Custom is a private method preferred by the architect. Use 'env' for AWS to gather variables from your environment or config."
	@echo "- RSRC_TYPE=[AWS::Service::Feature|all]                      Run resource-types-list for a full list of values."
	@echo "- REGION=[aws-region|all]                                    Run regions-list for a full list of values."
	@echo ""
	@echo "Targets:"
	@echo "- make help                                                  Print this menu"
	@echo "- make cloud-aws-instance-describe                           Ask AWS to describe this instance"
	@echo "- make cloud-aws-instance-run PERM_MODEL REGION              Concatenate logs and display them"
	@echo "- make cloud-aws-logs-show                                   Run the instance on AWS"
	@echo "- make cloud-aws-parse-specs                                 Parse specifications with configs for running and EC2 instance"
	@echo "- make cloud-aws-regions-list                                List all AWS regions"
	@echo "- make cloud-aws-resource-types-get                          Refresh list of resource types from AWS using CURL"
	@echo "- make cloud-aws-resource-types-list                         List all resource types in AWS"
	@echo "- make cloud-aws-resources-list PERM_MODEL RSRC_TYPE REGION  Describe all the resources in a region"
	@echo "- make container-db-logs                                     Get database container logs"
	@echo "- make container-db-shell                                    Open BASh shell in database container"
	@echo "- make container-wp-logs                                     Get Wordpress container logs"
	@echo "- make container-wp-shell                                    Open BASh shell in Wordpress container"
	@echo "- make containers-down                                       Destroy containers"
	@echo "- make containers-stop                                       Stop containers"
	@echo "- make containers-up                                         Start containers and pull if necessary"
	@echo "- make git-branch-clean                                      Delete branches on local and remote interactively"
	@echo "- make git-branch-current                                    Print the current Git branch name and hash"
	@echo ""


cloud-aws-instance-describe:
	@./Make.sh
	@make --directory=./cloud/ aws-instance-describe

cloud-aws-instance-run:
	@./Make.sh
	@make --directory=./cloud/ aws-instance-run $(PERM_MODEL) $(REGION)

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
	@make --directory=./cloud/ aws-resources-list $(PERM_MODEL) $(RSRC_TYPE) $(REGION)

container-wp-db-logs:
	@./Make.sh
	@make --directory=./containers wp-db-logs

container-wp-db-shell:
	@./Make.sh
	@make --directory=./containers wp-db-shell

container-wp-logs:
	@./Make.sh
	@make --directory=./containers wp-wp-logs

container-wp-shell:
	@./Make.sh
	@make --directory=containers wp-wp-shell

# container-wp-build:
# 	@make --directory=containers wp-build HASH=$(HASH)

container-wp-down:
	@./Make.sh
	@make --directory=containers wp-down

container-wp-stop:
	@./Make.sh
	make --directory=containers wp-stop

container-wp-up:
	@./Make.sh
	make --directory=containers wp-up

git-branch-clean:
	@./Make.sh _git_branch_clean

git-branch-current:
	@./Make.sh _git_branch_current