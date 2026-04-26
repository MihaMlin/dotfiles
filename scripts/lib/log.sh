#!/usr/bin/env bash
# Shared logging helpers — source this file, don't run it directly.

error()   { echo "❌ $1" >&2; }
warning() { echo "⚠️ $1"; }
info()    { echo "ℹ️ $1"; }
success() { echo "✅ $1"; }
running() { echo "🚀 $1"; }
step()    { echo "📦 $1"; }
