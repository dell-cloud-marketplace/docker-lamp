# docker-lamp
This blueprint installs a basic [LAMP](http://en.wikipedia.org/wiki/LAMP_(software_bundle)) stack - a popular combination of open source software components, used to build dynamic web sites.

* [Components](#components)
* [Usage](#usage)
    * [Basic Example](#basic-example)
    * [Advanced Example 1](#advanced-example-1)   
    * [Advanced Example 2](#advanced-example-2)   
* [Administration](#administration)
    * [Connecting to MySQL](#connecting-to-mysql)
    * [Updating the Application](#updating-the-application)
    * [Connecting to MySQL from the Application](#connecting-to-mysql-from-the-application)
* [Reference](#reference)
    * [Image Details](#image-details)
    * [Dockerfile Settings](#dockerfile-settings)
    * [Port Details](#port-details)
    * [Volume Details](#volume-details)
    * [Additional Environmental Settings](#additional-environmental-settings)
* [Blueprint Details](#blueprint-details)
* [Building the Image](#building-the-image)
* [Issues](#issues)

<a name="components"></a>
## Components
The stack comprises the following components:

Name       | Version    | Description
-----------|------------|------------------------------
Ubuntu     | Trusty     | Operating system
MySQL      | 5.5        | Database
Apache     | 2.4.7      | Web server
PHP        | 4.0.2      | Scripting language

**If a component is an up-to-date, compatible version, as determined by the operating system package manager, at installation time, please complete the version information based on the install.**

<a name="usage"></a>
## Usage

<a name="basic-example"></a>
### Basic Example
Start your image binding host port 8080 to port 80 (Apache Web Server) in your container:

```no-highlight
docker run -d -p 8080:80 dell/lamp
```

Test your deployment:

```no-highlight
curl http://localhost:8080/
```

```no-highlight
curl https://localhost/
```

<a name="advanced-example-1"></a>
### Advanced Example 1
Start your image with:

* A volume (which will survive a restart) for the PHP application files, in folder **/app** on the host. Note that, if the folder does not exist or is empty, a simple default site will be created.
* Both port 80 (Apache Web Server) and 3306 (MySQL) exposed.
* A specific MySQL password.

```no-highlight
docker run -d -p 80:80 -p 3306:3306 -p 443:443 -v /app:/var/www/html -e MYSQL_PASS="mypass" dell/lamp
```

You can now test your new admin password:

```no-highlight
mysql -uadmin -p"mypass"
```

<a name="advanced-example-2"></a>
### Advanced Example 2
Start your image with:

* Two data volumes (which will survive a restart):
    * The MySQL data is available in **/data/mysql** on the host.
    * The PHP application files are available in **/app** on the host.
* Both port 80 (Apache Web Server) and 3306 (MySQL) exposed
* A named container (**lamp**)

```no-highlight
docker run -d -p 80:80 -p 3306:3306 -p 443:443 -v /app:/var/www/html -v /data/mysql:/var/lib/mysql \
    --name lamp dell/lamp
```

<a name="administration"></a>
## Administration

<a name="connecting-to-mysql"></a>
### Connecting to MySQL
The first time that you run your container, a new user admin with all privileges will be created in MySQL with a random password. To get the password, check the logs of the container. You will see an output like the following:

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections
========================================================================
```

In this case, **47nnf4FweaKu** is the password allocated to the admin user.

You can then connect to MySQL:

```no-highlight
mysql -uadmin -p47nnf4FweaKu
```

Note that the root user does not allow connections from outside the container. Please use this admin user instead.

<a name="updating-the-application"></a>
### Updating the Application
The PHP application files are available at path **/var/www/html** on the host. If you are not using a host volume, you will need to use [nsenter](http://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/) to attach to the container.

<a name="(#connecting-to-mysql-from-the-application)"></a>
### Connecting to MySQL from the Application
The bundled MySQL server has a `root` user with no password for local connections. Simply connect from your
PHP code with this user:

```php
<?php
$mysql = new mysqli("localhost", "root");
echo "MySQL Server info: ".$mysql->host_info;
?>
```

<a name="reference"></a>
## Reference

<a name="image-details"></a>
### Image Details

Attribute         | Value
------------------|------
Based on          | [tutum/lamp](https://github.com/tutumcloud/tutum-docker-lamp)
Github Repository | [https://github.com/ghostshark/docker-lamp](https://github.com/ghostshark/docker-lamp)
Pre-built Image   | [https://registry.hub.docker.com/u/dell/lamp](https://registry.hub.docker.com/u/dell/lamp) 

<a name="dockerfile-settings"></a>
### Dockerfile Settings

Instruction | Value
------------|------
ENV         | ['PHP_UPLOAD_MAX_FILESIZE', '10M']
ENV         | ['PHP_POST_MAX_SIZE', '10M']
VOLUME      | ['/var/lib/mysql', '/var/www/html']
EXPOSE      | ['80', '3306','443']
CMD         | ['/run.sh']

<a name="port-details"></a>
### Port Details

Port | Details
-----|--------
80   | Apache web server
443  | SSL
3306 | MySQL admin

<a name="volume-details"></a>
### Volume Details

Path           | Details
---------------|--------
/var/lib/mysql | MySQL data
/var/www/html  | The PHP application

<a name="additional-environmental-settings"></a>
### Additional Environmental Settings

Variable   | Description
-----------|------------
MYSQL_PASS | The MySQL admin user password. If not specified, a random value will be generated.

<a name="blueprint-details"></a>
## Blueprint Details
Under construction.

<a name="building-the-image"></a>
## Building the Image
To build the image, execute the following command in the docker-lamp folder:

```no-highlight
docker build -t dell/lamp .
```

<a name="issues"></a>
## Issues

