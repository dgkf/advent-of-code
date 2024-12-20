use std::io;
use std::io::Read;

pub fn input_lines_iter() -> impl Iterator<Item = String> {
    io::stdin().lines().take_while(|i| i.is_ok()).flatten()
}

pub fn input() -> String {
    let mut buf = vec![];
    std::io::stdin().read_to_end(&mut buf).unwrap_or_default();
    String::from_utf8_lossy(&buf).into_owned()
}
