# Rocketry - A Sample Rust/Rocket Application with Habitat Plan

[![Build Status](https://travis-ci.org/fnichol/rocketry.svg?branch=master)](https://travis-ci.org/fnichol/rocketry) [![license](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/fnichol/rocketry/blob/master/LICENSE-MIT)

This is a small sample web application written in [Rust](https://www.rust-lang.org/en-US/) using the [Rocket](https://rocket.rs/) project and includes a [Habitat](https://www.habitat.sh/) Plan which can build this into a package.

* It takes one optional command line argument which is a port number to use, otherwise defaulting to `8000` so that it can run without root permissions.
* The simple Rocket application is setup to run in "production" mode and will skip all `Rocket.toml` and environment variables. This isn't a requirement per se, but illustrative of how Habitat can manage these details dynamically on behalf of a service.
* The Habitat Plan builds a statically linked, relocatable binary for its package using a [musl](https://www.musl-libc.org/) target.

## Pre-requisites

This project requires using a Nightly version of Rust, which you can install using [rustup](https://www.rustup.rs/) with:

```sh
curl https://sh.rustup.rs -sSf | sh
rustup install nightly
cd rocketry
rustup override set nightly
```

## Building

### Development

Building this project should be fairly straight forward as there aren't any system dependencies required:

```sh
cargo build
```

To compile a production-ready binary, you can add the `--release` flag:

```sh
cargo build --release
```

### Habitat

You can follow the instructions on the [Habitat website](https://www.habitat.sh/tutorials/download/) to get set up and then, from the git checkout directory, run:

```sh
hab pkg build .
```

This will produce a Habitat package in the `./results/` directory.

## Running

### Development

You can either use `cargo run` to try it out:

```sh
# You can use -- as the delimter for your program to recieve arguments
cargo run -- 9000
```

Or run the binary directly which is in the `./target/` directory. Assuming it's not a release build:

```sh
./target/debug/rocketry
```

Or to override the default listen port:

```sh
./target/debug/rocketry 9000
```

### Habitat

To enter a quick environment suitable for trying out your Habitat package, you can enter an interactive Studio with:

```sh
hab studio enter
```

and either rebuild your project (with `build .`) or install the package you made with:

```
hab install ./results/*-rocketry-*.hart
```

Finally, start the service with:

```sh
hab start <yourorigin>/rocketry
```

where `<yourorigin>` is your origin name you chose when you set up Habitat on your system.
