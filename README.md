# picoshare
一个极简、易于托管的图像和其他文件共享服务

---

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
    }
```

[官方demo](https://demo.pico.rocks/)
