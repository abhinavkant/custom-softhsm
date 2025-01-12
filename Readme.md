# Readme

## Build container image

```sh
docker build -t custom-softhsm:1 .
```

## View Openssl version

```sh
docker run -it custom-softhsm:1 openssl version
```

## View Softhsm version

```
docker run -it custom-softhsm:1 softhsm2-util -v
```

## Run security scan

```sh
docker run --rm \
--volume /var/run/docker.sock:/var/run/docker.sock \
--name Grype anchore/grype:latest \
custom-softhsm:1
```

```sh
docker run --rm --rm -v /var/run/docker.sock:/var/run/docker.sock \
-v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.27.1 \
image custom-softhsm:1
```
