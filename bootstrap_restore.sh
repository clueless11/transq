#!/bin/bash
set -e

mkdir -p /root/.config/rclone

cat > /root/.config/rclone/rclone.conf <<EOF
[Blaze]
type = b2
account = ${B2_KEY_ID}
key = ${B2_APP_KEY}
hard_delete = false
EOF

rclone lsd Blaze:

mkdir -p /workspace/transcribe

rclone copy Blaze:ATVast/transcribe /workspace/transcribe -P \
  --exclude "venv/**" \
  --exclude ".cache/**" \
  --exclude "__pycache__/**"

echo "alias backup='rclone sync /workspace/transcribe Blaze:ATVast/transcribe -P --checksum'" >> ~/.bashrc
source ~/.bashrc

cd /workspace/transcribe
ls -lah