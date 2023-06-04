SHELL := /bin/bash
.PHONY: help

CB=''
TARGET=''

nginx-build:
	@./Make.sh _nginx_build "$(CB)" "$(TARGET)"

nginx-images:
	@./Make.sh _nginx_images

nginx-logs:
	@./Make.sh _nginx_logs "$(CB)" "$(TARGET)"

nginx-remove:
	@./Make.sh _nginx_remove "$(CB)" "$(TARGET)"

nginx-rmi:
	@./Make.sh _nginx_rmi "$(CB)" "$(TARGET)"

nginx-run:
	@./Make.sh _nginx_run "$(CB)" "$(TARGET)"

nginx-start:
	@./Make.sh _nginx_start "$(CB)" "$(TARGET)"

nginx-stop:
	@./Make.sh _nginx_stop "$(CB)" "$(TARGET)"

nginx-shell:
	@./Make.sh _nginx_shell "$(CB)" "$(TARGET)"
