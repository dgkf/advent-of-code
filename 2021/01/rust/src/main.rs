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
    values.iter().fold(vec![0, 10000], |acc, &r| {
      vec![acc[0] + u32::from(r > acc[1]), r]
    })[0]
}

fn sliding_window(values: &Vec<u32>) -> Vec<u32> {
    values.iter()
        .enumerate()
        .take(values.len() - 2)
        .map(|i| i.1 + values[i.0+1] + values[i.0+2])
        .collect()
}

fn main() {
    let data = parse_input();
    let n_increasing = count_increasing(&data);
    let sliding_n_increasing = count_increasing(&sliding_window(&data));
    println!("{:?}", &n_increasing);
    println!("{:?}", &sliding_n_increasing);
}
