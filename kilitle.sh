#!/usr/bin/env bash

if [[ $(ps aux|grep i3lock|grep -v grep|wc -l) -eq 0 ]]; then
  TIME=$(xprintidle)
  if [[ $TIME -gt 300000 ]]; then
    echo sleeping $TIME
    i3lock-fancy
  fi
fi
