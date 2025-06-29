#!/bin/bash

SERVICE_NAME="picoshare"
INSTALL_DIR="/usr/local/PicoShare"

echo "🛑 停止服务..."
sudo systemctl stop $SERVICE_NAME

echo "🔕 禁用开机启动..."
sudo systemctl disable $SERVICE_NAME

echo "🧹 删除 systemd 服务文件..."
sudo rm -f /etc/systemd/system/$SERVICE_NAME.service

echo "🔄 重新加载 systemd 守护进程..."
sudo systemctl daemon-reload

echo "🗑️ 删除安装目录 $INSTALL_DIR ..."
sudo rm -rf "$INSTALL_DIR"

echo "✅ 卸载完成。"
