# Bootstrap Blog Skeleton

[![Demo](https://img.shields.io/badge/Demo-BootstrapBlog-blue.svg?style=flat-square)](https://skeleton.ayozehd.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://github.com/ayozehd/grav-skeleton-bootstrap-blog/blob/master/LICENSE)

**Bootstrap Blog** skeleton built for the open source modern FLAT-file [Grav CMS](http://getgrav.org).

![](screenshot.jpg)

## Standard Install Instructions

**Installation Steps** 

1. Download the repository
    ```
    git clone https://github.com/ayozehd/grav-skeleton-bootstrap-blog.git
    ```
2. Copy files to your Web server Grav dir: `/user`
3. Run `bin/gpm install` to install dependencies
4. Point your browser to the Web server folder
5. Create your site administrator account when prompted
6. And you're done!

Or download the skeleton from [Grav](https://getgrav.org/downloads/skeletons), uncompress the file and copy entire folder to web server.

## Docker Install Instructions

1. Install [Docker CE](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
2. Download and this skeleton
3. Copy content of `webserver-config/.docker` to root folder
4. Run `docker-compose up -d --build` (`-d` flag to deamonize process)
5. Access to [http://localhost:8080/](http://localhost:8080)

Create as many volumes you may need at docker-compose.yaml to persist data between your contanerized Grav and host machine. By default only `user/data` and `user/pages` directories are mounted as volumes.

Access to container shell: `docker-compose exec grav /bin/sh`
