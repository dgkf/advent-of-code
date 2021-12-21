use std::io::{stdin, BufRead};
use std::time::Instant;
use std::str::FromStr;

fn parse_input() -> (u8, u8) {
    let pos: Vec<u8> = stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .map(|l| u8::from_str(l.rsplit_once(' ').unwrap().1).unwrap())
        .collect::<Vec<u8>>();

    (pos[0] - 1, pos[1] - 1)
}

fn naive(pos1: u8, pos2: u8) -> u64 {
    let mut pos1 = pos1;
    let mut pos2 = pos2;
    let mut score1: u64 = 0;
    let mut score2: u64 = 0;

    let die_vals = (1..=100).collect::<Vec<u32>>();
    let mut die = die_vals.iter().cycle();
    let mut die_count: u64 = 0;

    loop {
        let rolls = die.next().unwrap() + die.next().unwrap() + die.next().unwrap();
        die_count += 3;
        pos1 = ((pos1 as u32 + rolls) % 10) as u8;
        score1 += (pos1 + 1) as u64;
        if score1 > 1000 { break } 

        let rolls = die.next().unwrap() + die.next().unwrap() + die.next().unwrap();
        die_count += 3;
        pos2 = ((pos2 as u32 + rolls) % 10) as u8;
        score2 += (pos2 + 1) as u64;
        if score2 > 1000 { break } 
    }

    std::cmp::min(score1, score2) * die_count
}

// -> (player1 wins, player2 wins)
fn multiverse(count: u64, pos1: u8, score1: u8, pos2: u8, score2: u8) -> (u64, u64) {
    const ROLLS: [u8; 10] = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1];

    if score1 >= 21 { return (count, 0) }
    if score2 >= 21 { return (0, count) }

    let mut wins1 = 0;
    let mut wins2 = 0;

    for (i, &roll) in ROLLS.iter().enumerate().skip(3) {
        let next_pos1 = (pos1 + i as u8) % 10;
        let next_score1 = score1 + next_pos1 + 1;
        let count_mult = roll as u64;

        // swap player positions to alternate player turns
        let (next_wins2, next_wins1) = multiverse(
            count * count_mult,
            pos2, score2,
            next_pos1, next_score1
        );

        wins1 += next_wins1;
        wins2 += next_wins2;
    }

    (wins1, wins2)
}

fn most_multiverse_wins(pos1: u8, pos2: u8) -> u64 {
    let (wins1, wins2) = multiverse(1, pos1, 0, pos2, 0);
    std::cmp::max(wins1, wins2)
}

fn main() {
    let now = Instant::now();
    let (pos1, pos2) = parse_input();
    println!("{}", naive(pos1, pos2));
    println!("{}", most_multiverse_wins(pos1, pos2));
    println!("Elapsed: {:?}", now.elapsed());
}
