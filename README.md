<h1 align="center">
  picoshare
</h1>

<hr>

## Installation
* In this example:
  - The service will run on port 12345
  - The login password will be password
```
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/picoshare/main/install.sh) 12345 password
```
## Uninstallation
```
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/picoshare/main/uninstall.sh) 
```
## Nginx Configuration
```nginx
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
        client_max_body_size 2G; 
        sendfile on; 
        tcp_nopush on; 
    }
```
