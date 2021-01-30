#!/bin/bash

timestamp=$(date +"%D %T %s")
git add . && \
git add -u && \
git commit -m "$timestamp" && \
git push origin master
