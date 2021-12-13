use std::io::{stdin, BufRead};
use std::cmp::max;
use std::time::Instant;
use std::collections::HashMap;
use std::str::FromStr;
use regex::Regex;

#[derive(Debug)]
enum Fold {
    X(u32),
    Y(u32),
}

fn parse_input() -> (HashMap<(u32, u32), bool>, Vec<Fold>) {
    let re_point = Regex::new(r"^(?P<x>\d+),(?P<y>\d+)$").unwrap();
    let re_fold  = Regex::new(r"^fold along (?P<dir>x|y)=(?P<loc>\d+)$").unwrap();

    let mut points: HashMap<(u32, u32), bool> = HashMap::new();
    let mut folds: Vec<Fold> = vec![];

    let input = stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .collect::<Vec<String>>();

    for line in input { 
        if let Some(cap) = re_point.captures(&line) {
            let x = u32::from_str(&cap.name("x").unwrap().as_str()).unwrap();
            let y = u32::from_str(&cap.name("y").unwrap().as_str()).unwrap();
            points.insert((x, y), true);
            continue;
        }

        if let Some(cap) = re_fold.captures(&line) {
            let dir = cap.name("dir").unwrap().as_str();
            let loc = u32::from_str(&cap.name("loc").unwrap().as_str()).unwrap();
            match dir {
                "x" => folds.push(Fold::X(loc)),
                "y" => folds.push(Fold::Y(loc)),
                _   => {},
            }
            continue;
        }
    }

    (points, folds)
}

fn do_fold(g: &mut HashMap<(u32, u32), bool>, fold: &Fold) -> () {
    match fold {
        Fold::X(loc) => {
            for k in g.clone().keys() {
                if k.0 < *loc { continue } 
                g.remove(k).unwrap();
                g.insert((loc - (k.0 - loc), k.1), true);
            }
        },
        Fold::Y(loc) => {
            for k in g.clone().keys() {
                if k.1 < *loc { continue } 
                g.remove(k).unwrap();
                g.insert((k.0, loc - (k.1 - loc)), true);
            }
        },
    }
}

fn do_one_fold(g: &HashMap<(u32, u32), bool>, folds: &Vec<Fold>) -> usize {
    let mut g = g.clone();
    do_fold(&mut g, &folds[0]);
    g.len()
}

fn print_points(g: &HashMap<(u32, u32), bool>) {
    let mut xmax: u32 = 0;
    let mut ymax: u32 = 0;

    for k in g.keys() {
        xmax = max(xmax, k.0);
        ymax = max(ymax, k.1);
    }

    for y in 0..=ymax { 
        for x in 0..=xmax {
            if g.contains_key(&(x as u32, y as u32)) { print!("#") } 
            else { print!(" ") }
        } println!("") 
    }
}

fn do_folds(g: &HashMap<(u32, u32), bool>, folds: &Vec<Fold>) -> HashMap<(u32, u32), bool> {
    let mut g = g.clone();
    for f in folds { do_fold(&mut g, f); }
    g
}

fn main() {
    let now = Instant::now();
    let (points, folds) = parse_input();
    println!("{:?}", do_one_fold(&points, &folds));
    print_points(&do_folds(&points, &folds));
    println!("Elapsed: {:?}", now.elapsed());
}
