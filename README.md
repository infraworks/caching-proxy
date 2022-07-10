# Caching proxy

## Run in background

```Bash
docker run -d  -p 8000:8000/tcp -v ./cachedir:/var/cache/squid-deb-proxy jxtopher/caching-proxy:latest --name caching-proxy
```

## Add proxy

### For apt

```bash
echo "Acquire::http::Proxy \"http://192.168.42.27:8000\";" > /etc/apt/apt.conf.d/00aptproxy
```
