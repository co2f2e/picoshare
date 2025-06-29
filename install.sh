#!/bin/bash

VERSION=$(curl -s https://api.github.com/repos/mtlynch/picoshare/releases/latest | grep tag_name | cut -d '"' -f4)
VERSION_SHORT="${VERSION#v}"
 VERSION="v$VERSION"
INSTALL_DIR="/usr/local/PicoShare"
DATA_DIR="${INSTALL_DIR}/data"
BIN="picoshare"
ARCHIVE="picoshare-${VERSION}-linux-amd64.tar.gz"
URL="https://github.com/mtlynch/picoshare/releases/download/${VERSION_SHORT}/${ARCHIVE}"

PORT=$1
SECRET=$2

if [ $# -lt 2 ]; then
  echo "执行脚本时缺少参数"
  exit 1
fi

if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
  echo "端口号无效，必须是 1024~65535 之间的数字。"
  exit 1
fi

if [ ${#SECRET} -lt 6 ]; then
  echo "密码太短，至少使用 6 位字符。"
  exit 1
fi

if [[ "$SECRET" =~ [[:space:]] ]]; then
  echo "密码不能包含空格。"
  exit 1
fi

if ! [[ "$SECRET" =~ ^[a-zA-Z0-9_]+$ ]]; then
  echo "密码只能包含字母、数字和下划线。"
  exit 1
fi

if [ -d "$INSTALL_DIR" ]; then
  echo "安装目录 $INSTALL_DIR 已存在，防止上传的文件数据丢失请先下载再运行卸载脚本"
  exit 1
fi

sudo mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

echo "正在下载 PicoShare 安装包..."
wget "$URL" -O "$ARCHIVE" || { echo "❌ 下载失败"; exit 1; }

echo "解压安装包..."
tar -xzf "$ARCHIVE" && rm -f "$ARCHIVE"

if [ ! -f "$BIN" ]; then
  echo "解压后未找到可执行文件 $BIN"
  exit 1
fi

sudo mkdir -p "$DATA_DIR"

SERVICE_FILE="/etc/systemd/system/picoshare.service"

echo "正在创建 systemd 启动服务..."

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=PicoShare File Sharing Server
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/$BIN -db $DATA_DIR/store.db
Environment=PORT=$PORT
Environment=PS_SHARED_SECRET=$SECRET
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "重新加载 systemd 守护进程..."
sudo systemctl daemon-reload

echo "启动并设置开机自启..."
sudo systemctl enable --now picoshare

echo "✅ PicoShare 启动完成"
echo "🌐 访问地址： http://localhost:$PORT"
echo "🔐 登录密码： $SECRET"
echo "📁 数据库存储： $DATA_DIR/store.db"
echo "📜 日志查看： sudo journalctl -u picoshare -f"
