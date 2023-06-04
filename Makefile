SHELL := /bin/bash
.PHONY: help


CB=$(shell ./Make.sh _git_branch_current)
TARGET=dev
FILE=""

help:
	@echo ""
	@echo "Targets:"
	@echo "- help                                           Print this menu"
	@echo "- container-nginx-build CB TARGET                Build image at TARGET with CB"
	@echo "- container-nginx-images CB TARGET               List images for this project"
	@echo "- container-nginx-logs CB TARGET                 Print NginX logs"
	@echo "- container-nginx-remove CB TARGET               Remove NginX container"
	@echo "- container-nginx-run CB TARGET                  Run NginX container with name consisting of TARGET and CB"
	@echo "- container-nginx-start CB TARGET                Start NginX container with name consisting of TARGET and CB"
	@echo "- container-nginx-stop CB TARGET                 Stop Nginx container with name consisting of TARGET and CB"
	@echo "- container-nginx-shell CB TARGET                Access NginX container shell with name consisting of TARGET and CB"
	@echo "- container-nginx-rmi CB TARGET                  Remove image at TARGET with CB"
	@echo "- git-add-partial                                Add part of a diff as the commit (experimental)"
	@echo "- git-branch-clean                               Delete branches on local and remote interactively"
	@echo "- git-branch-current                             Print the current Git branch name and hash"
	@echo "- git-commit-amend                               Amend with no edit"
	@echo "- git-merge-squash BRANCH                        Squash merge with interactive commit message and tag the commit with that branch name"
	@echo "- print-config                                   Print defaults in this Makefile"
	@echo ""



# cloud-aws-resources-list:
# 	@./Make.sh
# 	@make --directory=./cloud/ aws-resources-list PERM_MODEL=$(PERM_MODEL) RSRC_TYPE=$(RSRC_TYPE) REGION=$(REGION)

container-nginx-build:
	@./Make.sh
	@make --directory=./containers nginx-build CB="$(CB)" TARGET="$(TARGET)"

container-nginx-images:
	@./Make.sh
	@make --directory=./containers nginx-images

container-nginx-logs:
	@./Make.sh
	@make --directory=./containers nginx-logs CB="$(CB)" TARGET="$(TARGET)"

container-nginx-remove:
	@./Make.sh
	@make --directory=./containers nginx-remove CB="$(CB)" TARGET="$(TARGET)"

container-nginx-rmi:
	@./Make.sh
	@make --directory=./containers nginx-rmi CB="$(CB)" TARGET="$(TARGET)"

container-nginx-run:
	@./Make.sh
	@make --directory=./containers nginx-run CB="$(CB)" TARGET="$(TARGET)"

container-nginx-start:
	@./Make.sh
	@make --directory=./containers nginx-start CB="$(CB)" TARGET="$(TARGET)"

container-nginx-stop:
	@./Make.sh
	@make --directory=./containers nginx-stop CB="$(CB)" TARGET="$(TARGET)"

container-nginx-shell:
	@./Make.sh
	@make --directory=./containers nginx-shell CB="$(CB)" TARGET="$(TARGET)"

git-add-partial:
	@./Make.sh _git_add_partial "$(FILE)"

git-branch-clean:
	@./Make.sh _git_branch_clean

git-branch-current:
	@./Make.sh _git_branch_current

git-commit-amend:
	@./Make.sh _git_commit_amend

git-merge-squash:
	@./Make.sh _git_merge_squash "$(BRANCH)"

git-push-head:
	@./Make.sh _git_push_head "$(BRANCH)"

print-config:
	@echo CB: $(CB)
	@echo TARGET: $(TARGET)
