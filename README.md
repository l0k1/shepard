# SHEPARD

A minimal Game Boy game.

The goal is to make a game with less than 1024 bytes.

Currently a work-in-progress. Nightly (or weekly) builds will be posted when there's something of note.

### Gameplay

You are a shepard, here to protect your sheep. Monsters lurk in the night, trying to steal them away.
Keep your sheep alive for as long as possible!

### Building

[![Build Status](https://travis-ci.org/l0k1/shepard.svg?branch=master)](https://travis-ci.org/l0k1/shepard)

I try to make sure that building works and is error free before pushing to Github. This isn't always the case, however.

I use RGBDS. I don't plan on porting it to WLA.

Dependencies are [RGBDS](https://github.com/bentley/rgbds) and make.

To make:

    cd ./shepard/
    make

