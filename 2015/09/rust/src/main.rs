use std::io::BufRead;
use std::collections::BTreeMap;
use itertools::Itertools;
use regex::Regex;

fn parse_dists() -> BTreeMap<Vec<String>, i32> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|l| l.ok())
        .map(|l| parse_town_edge(l))
        .collect()
}

fn parse_town_edge(s: String) -> (Vec<String>, i32) {
    let re = Regex::new(r"(?P<s>\w+) to (?P<e>\w+) = (?P<d>\d+)").unwrap();
    let cap = re.captures(&s).unwrap();

    let mut towns = Vec::new();
    towns.push(String::from(&cap["s"]));
    towns.push(String::from(&cap["e"]));
    towns.sort();

    let dist = String::from(&cap["d"]).parse::<i32>().unwrap();

    (towns, dist)
}

fn unique_towns(x: &BTreeMap<Vec<String>, i32>) -> Vec<String> {
    let mut towns: Vec<String> = Vec::new();
    for k in x.keys().cloned().collect_vec() {
        towns.extend(k);
    }
    towns.iter().cloned().unique().collect_vec()
}

fn path_distances(x: BTreeMap<Vec<String>, i32>) -> Vec<i32> {
    let towns = unique_towns(&x);
    let mut dists: Vec<i32> = vec![];
    let mut leg: Vec<String> = vec!["".to_string(); 2];
    for p in towns.iter().permutations(towns.len()) {
        let mut dist: i32 = 0;
        for (i, &start) in p[..p.len()-1].iter().enumerate() {
            let end = p[i+1];
            leg[0] = (&start).to_string();
            leg[1] = (&end).to_string();
            leg.sort();
            dist += x.get(&leg).unwrap();
        }
        dists.push(dist);
    }
    dists
}

fn main() {
    let dists = path_distances(parse_dists());
    println!("{:?}", dists.iter().min().unwrap());
    println!("{:?}", dists.iter().max().unwrap());
}
