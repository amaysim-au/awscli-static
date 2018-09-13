# Build Image
FROM alpine:latest as builder

ARG PYINSTALLER_TAG=v3.3

ADD ./bin /pyinstaller

RUN mkdir /src
ADD ./bin/change-botocore-root.py /src

# Install PreReq's
RUN apk --update --no-cache add \
  python3 python3-dev zlib-dev musl-dev \
  libc-dev gcc git pwgen groff less

# Install pycrypto so --key can be used with PyInstaller
RUN pip3 install pycrypto && \
    pip3 install awscli

# Install Pyinstaller
WORKDIR /tmp
RUN git clone --depth 1 --single-branch --branch $PYINSTALLER_TAG \
      https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller && \
    cd /tmp/pyinstaller/bootloader && \
    python3 ./waf configure --no-lsb all && \
    pip3 install .. && \
    rm -Rf /tmp/pyinstaller

# Build AWSCLI
WORKDIR /src
RUN chmod a+x /pyinstaller/* && \
    /pyinstaller/pyinstaller.sh --noconfirm --onefile \
      --hiddenimport=awscli.handlers \
      --add-data=/usr/lib/python3.6/site-packages/awscli/data:data \
      --add-data=/usr/lib/python3.6/site-packages/botocore/data:data \
      --runtime-hook=change-botocore-root.py /usr/bin/aws && \
    chmod +x /src/dist/aws

# Runtime Image
FROM alpine:latest

# Install PreReq's
RUN apk --no-cache update && \
    apk --no-cache add bash groff less jq && \
    rm -rf /var/cache/apk/*

COPY --from=builder /src/dist/aws /opt/aws/bin/aws
COPY ./bin/ /opt/aws/bin/

RUN ln -s /opt/aws/bin/assume-role /usr/bin/assume-role && \
    ln -s /opt/aws/bin/assume-role /usr/bin/assume-role.sh  && \
    ln -s /opt/aws/bin/cfn-create-or-update /usr/bin/cfn-create-or-update && \
    ln -s /opt/aws/bin/cfn-delete /usr/bin/cfn-delete && \
    ln -s /opt/aws/bin/cfn-validate-template /usr/bin/cfn-validate-template && \
    ln -s /opt/aws/bin/aws /usr/bin/aws

ENTRYPOINT [ "aws" ]
CMD [ "help" ]
