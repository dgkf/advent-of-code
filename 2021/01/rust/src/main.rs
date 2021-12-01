use std::io::BufRead;

fn parse_input() -> Vec<u32> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .filter_map(|s| s.trim().parse().ok())
        .collect()
}

fn count_increasing(values: &Vec<u32>) -> u32 {
    values.iter()
        .enumerate()
        .take(values.len() - 1)
        .map(|(i, val)| u32::from(val < &values[i + 1]))
        .sum()
}

fn sliding_window(values: &Vec<u32>) -> Vec<u32> {
    values.iter()
        .enumerate()
        .take(values.len() - 2)
        .map(|(i, val)| val + values[i + 1] + values[i + 2])
        .collect()
}

fn main() {
    let data = parse_input();
    let n_increasing = count_increasing(&data);
    let sliding_n_increasing = count_increasing(&sliding_window(&data));
    println!("{:?}", &n_increasing);
    println!("{:?}", &sliding_n_increasing);
}
