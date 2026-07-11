#!/usr/bin/env bash
# Shared git clone/update helper — source this file, don't run it directly.
# Requires log.sh to be sourced first.
#
# Usage: git_install <url> <dest> [git-clone-args...]
#   - If <dest> has no .git: clones the repo with any extra args
#   - If <dest> already exists: fetches tags and checks out the latest one

git_install() {
    local url="$1" dest="$2"
    shift 2

    if [[ -d "$dest/.git" ]]; then
        info "Updating $(basename "$dest")..."
        git -C "$dest" fetch --tags --depth=1 origin

        local latest_tag
        latest_tag=$(git -C "$dest" describe --abbrev=0 --tags \
            "$(git -C "$dest" rev-list --tags --max-count=1)")
        git -C "$dest" checkout --force "$latest_tag"

        info "$(basename "$dest") updated to $latest_tag"
    else
        info "Cloning $(basename "$dest")..."
        mkdir -p "$(dirname "$dest")"
        git clone "$@" "$url" "$dest"
    fi
}
