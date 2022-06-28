#[macro_use]
extern crate rocket;

use std::env;
use std::process;

use rocket::figment::Figment;

const DEFAULT_PORT: u16 = 8000;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[rocket::main]
async fn main() -> Result<(), rocket::Error> {
    let _rocket = rocket::custom(figment())
        .mount("/", routes![index])
        .launch()
        .await?;
    Ok(())
}

fn figment() -> Figment {
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

    rocket::Config::figment().merge(("port", port))
}
