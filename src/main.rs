#![feature(plugin, decl_macro)]
#![plugin(rocket_codegen)]

extern crate rocket;

use std::env;
use std::process;

use rocket::config::Config;

const DEFAULT_PORT: u16 = 8000;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

fn main() {
    rocket::custom(config(), true)
        .mount("/", routes![index])
        .launch();
}

fn config() -> Config {
    let mut config = Config::production().expect("Cannot prepare Rocket config");
    let port = match env::args().nth(1) {
        Some(port_str) => {
            match port_str.parse::<u16>() {
                Ok(port) => port,
                Err(err) => {
                    eprintln!(
                        "usage: {} [PORT] (err={:?})",
                        env::current_exe().unwrap().display(),
                        err
                    );
                    process::exit(1);
                }
            }
        }
        None => DEFAULT_PORT,
    };
    config.set_port(port);
    config
}
