#!/usr/bin/env bash
# sync-upstream.sh — merge professor’s main into your main

# (1) add upstream remote if it doesn’t exist
git remote get-url upstream &>/dev/null || \
  git remote add upstream https://github.com/joachim-gassen/rct25.git

# (2) fetch from upstream
git fetch upstream

# (3) merge upstream/main into your current branch
git merge upstream/main


# run in terminal
#   ./sync-upstream.sh
