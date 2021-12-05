use std::io::BufRead;
use std::str::FromStr;
use std::time::Instant;
use std::collections::HashMap;
use std::cmp::max;

#[derive(Debug, Eq, PartialEq, Hash, Copy, Clone)]
struct Point {
    x: i32,
    y: i32,
}

impl FromStr for Point {
    type Err = Box<dyn std::error::Error>;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let vals: Vec<i32> = s.split(",")
            .map(|c| i32::from_str(c).unwrap())
            .collect();

        Ok(Point{ x: vals[0], y: vals[1] }) 
    }
}

#[derive(Debug, Eq, PartialEq, Copy, Clone)]
struct Line {
    start: Point,
    end: Point,
}

impl FromStr for Line {
    type Err = Box<dyn std::error::Error>;
    fn from_str(line: &str) -> Result<Self, Self::Err> {
        let mut pstr = line.split(" -> ");
        let start = Point::from_str(pstr.next().unwrap()).unwrap();
        let end   = Point::from_str(pstr.next().unwrap()).unwrap();
        Ok(Line{ start, end })
    }
}

fn parse_input() -> Vec<Line> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .map(|l| Line::from_str(&l).unwrap())
        .collect()
}

fn filter_horz_vert(lines: &Vec<Line>) -> Vec<Line> {
    lines.into_iter()
        .map(|v| *v)
        .filter(|l| l.start.x == l.end.x || l.start.y == l.end.y)
        .collect()
}

fn count_overlaps(lines: Vec<Line>) -> u32 {
    let mut counts: HashMap<Point, u32> = HashMap::new();
    let mut len: i32;
    let mut p = Point{ x: 0, y: 0 };

    for l in lines {
        len = max((l.end.x - l.start.x).abs(), (l.end.y - l.start.y).abs());
        for i in 0..=len {
            p.x = l.start.x + (i as i32) * (l.end.x - l.start.x) / len;
            p.y = l.start.y + (i as i32) * (l.end.y - l.start.y) / len;
            counts.insert(p, counts.get(&p).unwrap_or(&0) + 1);
        }
    }
    
    counts.values().filter(|v| **v > 1).count() as u32
}

fn main() {
    let now = Instant::now();
    let lines = parse_input();
    println!("{:?}", count_overlaps(filter_horz_vert(&lines)));
    println!("{:?}", count_overlaps(lines));
    println!("Elapsed: {:?}", now.elapsed());
}

