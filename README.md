# docker-icecast

Start your online radio easily.  
This image contains a template generator called [mo](https://github.com/tests-always-included/mo) based on [Mustache](https://mustache.github.io/) which allows us to generate an icecast config on the fly.

### Environment Variables : 

| ENV | Default Value | Description |
|---|---|---|
| `GENERATE_TEMPLATE` | False | Generate *icecast.xml* conf from environment variables |
| `IC_ADMIN`  | icemaster@localhost  | Icecast administrator email, for contact use  |
| `IC_ADMIN_PASSWORD`  |  hackme | Icecast administrator password, please consider changing it |
| `IC_ADMIN_USER` | admin | Icecast administrator username  |
| `IC_CLIENT_TIMEOUT` | 30  |  Client Timeout |
| `IC_HEADER_TIMEOUT`  | 15  |  Header Timeout  |
| `IC_HOSTNAME`  | localhost  | Hostname of your icecast environment  |
| `IC_LISTEN_BIND_ADDRESS` | 0.0.0.0  | Listen bind address |
| `IC_LISTEN_MOUNT` | stream  | Mount name for streams (localhost:8000/stream.opus / localhost:8000/radiostar.mp3) |
| `IC_LISTEN_PORT` | 8000 | Icecast Listen Port, by default image exposes port 8000 |
| `IC_LOCATION`  | Earth  |  Location of Icecast Server, only for informational purpose ("Spain") |
| `IC_MAX_CLIENTS`  | 100  | Max clients for Icecast Server |
| `IC_MAX_SOURCES` | 4  | Max sources for Icecast Server |
| `IC_SOURCE_PASSWORD`  | hackme | Icecast Default Source Password  |
| `IC_SOURCE_TIMEOUT`  | 10  | Icecast Source Timeout |
| `IC_QUEUE_SIZE` | 524288 | Icecast queue size |
| `IC_BURST_SIZE` | 65535 | Icecast burst size |
| `IC_MASTER_RELAY_PASSWORD` | hackme | Password for slave relays |
| `ENABLE_RELAY` | False | If this is enabled will add relay config |
| `IC_RELAY_MASTER_SERVER` | changeme | Master relay server (host) |
| `IC_RELAY_MASTER_PORT` | 8000 | Master relay port |
| `IC_RELAY_MASTER_UPDATE_INTERVAL` | 120 | Default update interval |
| `IC_RELAY_MASTER_PASSWORD` | hackme | Master relay password |
| `IC_DEBUG_LOGLEVEL` | 3 | Debug Loglevel |
| `IC_LOGSIZE` | 10000 | Size of log (lines) |

### Usage

#### Docker

* With template generation
```
docker run -td -e GENERATE_TEMPLATE=True majorcadevs/icecast
```

* With your own config
```
docker run -it -v "config:/etc/icecast.xml" majorcadevs/icecast
```

#### Docker Compose

You can try the compose file, which starts a master and a relay.
```
docker-compose up
```
