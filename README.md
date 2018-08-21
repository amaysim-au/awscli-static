# awscli-static

This is a static build of the AWS CLI, built for different base OS's.

The [PyInstaller](http://pyinstaller.readthedocs.io/) Dockerfile is mostly from [pyinstaller-alpine](https://github.com/six8/pyinstaller-alpine).

## Runtime Requirements

The aws cli runtime requires the following alpine packages to be installed:

The `aws` cli will be installed to `/usr/local/bin/aws` in the image

### Alpine
For `help` output to work:
* less
* groff

# Credit
This code is based off: https://github.com/richiefi/alpine-awscli
