use std::io::BufRead;
use std::time::Instant;

fn parse_input() -> Vec<Vec<bool>> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .map(|s| s.chars().map(|c| c == '1').collect())
        .collect()
}

fn power_consumption(data: &Vec<Vec<bool>>) -> u32 {
    let data_len: u32 = data.len() as u32;
    let mut gamma: u32 = 0;
    let mut epsilon: u32 = 0;

    let mut bit: usize = &data[0].len() - 1;
    let mut bit_val: u32 = 1;
    let mut bit_n: u32;

    loop {
        bit_n = data.iter().map(|row| row[bit] as u32).sum();
        if bit_n * 2 > data_len { gamma += bit_val } 
        else { epsilon += bit_val }

        if bit == 0 { break }
        bit -= 1;
        bit_val *= 2;
    }

    gamma * epsilon
}

fn bool_vec_to_value(data: &Vec<bool>) -> u32 {
    let mut value: u32 = 0;
    let mut bit: usize = &data.len() - 1;
    let mut bit_val: u32 = 1;

    loop {
        if data[bit] { value += bit_val };
        if bit == 0 { break }
        bit -= 1;
        bit_val *= 2;
    }

    return value
}

fn rating(data: &Vec<Vec<bool>>, cmp: fn(u32, u32) -> bool) -> u32 {
    let mut mask: Vec<bool> = vec![true; data.len()];
    let mut bit: usize = 0;
    let mut mask_n: u32;
    let mut bit_n: u32;

    loop {
        mask_n = mask.iter().filter(|i| **i).count() as u32;
        if mask_n <= 1 { 
            let rating_pos = mask.iter().position(|&i| i).unwrap();
            return bool_vec_to_value(&data[rating_pos]);
        }

        // count most common bit
        bit_n = 0;
        for (i, row) in data.iter().enumerate() {
            if !mask[i] { continue }
            if row[bit] { bit_n += 1 }
        }

        // apply next mask
        for (i, row) in data.iter().enumerate() {
            if !mask[i] { continue }
            mask[i] = row[bit] == cmp(bit_n * 2, mask_n);
        }

        bit += 1;
    }
}

fn oxygen_rating(data: &Vec<Vec<bool>>) -> u32 {
    rating(&data, |bit_count, mask_count_half| bit_count >= mask_count_half)
}

fn co2_rating(data: &Vec<Vec<bool>>) -> u32 {
    rating(&data, |bit_count, mask_count_half| bit_count < mask_count_half)
}

fn life_support_rating(data: &Vec<Vec<bool>>) -> u32 {
    oxygen_rating(&data) * co2_rating(&data)
}

fn main() {
    let now = Instant::now();
    let data = parse_input();
    println!("{:?}", power_consumption(&data));
    println!("{:?}", life_support_rating(&data));
    println!("Elapsed: {:?}", now.elapsed());
}
