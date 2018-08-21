FROM alpine:3.8

ARG PYINSTALLER_TAG=v3.3
WORKDIR /src

ADD ./bin /pyinstaller
ADD ./change-botocore-root.py /src

# PyInstaller needs zlib-dev, gcc, libc-dev, and musl-dev
# Install pycrypto so --key can be used with PyInstaller
RUN apk --update --no-cache add python3 python3-dev zlib-dev musl-dev libc-dev gcc git pwgen groff less && \
    pip3 install pycrypto && \
    pip3 install awscli && \
    cd /tmp && \
    git clone --depth 1 --single-branch --branch $PYINSTALLER_TAG https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller && \
    cd /tmp/pyinstaller/bootloader && \
    python3 ./waf configure --no-lsb all && \
    pip3 install .. && \
    cd /src && \
    rm -Rf /tmp/pyinstaller && \
    chmod a+x /pyinstaller/* && \
    /pyinstaller/pyinstaller.sh --noconfirm --onefile --hiddenimport=awscli.handlers --add-data=/usr/lib/python3.6/site-packages/awscli/data:data --add-data=/usr/lib/python3.6/site-packages/botocore/data:data --runtime-hook=change-botocore-root.py /usr/bin/aws && \
    cp /src/dist/aws /usr/local/bin/ && \
    apk del python python3-dev zlib-dev musl-dev libc-dev gcc git pwgen && \
    rm -rf /usr/lib/python3.6 && \
    rm -rf /src/* && \
    rm -rf /tmp/pyinstaller && \
    rm -rf /var/cache/apk/*
