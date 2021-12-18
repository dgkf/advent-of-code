use std::io::{stdin, BufRead};
use std::time::Instant;
use std::str::FromStr;

#[derive(Debug, Clone)]
struct SnailfishVal {
    depth: u32,
    val: u32,
}

#[derive(Debug, Clone)]
struct SnailfishNumber {
    vals: Vec<SnailfishVal>,
}

fn reduce_snailfish_number(s: SnailfishNumber) -> SnailfishNumber {
    let mut s = s;
    let mut i: usize;
    let mut modified = true;

    while modified {
        modified = false;

        i = 0;
        while i < s.vals.len() - 1 {
            if s.vals[i].depth > 4 && s.vals[i+1].depth == s.vals[i].depth {
                // explode
                if i > 0 { s.vals[i-1].val += s.vals[i].val } 
                if i+2 < s.vals.len() { s.vals[i+2].val += s.vals[i+1].val } 
                s.vals.remove(i);
                s.vals[i].depth -= 1;
                s.vals[i].val = 0;
                if i > 0 { i -= 1; }
                modified = true;
            } else {
                i += 1;
            }
        }

        i = 0;
        while !modified && i < s.vals.len() {
            if s.vals[i].val > 9 {
                // split
                s.vals[i].depth += 1;
                let mut right = s.vals[i].clone();
                right.val /= 2;
                right.val += s.vals[i].val % 2;
                s.vals[i].val /= 2;
                s.vals.insert(i + 1, right);
                modified = true;
            } else {
                i += 1;
            }
        }
    }

    s
}

impl FromStr for SnailfishNumber {
    type Err = std::string::ParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut next_val = SnailfishVal{ depth: 0, val: 0 };
        let mut vals: Vec<SnailfishVal> = vec![];

        for c in s.chars() {
            match c {
                '[' => next_val.depth += 1,
                ']' => next_val.depth -= 1,
                ',' => { },
                num => { 
                    next_val.val = num as u32 - b'0' as u32; 
                    vals.push(next_val.clone());
                }
            }
        }

        Ok(reduce_snailfish_number(SnailfishNumber{ vals }))
    }
}

fn snailfish_add(l: &SnailfishNumber, r: &SnailfishNumber) -> SnailfishNumber {
    let mut l = l.clone();
    let mut r = r.clone();
    for i in 0..l.vals.len() { l.vals[i].depth += 1 };
    for i in 0..r.vals.len() { r.vals[i].depth += 1 };
    l.vals.extend(r.vals);
    reduce_snailfish_number(l)
}

fn parse_input() -> Vec<SnailfishNumber> {
    stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .map(|i| SnailfishNumber::from_str(&i).unwrap())
        .collect()
}

fn snailfish_magnitude(s: &SnailfishNumber) -> u32 {
    let mut sum = 0;
    let mut pair_left = vec![];

    for i in 0..s.vals.len() {
        if pair_left.is_empty() {
            pair_left.extend(vec![1; s.vals[i].depth as usize]);
        } else {
            while let Some(last) = pair_left.pop() {
                if last == 1 { pair_left.push(0); break }
            }
            while (pair_left.len() as u32) < s.vals[i].depth { 
                pair_left.push(1); 
            }
        }

        let threes = pair_left.iter().sum();
        let twos   = (pair_left.len() as u32) - threes;
        sum += s.vals[i].val * 3_u32.pow(threes) * 2_u32.pow(twos)
    }
    sum
}

fn snailfish_largest_pair_magnitude(s: &[SnailfishNumber]) -> u32 {
    let mut mag_max = 0;
    for l in 0..s.len() { for r in 0..s.len() {
        if r == l { continue }
        let mag = snailfish_magnitude(&snailfish_add(&s[l], &s[r]));
        if mag > mag_max { mag_max = mag }
    } }
    mag_max
}

fn main() {
    let now = Instant::now();
    let input = parse_input();
    println!("{:?}", snailfish_magnitude(&input.iter().cloned().reduce(|l, r| snailfish_add(&l, &r)).unwrap()));
    println!("{:?}", snailfish_largest_pair_magnitude(&input));
    println!("Elapsed: {:?}", now.elapsed());
}

