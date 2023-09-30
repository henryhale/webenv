#!/usr/bin/env sh

echo -e "Initiatilizing...\n";

echo -e "Installing Node.js...\n";

curl https://get.volta.sh | bash;

export VOLTA_HOME="$HOME/.volta";

export PATH="$VOLTA_HOME/bin:$PATH";

volta -v;

volta install node;

node -v;

npm -v;

npm install -g bun;



