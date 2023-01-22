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
	@echo "- make git-branch-clean                                      Delete branches on local and remote interactively"
	@echo "- make git-branch-current                                    Print the current Git branch name and hash"
	@echo "- make git-merge-squash BRANCH                               Squash merge with interactive commit message"
	@echo ""


# cloud-aws-resources-list:
# 	@./Make.sh
# 	@make --directory=./cloud/ aws-resources-list PERM_MODEL=$(PERM_MODEL) RSRC_TYPE=$(RSRC_TYPE) REGION=$(REGION)

# container-wp-db-logs:
# 	@./Make.sh
# 	@make --directory=./containers wp-db-logs

git-branch-clean:
	@./Make.sh _git_branch_clean

git-branch-current:
	@./Make.sh _git_branch_current

git-merge-squash:
	@./Make.sh _git_merge_squash $(BRANCH)
