FROM alpine:3.6
RUN apk update && \
    apk add --no-cache python3 python2 python-dev python3-dev make gcc ca-certificates linux-headers musl-dev && \
    python2 -m ensurepip && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    python2 -m pip install -U pip setuptools tox==2.7.0 && \
    python3 -m pip install -U pip setuptools tox==2.7.0 && \
    rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
