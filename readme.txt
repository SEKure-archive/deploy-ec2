This script configures the ec2 instance for deployment. By installing an Nginx server
and installing the website.  The seckure archive api is installed afert with a build
script.  The api is configured in a docker container.

The Nginx server hosts the static website on "example.com" and the api uses
subdomain "api.exapmle.com".

Store Nginx config files in an s3 bucket and update the deploy.sh script
S3Paths should be:
      /nginx-config/nginx.conf"
      /nginx-config/default.conf"


To set up your nginx config giles.  The following commands should be added:

/etc/nginx/nginx.cong:
    ...
    http {
        # Forward request to api server
        server {
             listen       80;
             server_name  api.exapmle.com;

             location / {
                 proxy_pass http://172.17.0.2;
                 proxy_http_version 1.1;
                 proxy_set_header Host      $host;
                 proxy_set_header X-Real-IP $remote_addr;
             }
        }
    ...
    }


/etc/nginx/conf.d/default.cong
    server {
        listen       80;
        server_name  example.com;

        #charset koi8-r;
        #access_log  /var/log/nginx/log/host.access.log  main;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        error_page  404              /index.html;
        ...
    }
