use std::io::BufRead;
use std::time::Instant;

fn parse_input() -> Vec<Vec<u32>> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|line| line.ok())
        .map(|line| line.chars().map(|i| (i as u32) - 48).collect())
        .collect()
}

fn incr_adjacent(m: &mut Vec<Vec<u32>>, x: usize, y:usize) {
    let xlen = m[0].len();
    let ylen = m.len();
    for dx in 0..=2 {
        for dy in 0..=2 {
            if x+dx <= 0 || x+dx > xlen || y+dy <= 0 || y+dy > ylen { continue }
            m[x+dx-1][y+dy-1] += 1;
        }
    }
}

fn step(octo_pows: &mut Vec<Vec<u32>>) -> u32 {
    let xlen = octo_pows[0].len();
    let ylen = octo_pows.len();

    let mut did_flash = vec![vec![false; xlen]; ylen];
    let mut any_flashes: bool;
    let mut total_flashes = 0;

    // increment each
    for y in 0..ylen { for x in 0..xlen {
        did_flash[x][y] = false;
        octo_pows[x][y] += 1;
    } }

    // count flashes
    any_flashes = true;
    while any_flashes {
        any_flashes = false;

        // sum neighboring flashes 
        for y in 0..ylen { for x in 0..xlen { 
            if !did_flash[x][y] && octo_pows[x][y] > 9 {
                incr_adjacent(octo_pows, x, y);
                did_flash[x][y] = true;
                any_flashes = true;
                total_flashes += 1;
            }
        } }
    }

    // reset flashed 
    for y in 0..ylen { for x in 0..xlen {
        if did_flash[x][y] || octo_pows[x][y] > 9 { octo_pows[x][y] = 0 }
    } }

    total_flashes
}

fn count_octopus_flashes(octo_pows: &Vec<Vec<u32>>, steps: usize) -> u32 {
    let mut o = octo_pows.clone();
    (0..).map(|_| step(&mut o)).take(steps).sum()
}

fn find_octopus_synchronized_flashes(octo_pows: &Vec<Vec<u32>>) -> u32 {
    let mut o = octo_pows.clone();
    let area = (o.len() * o[0].len()) as u32;
    (0..).find(|_| step(&mut o) == area).unwrap()
}

fn main() {
    let now = Instant::now();
    let octos = parse_input();
    println!("{:?}", count_octopus_flashes(&octos, 100));
    println!("{:?}", find_octopus_synchronized_flashes(&octos));
    println!("Elapsed: {:?}", now.elapsed());
}

