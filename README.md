WHD inside a docker container connecting up to a external MS SQL Database. Support for Postgres or MySQL is not implemented, please feel free to implement.

Starting the container

```
docker run -d --mount source=whd,target=/usr/local/webhelpdesk -p 80:80 -p 443:443 --name whd pascaldulieu/whd
```
