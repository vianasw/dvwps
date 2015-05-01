# dvwps: Damn Vulnerable WordPress Site

This is simply a Docker container with a vulnerable WordPress version and vulnerable plugins. This project is aimed for people who want to learn about penetration testing by playing with vulnerable WordPress setup. 

## Basic usage
### Setting up MySQL database

To execute this container you need a running MySQL database server. You could set up your own hosted MySQL server, create a wordpress database, and a wordpress user. Or you could just use the official MySQL Docker container like I do. In both cases you'll need to start MySQL with `sql-mode='ALLOW_INVALID_DATES'` option. In the `config` directory of this repository I've included a sample mysql config named `mysql.cnf` with this option.

If you choose to use the MySQL Docker container and you want the changes to the WordPress site to be persistent, keep reading.

Create a data only container dockerfile:

```
FROM ubuntu:14.04
MAINTAINER William Viana <vianasw@gmail.com>
VOLUME /var/lib/mysql

CMD ["true"]
```

Then run the following commands:
```
$ docker build -t username/mysql_datastore .
$ docker run --name wp_data username/mysql_datastore
```

After that, you can run the MySQL Docker container like this:

```
$ docker run --name wp_db -p 3306:3306 --volumes-from wp_data  -v /path/to/dvwps/configs/:/etc/mysql/conf.d  -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=wordpressuser -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=wordpress -d mysql:5.6
```

###Running the container
If you chose to execute MySQL from a Docker container you just have to execute the following command, otherwise ignore the `--link` argument.

```
$ docker run -d --link wp_db:mysql -p 80:80 -e DB_NAME='wordpress' -e DB_USER='wordpressuser' -e DB_HOST='db_host_ip_address' -e DB_PASSWORD='password' vianasw/dvwps
```

