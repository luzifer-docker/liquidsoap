# luzifer-docker / liquidsoap

Run [Liquidsoap](https://github.com/savonet/liquidsoap) in a Docker container

## Usage

```bash
## Build container (optional)
$ docker build -t luzifer/liquidsoap .

## Create config
$ touch $(pwd)/config/liquidsoap.liq

## Execute liquidsoap
$ docker run --rm -ti -v $(pwd)/config:/etc/liquidsoap -v /path/to/music:/data luzifer/liquidsoap
```
