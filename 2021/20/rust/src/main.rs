use std::io::{stdin, BufRead};
use std::time::Instant;

fn parse_input() -> (Vec<bool>, Vec<Vec<bool>>) {
    let input: Vec<String> = stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .collect();

    let mut lines = input.iter()
        .peekable();

    let mut algo: Vec<bool> = vec![];
    while let Some(l) = lines.next() {
        if l.is_empty() { break }
        algo.extend(l.chars().map(|c| c == '#').collect::<Vec<bool>>())
    }

    let img = lines
        .map(|l| l.chars().map(|c| c == '#').collect())
        .collect();

    (algo, img)
}

fn show_image(img: &Vec<Vec<bool>>) {
    for y in img {
        for x in y {
            print!("{}", if *x { "#" } else { "." });
        }
        println!();
    }
}

fn get_xy(v: &Vec<Vec<bool>>, x: i32, y: i32, default: bool) -> bool {
    if x < 0 || y < 0 || x >= v[0].len() as i32 || y >= v.len() as i32 { default }
    else { v[y as usize][x as usize] }
}

fn enhance(img: &Vec<Vec<bool>>, algo: &Vec<bool>, default: bool) -> Vec<Vec<bool>> {
    let mut enhanced = vec![vec![default; img.len() + 2]; img[0].len() + 2];
    for y in -1..=img.len() as i32 {
        for x in -1..=img[0].len() as i32 {
            let mut i = 0;
            let mut algo_idx = 0;
            for dy in [1, 0, -1] { for dx in [1, 0, -1] {
                let val = get_xy(img, x as i32 + dx, y as i32 + dy, !default);
                if val { algo_idx += 2_i32.pow(i) }
                i += 1;
            } }

            enhanced[(y + 1) as usize][(x + 1) as usize] = algo[algo_idx as usize];
        }
    }
    enhanced
}

fn n_enhance(img: &Vec<Vec<bool>>, algo: &Vec<bool>, n: usize) -> Vec<Vec<bool>> {
    let mut enhanced = img.clone();
    for i in 0..n { 
        enhanced = enhance(
            &enhanced,
            &algo,
            if i % 2 == 0 { algo[0] } else { algo[511] }
        )
    }
    enhanced
}

fn count_pixels(img: &Vec<Vec<bool>>) -> u32 {
    let mut count = 0;
    for y in 0..img.len() { for x in 0..img[0].len() {
        if img[y][x] { count += 1 }
    } }
    count
}

fn main() {
    let now = Instant::now();
    let (algo, img) = parse_input();
    println!("{:?}", count_pixels(&n_enhance(&img, &algo, 2)));
    println!("{:?}", count_pixels(&n_enhance(&img, &algo, 50)));
    println!("Elapsed: {:?}", now.elapsed());
}
