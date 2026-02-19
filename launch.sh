#!/usr/bin/env bash
# Quick launcher for Agent Emacs

exec emacs --init-directory "$HOME/.agent.emacs.d" "$@"
