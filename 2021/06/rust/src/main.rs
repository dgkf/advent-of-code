use std::io::BufRead;
use std::time::Instant;
use std::str::FromStr;

fn parse_input() -> Vec<u8> {
    let line = std::io::stdin().lock().lines().next().unwrap().unwrap();
    line.split(",").map(|c| u8::from_str(c).unwrap()).collect()
}

fn fish_growth(fish: &Vec<u8>, day: u32) -> u64 {
     let mut counter: Vec<u64> = vec![0; 9];
     let mut zeros: u64;
     
     // initialize counter with input
     for f in fish {
         counter[*f as usize] += 1;
     }

     for _ in 1..=day {
         // store number of zeroes at the start of the day
         zeros = counter[0];

         // shift counters down
         for i in 0..(counter.len()-1) {
             counter[i] = counter[i + 1];
         }

         // for each 0, add a new 8
         counter[8] = zeros;

         // for each 0, add a new 6
         counter[6] += zeros;
     }

     counter.iter().sum()
}

fn main() {
    let now = Instant::now();
    let fish = parse_input();
    println!("{:?}", fish_growth(&fish, 80));
    println!("{:?}", fish_growth(&fish, 256));
    println!("Elapsed: {:?}", now.elapsed());
}


