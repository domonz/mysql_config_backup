#!/bin/bash
echo "Reading config...." >&2
source ./config.cfg
echo "Config for the backup user: $user" >&2
echo "Config for the backup password: $passwd" >&2
echo "Config for the backup destination_folder: $dest" >&2
