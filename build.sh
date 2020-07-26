#!/bin/bash

MC=1.15.2
REPLAYMOD_BRANCH=stable
FABRIC_API_BRANCH=1.15

# Do not want to pollute the global one with our hacky loom
HOME="$(pwd)/home"
mkdir -p "$HOME"

git clone https://github.com/johni0702/fabric-loom.git --branch remap-to-official
git clone https://github.com/johni0702/fabric-loader.git --branch launchwrapper
git clone https://github.com/ReplayMod/ReplayMod.git --recursive --branch $REPLAYMOD_BRANCH replaymod
git clone https://github.com/FabricMC/fabric.git --branch $FABRIC_API_BRANCH fabric-api

# Cannot use jar-in-jar because we require official-mapped fabric-api
sed -i 's/addNestedDependencies.set(true)/addNestedDependencies.set(false)/' replaymod/versions/common.gradle

# This mixin fails to apply, haven't looked into it as it's not an important one
sed -i 's/"MixinMouse",//' replaymod/src/main/resources/mixins.core.replaymod.json

# Get fabric-api to use our loom
cat fabric-api.patch | git -C fabric-api apply

(cd fabric-loom && ./gradlew publishToMavenLocal)
(cd fabric-loader && ./gradlew remapJar)
(cd fabric-api && ./gradlew remapJar)
(cd replaymod && ./gradlew :$MC:shadowJar)

for f in fabric-loader fabric-api/fabric-api-base fabric-api/fabric-networking-v0 fabric-api/fabric-keybindings-v0 fabric-api/fabric-key-binding-api-v1 fabric-api/fabric-resource-loader-v0 replaymod/versions/$MC; do
    rm -f "$f"/build/libs/*-{dev,obf,raw}.jar
    mv "$f"/build/libs/*.jar ./
done
