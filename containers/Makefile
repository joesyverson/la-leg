SHELL := /bin/bash
.PHONY: help

TAG=''
TARGET=''

nginx-build:
	@./Make.sh _nginx_build "$(TAG)" "$(TARGET)"

nginx-images:
	@./Make.sh _nginx_images

nginx-logs:
	@./Make.sh _nginx_logs "$(TAG)" "$(TARGET)"

nginx-remove:
	@./Make.sh _nginx_remove "$(TAG)" "$(TARGET)"

nginx-rmi:
	@./Make.sh _nginx_rmi "$(TAG)" "$(TARGET)"

nginx-run:
	@./Make.sh _nginx_run "$(TAG)" "$(TARGET)"

nginx-start:
	@./Make.sh _nginx_start "$(TAG)" "$(TARGET)"

nginx-stop:
	@./Make.sh _nginx_stop "$(TAG)" "$(TARGET)"

nginx-shell:
	@./Make.sh _nginx_shell "$(TAG)" "$(TARGET)"
