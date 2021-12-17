use std::io::{stdin, BufRead};
use std::time::Instant;
use regex::Regex;

fn parse_input() -> Option<((i32, i32), (i32, i32))> {
    let re  = Regex::new(r"-?\d+").unwrap();
    let line = stdin().lock().lines().next().unwrap().unwrap();
    let mut matches = re.find_iter(&line);
    let xmin = matches.next().unwrap().as_str().parse().ok()?;
    let xmax = matches.next().unwrap().as_str().parse().ok()?;
    let ymin = matches.next().unwrap().as_str().parse().ok()?;
    let ymax = matches.next().unwrap().as_str().parse().ok()?;
    Some(((xmin, xmax), (ymin, ymax)))
}

fn max_y(ymin: i32) -> i32 {
    let mut max_y: i32 = 0;
    for i in 1..(-ymin) { max_y += i }
    max_y
}

fn n_distinc_initial_velocities(xmin: i32, xmax: i32, ymin: i32, ymax: i32) -> i32 {
    let mut n: i32 = 0;
    for xv in 1..=xmax {
        for yv in ymin..=(-ymin) {
            let (mut x, mut y) = (0, 0);
            let (mut xvel, mut yvel) = (xv, yv);
            while y >= ymin && x <= xmax {
                x += xvel;
                y += yvel;
                if xvel > 0 { xvel -= 1 };
                yvel -= 1;
                if x >= xmin && x <= xmax && y >= ymin && y <= ymax { 
                    n += 1;
                    break
                }
            }
        }
    }
    n
}

fn main() {
    let now = Instant::now();
    if let Some(((xmin, xmax), (ymin, ymax))) = parse_input() {
        println!("{:?}", max_y(ymin));
        println!("{:?}", n_distinc_initial_velocities(xmin, xmax, ymin, ymax));
    }
    println!("Elapsed: {:?}", now.elapsed());
}
