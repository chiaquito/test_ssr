#!/bin/bash
# rootユーザーで操作するためsudo不要


# install git
dnf upgrade --releasever=latest
dnf -y install git 


# intall javascript runtime, nodejs 20.0.0
# https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# source ~/.bashrc
# nvm install v20.0.0




# nextjs-code,  
# git clone https://github.com/chiaquito/test_ssr.git

# cd test_ssr
# npm ci
# npm run build
# npm run start