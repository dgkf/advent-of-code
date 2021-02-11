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
    for p in values.iter().permutations(n) {
        if p.into_iter().sum::<u32>() == 2020 {
            return &p.into_iter().product::<u32>()
        }
    }
    return 0
}

fn main() {
    let data = parse_input();
    println!("{}", prod_of_n_which_sum_to_2020(&data, 2));
    println!("{}", prod_of_n_which_sum_to_2020(&data, 3));
}