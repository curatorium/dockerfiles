server {
    listen       80 default;
    server_name  localhost;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;

    root  /app/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        fastcgi_split_path_info  ^(.+\.php)(/.+)$;
        fastcgi_index            index.php;
        fastcgi_param            SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include                  fastcgi_params;
        fastcgi_intercept_errors on;
        fastcgi_pass             unix:/run/php/php$PHPVS-fpm.sock;
    }

    error_page  404              /404.html;
    error_page  500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
