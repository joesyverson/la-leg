SHELL := /bin/bash
.PHONY: help


TAG=$(shell ./Make.sh _git_branch_current)
TARGET=dev
FILE=""

help:
	@echo ""
	@echo "Targets:"
	@echo "- help                                                  Print this menu"
	@echo "- container-nginx-build TAG TARGET                      Build image at TARGET with TAG"
	@echo "- container-nginx-rmi TAG TARGET                        Remove image at TARGET with TAG"
	@echo "- git-branch-clean                                      Delete branches on local and remote interactively"
	@echo "- git-branch-current                                    Print the current Git branch name and hash"
	@echo "- git-commit MSG                                        Commit and add a tag to the branch of the branch name"
	@echo "- git-merge-squash BRANCH                               Squash merge with interactive commit message"
	@echo ""

# cloud-aws-resources-list:
# 	@./Make.sh
# 	@make --directory=./cloud/ aws-resources-list PERM_MODEL=$(PERM_MODEL) RSRC_TYPE=$(RSRC_TYPE) REGION=$(REGION)

container-nginx-build:
	@./Make.sh
	@make --directory=./containers nginx-build TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-images:
	@./Make.sh
	@make --directory=./containers nginx-images

container-nginx-logs:
	@./Make.sh
	@make --directory=./containers nginx-logs TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-remove:
	@./Make.sh
	@make --directory=./containers nginx-remove TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-rmi:
	@./Make.sh
	@make --directory=./containers nginx-rmi TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-run:
	@./Make.sh
	@make --directory=./containers nginx-run TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-start:
	@./Make.sh
	@make --directory=./containers nginx-start TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-stop:
	@./Make.sh
	@make --directory=./containers nginx-stop TAG="$(TAG)" TARGET="$(TARGET)"

container-nginx-shell:
	@./Make.sh
	@make --directory=./containers nginx-shell TAG="$(TAG)" TARGET="$(TARGET)"

git-add-partial:
	@./Make.sh _git_add_partial "$(FILE)"

git-branch-clean:
	@./Make.sh _git_branch_clean

git-branch-current:
	@./Make.sh _git_branch_current

git-commit:
	@./Make.sh _git_commit "$(MSG)"

git-commit-amend:
	@./Make.sh _git_commit_amend

git-merge-squash:
	@./Make.sh _git_merge_squash "$(BRANCH)"

git-push-head:
	@./Make.sh _git_push_head "$(BRANCH)"

print-config:
	@echo TAG: $(TAG)
	@echo TARGET: $(TARGET)
