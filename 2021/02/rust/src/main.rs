use std::io::BufRead;
use std::str::FromStr;
use strum_macros::Display;
use strum_macros::EnumString;

#[derive(Debug, Eq, PartialEq, EnumString, Display)]
#[strum(serialize_all = "lowercase")]
enum Direction {
    Up,
    Forward,
    Down,
    Backward,
}

#[derive(Debug, PartialEq)]
struct Movement {
    dir: Direction,
    x: i32
}

impl FromStr for Movement {
    type Err = Box<dyn std::error::Error>;
    fn from_str(line: &str) -> Result<Self, Self::Err> {
        let mut strs = line.split(" ");
        let dir: Direction = strs.next().unwrap().parse()?;
        let x: i32         = strs.next().unwrap().parse()?;
        Ok(Movement{ dir, x })
    }
}

fn parse_input() -> Vec<Movement> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|l| Some(Movement::from_str(&l.unwrap()).unwrap()))
        .collect()
}

fn apply_movements(moves: &Vec<Movement>) -> Vec<i32> {
    let mut x: i32 = 0;
    let mut y: i32 = 0;

    for m in moves {
        match m.dir {
            Direction::Forward  => x += m.x,
            Direction::Backward => x -= m.x,
            Direction::Up       => y += m.x,
            Direction::Down     => y -= m.x,
        };
    };

    vec![x, y]
}

fn apply_movements_with_aim(moves: &Vec<Movement>) -> Vec<i32> {
    let mut x: i32 = 0;
    let mut y: i32 = 0;
    let mut aim: i32 = 0;

    for m in moves {
        match m.dir {
            Direction::Forward  => { x += m.x; y -= aim * m.x },
            Direction::Backward => { x -= m.x; y += aim * m.x },
            Direction::Up       => aim -= m.x,
            Direction::Down     => aim += m.x,
        };
    };

    vec![x, y]
}

fn main() {
    let data = parse_input();
    let pos = apply_movements(&data);
    let pos_w_aim = apply_movements_with_aim(&data);
    println!("{:?}", pos[0] * -pos[1]);
    println!("{:?}", pos_w_aim[0] * -pos_w_aim[1]);
}

