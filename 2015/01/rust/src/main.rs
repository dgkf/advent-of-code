use std::io::BufRead;
use itertools::Itertools;
use itertools::enumerate;

fn parse_input() -> Vec<i32> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|c| c.ok())
        .join("")
        .chars()
        .map(|c| if c == '(' { 1 } else { -1 })
        .collect()
}

fn part1(data: &Vec<i32>) -> i32 {
    data.iter().sum()
}

fn part2(data: &Vec<i32>) -> Option<usize> {
    let mut acc : i32 = 0; 
    for (i, val) in enumerate(data) {
        acc += val;
        if acc < 0 { 
            return Some(i + 1);
        }
    }
    return None;
}

fn main() {
    let data = parse_input();
    println!("{:?}", part1(&data));
    println!("{:?}", part2(&data).unwrap());
}
