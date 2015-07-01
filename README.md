# docker-lamp
This installs a basic [LAMP](http://en.wikipedia.org/wiki/LAMP_\(software_bundle\))
 stack - a popular combination of open source software components, used to build dynamic web sites.

## Components
The stack comprises the following components:

Name       | Version                   | Description
-----------|---------------------------|------------------------------
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)                    | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Scripting language

## Usage

### Basic Example
Start your image binding host port 8080 to port 80 (Apache Web Server) in your container:

    sudo docker run -d -p 8080:80 dell/lamp

Test your deployment:

    curl http://localhost:8080/


### Advanced Example 1
To start your image with:

 - A data volume (which will survive a restart) for the PHP application files, in folder **/app** on the host. Note that, if the folder does not exist or is empty, a simple default site will be created.
 - Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed.
 - A specific MySQL password.

Do:

    sudo docker run -d -p 80:80 -p 3306:3306 -p 443:443 -v /app:/var/www/html \
    -e MYSQL_PASS=mypass dell/lamp
    
You can access Apache from your browser:

    http://localhost
OR

    https://localhost (You must accept the SSL certificate first)

You can test your new MySQL admin password:

    mysql -u admin -pmypass -h127.0.0.1 -P3306

### Advanced Example 2
To start your image with:

 - Two data volumes (which will survive a restart or recreation of the container). The MySQL data is available in **/data/mysql** on the host. The PHP application files are available in **/app** on the host.
 - Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed
 - A named container (**lamp**)

Do:

    sudo docker run -d -p 80:80 -p 3306:3306 -p 443:443 -v /app:/var/www/html \
    -v /data/mysql:/var/lib/mysql --name lamp dell/lamp

## Administration

### Connecting to MySQL
The first time that you run your container, a new user **admin** with all privileges will be created in MySQL with a random password. To get the password, check the logs of the container. 

    sudo docker logs <container_id>
   
You will see an output like the following:

    ====================================================================
    You can now connect to this MySQL Server using:

      mysql -u admin -p47nnf4FweaKu -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    =====================================================================

In this case, **47nnf4FweaKu** is the password allocated to the **admin** user.

You can then connect to MySQL:


    mysql -u admin -p47nnf4FweaKu -h127.0.0.1 -P3306


Note that the **root** user can't be used for connections from outside the container. Please use the **admin** user instead.

### Updating the Application
The PHP application files are available at path **/var/www/html** on the host. If you are not using a host volume, you will need to use [nsenter](http://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/) to attach to the container.

### Connecting to MySQL from the Application
The bundled MySQL server has a **root** user with no password for local connections. Simply connect from your
PHP code with this user:


    <?php
    $mysql = new mysqli("localhost", "root");
    echo "MySQL Server info: ".$mysql->host_info;
    ?>


## Reference

### Environmental Variables

Variable   | Default  | Description
-----------|----------|----------------------------------
MYSQL_PASS | *random* | Password for MySQL user **admin**

### Image Details

Based on  [tutum/lamp](https://github.com/tutumcloud/tutum-docker-lamp)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/lamp](https://registry.hub.docker.com/u/dell/lamp) 
