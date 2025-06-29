<h1 align="center">
  picoshare一键安装脚本
</h1>
picoshare是一个极简、易于托管的图像和其他文件共享服务。

<hr>

## 安装
* 第1个参数：设置运行端口
* 第2个参数：设置登录密码
```
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/picoshare/main/install.sh) 12345 password
```
## 卸载
```
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/picoshare/main/uninstall.sh) 
```
## NGINX配置
```
    location ~ ^/-[-_A-Za-z0-9]+/.+ {
        proxy_pass http://localhost:12345;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_hide_header Content-Disposition;
        add_header Content-Disposition 'attachment' always;
    }  
    location / {
        proxy_pass http://localhost:12345;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 2G; #设置单个上传文件最大限制
        sendfile on; #启用 sendfile 提高文件传输性能
        tcp_nopush on; #优化大文件传输
    }
```
## 服务管理命令
| 操作         | 命令                                                        |
|--------------|-------------------------------------------------------------|
| 启动服务     | ```sudo systemctl start picoshare```                      |
| 停止服务     | ```sudo systemctl stop picoshare```                       |
| 重启服务     | ```sudo systemctl restart picoshare```                    |
| 查看状态     | ```sudo systemctl status picoshare```                     |
| 查看日志     | ```sudo journalctl -u picoshare -f```                     |
| 开机自启动   | ```sudo systemctl enable picoshare```                     |
| 关闭开机启动 | ```sudo systemctl disable picoshare```                    |

[官方demo](https://demo.pico.rocks/)
