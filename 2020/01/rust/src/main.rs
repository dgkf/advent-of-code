use std::io::BufRead;
use itertools::Itertools;

fn parse_input() -> std::vec::Vec<u32> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .filter_map(|s| s.trim().parse().ok())
        .collect()
}

fn prod_of_n_which_sum_to_2020(values: &Vec<u32>, n: usize) -> u32 {
    values
        .iter()
        .permutations(n)
        .filter(|p| p.iter().fold(0, |acc, &x| acc + x) == 2020)
        .map(|p| p.iter().fold(1, |acc, &x| acc * x))
        .next()
        .unwrap()
}

fn main() {
    let data = parse_input();
    println!("{}", prod_of_n_which_sum_to_2020(&data, 2));
    println!("{}", prod_of_n_which_sum_to_2020(&data, 3));
}