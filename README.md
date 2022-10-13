> **Warning**
> This project is no longer maintained. Use it only as inspiration.

# Simple Docker LEMP stack
This is a server stack used to host your web application with Docker based Nginx, MySQL and PHP. It is a super easy to setup on local development or even on production environment (VPS). There is also PhpMyAdmin to manage your database and Portainer to manage Docker components. The stack is SSL ready by using ACME challenge to get Let's Encrypt certificate. To put everything together there is the Traefik reverse proxy.

How to install Docker based Nginx, MySQL and PHP on Digital Ocean:  
https://www.youtube.com/watch?v=ciiX3a-BzZs

How to install Docker based LEMP server for localhost development:  
https://www.youtube.com/watch?v=mkmcFuJt5Gk

## What's inside
- Nginx
- MySQL 5.7
- PHP 7.2
- Traefik
- PhpMyAdmin
- Portainer

## Features
- Nginx, MySQL, PHP and Traefik configured.
- PhpMyAdmin and Portainer included.
- Let's Encrypt configured.
- Automatically sets up and configures the stack for any domain name.
- Sets up Traefik, PhpMyAdmin and Portainer to run on subdomain.
- Gets Let's Encrypt SSL certificate through ACME challenge.
- Swap non SSL configuration to SSL and vise versa.
- Can be used on local development or production environment.
- Can be used on any machine with Docker installed.

## Using at production environment
For example, you can use Digital Ocean droplet with Docker preinstalled.

### Requirements
- Any (cloud) server with Docker installed.
- Your domain DNS needs to point to the server IP address within A type record. Root domain (@) and wildcard (\*) have to be set.

### Deployment
Following steps of this stack production deployment are demonstrated on `example.com` domain name.

1. Login to your server through SSH.
2. Create a new folder for a service. For example it could be `/srv/web/example.com`.
3. Clone this repository to this created folder (without repository name folder).
4. Move to the `/srv/web/example.com/docker` folder.
5. Run `sh start.sh --production` and enter prompted questions (domain name, e-mail).
6. If everything went well, your stack will be properly configured and Docker containers should start. Then these services will be available:  
Nginx/PHP: `https://example.com`  
Traefik dashboard: `https://traefik.example.com`  
PhpMyAdmin: `https://pma.example.com`  
Portainer: `https://portainer.example.com`
7. You can check functionality by opening URLs above. There should be running these services and at `https://example.com` there should be working `phpinfo()` and MySQL database connection test through PDO.
8. Check users and passwords section to get login to Traefik dashboard, MySQL/PhpMyadmin and Portainer.
9. Check own content section to know where to put your web application files.

## Using at localhost development
You can use any OS where the Docker is supported.

### Requirments
- Docker installed.

### Deployment
Following steps of this stack localhost deployment are demonstrated on `example.localhost` domain name. However even on localhost development, you can use typical `example.com` form of domain name.

1. Start Docker.
2. Clone this repository to any folder you want.
3. Open terminal in `/docker` subfolder.
4. Run `sh start.sh --localhost` and enter prompted questions (domain name, HTTP port).
5. Add record to your `hosts` file. If you use Google Chrome browser you don't need to, because he can do it automatically for every `*.localhost` like domain name.  
`127.0.0.1 example.localhost`  
`127.0.0.1 traefik.example.localhost`  
`127.0.0.1 pma.example.localhost`  
`127.0.0.1 portainer.example.localhost`
6. If everything went well, your stack will be properly configured and Docker containers should start. Then these services will be available:  
Nginx/PHP: `example.localhost`  
Traefik dashboard: `traefik.example.localhost`  
PhpMyAdmin: `pma.example.localhost`  
Portainer: `portainer.example.localhost`
7. You can check functionality by opening URLs above. There should be running these services and specially at `example.localhost` there should be working `phpinfo()` and MySQL database connection test through PDO.
7. Check users and passwords section to get login to Traefik dashboard, MySQL/PhpMyadmin and Portainer.
8. Check own content section to know where to put your web application files.

## Users and passwords
There are some default users and passwords, which have to be set to sign in to the Traefik dashboard, MySQL/PhpMyAdmin and Portainer. Obviously, you can change these by rewriting preconfigured values.
### Traefik dashboard
- Default user name is `admin` and default password is `secret`.
- Configuration is stored in `/docker/traefik/traefik.toml` file on production environment in `users = ["username:password"]` form where the password string is replaced to SHA1 hash. There is no login on localhost development.
### MySQL/PhpMyAdmin
- Default user name is `admin` and default password is `secret`.
- Configuration is stored in `/docker/mysql/.env` file.
### Portainer
- There is no default user and password. You need to register new account at `portainer.example.com` on production environment or at `portainer.example.localhost` on localhost development after you first started Docker containers. Then configuration will be stored in `/docker/poratiner` folder. This folder is created automatically.

## Own content
Just after you successfully deploy this stack on production or localhost you can see whether it's working by opening `example.com` or `example.localhost` where is `phpinfo()` and MySQL database connection test running. Now it's time to change this functionality test content to your own web application. Your files have to be put to the `/public` folder which is root folder for Nginx to looking for `index.php` file. If you have more complicated project structure divided to public and private components like Laravel has for example, then put public files to `/public` folder and all other folders and files (app, resources, routes, ...) put next to the `/docker` folder therefor same level. It means that this stack is a part of your project folder. Therefore, you are not putting your web application into this stack but vice versa this stack into you web application project folder.

- Simply `/public` folder is place where you have to put your own web application files. At least `index.php` file.

## Database
- Check users and passwords section to get login to MySQL/PhpMyAdmin.
- Check configuration files section to find out where configuration is stored if you want to change database name, user and password.
- To make database connection use `mysql` string for a host parameter.
- All your database data are stored in `/mysql` folder. This folder is created automatically.

## Swap SSL
If you want to manually swap non SSL configuration to SSL variant and vice versa run `sh traefik-swap.sh` script in `/docker/traefik` folder.

## Reconfiguration
If you want to change configuration (domain name, port, e-mail) without cloning clear repository and starting from the scratch after you have already configure it up once, you can simply use start script again by running `sh start.sh --production` or `sh start.sh --localhost` in `/docker` folder. However, be careful to not delete `/docker/.env` file after it's created, because it's needed for reconfiguration process. If you want to (re)configure stack without starting Docker containers you can use another prepared script `sh configure.sh --production` or `sh configure.sh --localhost` in `/docker` folder instead.

- Simply run `sh start.sh --production` or `sh start.sh --localhost` again.

## Configuration files
There are a few configuration files you can manually change if you need to.

### Nginx
- Primary configuration file is `/docker/nginx/nginx.conf`.

### MySQL
- Database connection configuration file is `/docker/mysql/.env`.

### PHP
- Configuration overrides file for overwriting `php.ini` file is `/docker/php-fpm/php-ini-overrides.ini`.

### Traefik
- Primary configuration file is `/docker/traefik/traefik.toml`.
- There is always one more configuration file. It's `/docker/traefik/traefik.http.toml` or `/docker/traefik/traefik.https.toml` depending on whether the stack is configured to production environment or localhost development. These files are for non SSL to SSL swapping purposes and vice versa, but only the primary configuration file is in usage.

### Portainer
- Configuration files are stored in `/docker/portainer`. This folder is automatically created after the Docker containers are started.

## Monitoring
There are several files used for logging service errors and their statuses.

### Nginx
- All logs are stored in `/docker/nginx/logs` folder. This folder is created automatically.
