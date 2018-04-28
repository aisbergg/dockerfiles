#!/bin/bash

export IMAGEMAGICK_SHARED_SECRET="$( </dev/urandom tr -dc '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c40; echo "")"
