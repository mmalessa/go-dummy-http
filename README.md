# A dummy HTTP server to test various things
https://github.com/mmalessa/go-dummy-http

## Docker
`docker-compose.yaml`
```yaml
version: "3.8"

services:
  http_1:
    container_name: go_dummy_http1
    image: mmalessa/go-dummy-http:1.0.0
    environment:
      - APP_INSTANCE=http1
    ports:
      - "801:80"
  http_2:
    container_name: go_dummy_http2
    image: mmalessa/go-dummy-http:1.0.0
    environment:
      - APP_INSTANCE=http2
    ports:
      - "802:80"
```

## Web browser:
- `http://localhost:801`
- `http://localhost:802`

The server captures everything and displays a simple report, i.e.:
```txt
GO DUMMY HTTP
http://github.com/mmalessa/go-http-mock

Server instance: http1
Server time: 2023-09-04 16:43:10+00:00
Host: localhost
Method: GET
Path: /asdfasdf/
```

## Development kickstart
```sh
make build

```

## DockerHub notes
docker tag local-image:tagname username/new-repo:tagname
docker push username/new-repo:tagname
