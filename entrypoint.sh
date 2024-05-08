#!/bin/sh

sed -i 's/URL/'$URL'/g' /root/.xmrig.json
sed -i 's/WALLET/'$WALLET'/g' /root/.xmrig.json
sed -i 's/NODE_NAME/'$NODE_NAME'/g' /root/.xmrig.json

xmrig