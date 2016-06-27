#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD)
git log "$branch" --not $(git for-each-ref --format='%(refname)' refs/heads/ | grep -v "refs/heads/$branch")

