use std::io::{stdin, BufRead};
use std::time::Instant;
use std::collections::HashMap;

fn parse_input() -> (String, HashMap<[char; 2], char>) {
    let lines = stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .collect::<Vec<String>>();
    
    let mut lines_iter = lines.iter();
    let template: String = String::from(lines_iter.next().unwrap());
    let inserts: HashMap<[char; 2], char> = lines_iter
        .skip(1)
        .map(|i| {
            let mut cs = i.split(" -> ");
            let mut first = cs.next().unwrap().chars();
            let mut last  = cs.next().unwrap().chars();
            ([first.next().unwrap(), first.next().unwrap()], last.next().unwrap())
        })
        .collect();

    (template, inserts)
}

fn step(t: &mut String, inserts: &HashMap<[char; 2], char>) -> () {
    let z: Vec<char> = t.chars().collect::<Vec<char>>()
        .windows(2)
        .map(|i| *inserts.get(i).unwrap())
        .collect();

    *t = t.chars()
        .zip(z)
        .flat_map(|(a, b)| [a, b])
        .chain(t.chars().last())
        .collect::<String>()
}

fn count_chars(t: &String) -> HashMap<char, u32> {
    let mut counter: HashMap<char, u32> = HashMap::new();
    for c in t.chars() {
        if let Some(x) = counter.get_mut(&c) { *x += 1; } 
        else { counter.insert(c, 1); }
    }
    counter
}

fn score_polymer(t: &String) -> u32 {
    let counter = count_chars(&t);
    let n_most_common = counter.values().max().unwrap();
    let n_least_common = counter.values().min().unwrap();
    n_most_common - n_least_common
}

fn n_steps_naive(t: &String, inserts: &HashMap<[char; 2], char>, n: usize) -> String {
    let mut t = t.clone();
    for _ in 0..n { step(&mut t, &inserts); }
    t
}

fn n_steps(t: &String, pairs: &HashMap<[char; 2], [[char; 2]; 2]>, n: usize) -> u64 {
    // count pairs in t
    let mut counter: HashMap<[char; 2], u64> = HashMap::new();
    for p in pairs.keys() { counter.insert(*p, 0); }
    for p in t.chars().collect::<Vec<char>>().windows(2) {
        counter.insert([p[0], p[1]], 1); 
    }

    // for each pair in t, add in new entries after iteration
    for _ in 0..n {
        let mut next_iter_counter: HashMap<[char; 2], u64> = HashMap::new(); 

        for (pair, count) in counter.iter() {
            if let Some([l, r]) = pairs.get(pair) {
                let next_l = next_iter_counter.entry(*l).or_insert(0);
                *next_l += count;

                let next_r = next_iter_counter.entry(*r).or_insert(0);
                *next_r += count;
            }
        }

        counter = next_iter_counter.clone();
    }

    let letter_counts: Vec<(char, u64)> = counter.iter()
        .map(|(k, v)| (k[0], *v))
        .chain([(t.chars().last().unwrap(), 1)])
        .collect();

    let mut letter_count_map: HashMap<char, u64> = HashMap::new();
    for (c, count) in letter_counts {
        let c_count = letter_count_map.entry(c).or_insert(0);
        *c_count += count;
    }

    let n_most_common = letter_count_map.values().max().unwrap();
    let n_least_common = letter_count_map.values().min().unwrap();
    n_most_common - n_least_common
}

fn build_pair_map(m: &HashMap<[char; 2], char>) -> HashMap<[char; 2], [[char; 2]; 2]> {
    let mut pair_map: HashMap<[char;2], [[char;2];2]> = HashMap::new();
    for k in m.keys() { pair_map.insert(*k, [[k[0], m[k]], [m[k], k[1]]]); }
    pair_map
}

fn main() {
    let now = Instant::now();
    let (template, inserts) = parse_input();
    let pairs = build_pair_map(&inserts);
    println!("{:?}", score_polymer(&n_steps_naive(&template, &inserts, 10)));
    println!("{:?}", n_steps(&template, &pairs, 40));
    println!("Elapsed: {:?}", now.elapsed());
}
