use std::io::BufRead;
use std::time::Instant;
use std::str::FromStr;

fn parse_input() -> Vec<i32> {
    let line = std::io::stdin().lock().lines().next().unwrap().unwrap();
    let mut data: Vec<i32> = line.split(",")
        .map(|c| i32::from_str(c).unwrap())
        .collect();

    data.sort();
    return data
}

fn horz_pos_median(crabs: &Vec<i32>) -> i32 {
    crabs.iter()
        .map(|i| (i - crabs[crabs.len() / 2]).abs())
        .sum()
}

fn horz_pos_crab_logic(crabs: &Vec<i32>) -> i32 {
    crabs.iter()
        .map(|c| crabs.iter().map(|i| (i - c).abs() * ((i - c).abs() + 1) / 2).sum())
        .min()
        .unwrap()
}

fn main() {
    let now = Instant::now();
    let crabs = parse_input();
    println!("{:?}", horz_pos_median(&crabs));
    println!("{:?}", horz_pos_crab_logic(&crabs));
    println!("Elapsed: {:?}", now.elapsed());
}
