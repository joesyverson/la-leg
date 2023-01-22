SHELL := /bin/bash
.PHONY: help


HASH=$(shell ./Make.sh _git_branch_current | cut -d ' ' -f 2)
PERM_MODEL='custom'
RSRC_TYPE='all'
REGION=''
BRANCH=''

help:
	@echo ""
	@echo "Parameters:"
	@echo "- PERM_MODEL=[env|custom]                                    Custom is a private method preferred by the architect. Use 'env' for AWS to gather variables from your environment or config."
	@echo "- RSRC_TYPE=[AWS::Service::Feature|all]                      Run resource-types-list for a full list of values."
	@echo "- REGION=[aws-region|all]                                    Run regions-list for a full list of values."
	@echo "- BRANCH=[branch-you-wanna-merge]                            Specify the Git branch"
	@echo ""
	@echo "Targets:"
	@echo "- make help                                                  Print this menu"
	@echo "- make container-db-logs                                     Get database container logs"
	@echo "- make container-db-shell                                    Open BASh shell in database container"
	@echo "- make container-wp-logs                                     Get Wordpress container logs"
	@echo "- make container-wp-shell                                    Open BASh shell in Wordpress container"
	@echo "- make containers-down                                       Destroy containers"
	@echo "- make containers-stop                                       Stop containers"
	@echo "- make containers-up                                         Start containers and pull if necessary"
	@echo "- make git-branch-clean                                      Delete branches on local and remote interactively"
	@echo "- make git-branch-current                                    Print the current Git branch name and hash"
	@echo "- make git-merge-squash BRANCH                               Squash merge with interactive commit message"
	@echo ""


# cloud-aws-resources-list:
# 	@./Make.sh
# 	@make --directory=./cloud/ aws-resources-list PERM_MODEL=$(PERM_MODEL) RSRC_TYPE=$(RSRC_TYPE) REGION=$(REGION)

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

git-merge-squash:
	@./Make.sh _git_merge_squash $(BRANCH)
