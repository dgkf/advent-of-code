use std::io::BufRead;
use std::collections::BTreeMap;
use std::collections::BTreeSet;
use itertools::Itertools;
use regex::Regex;

fn parse_town_edge(s: String) -> (BTreeSet<String>, i32) {
    let re = Regex::new(r"(?P<s>\w+) to (?P<e>\w+) = (?P<d>\d+)").unwrap();
    let cap = re.captures(&s).unwrap();
    let mut set = BTreeSet::new();
    set.insert(String::from(&cap["s"]));
    set.insert(String::from(&cap["e"]));
    (set, String::from(&cap["d"]).parse::<i32>().unwrap())
}

fn parse_dists() -> BTreeMap<BTreeSet<String>, i32> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|l| l.ok())
        .map(|l| parse_town_edge(l))
        .collect()
}

fn unique_towns(x: BTreeMap<BTreeSet<String>, i32>) -> BTreeSet<String> {
    x.keys()
        .into_iter()
        .fold(BTreeSet::new(), |l, r| l.union(&r).cloned().collect())
}

fn path_distances(x: BTreeMap<BTreeSet<String>, i32>) -> Vec<i32> {
    let towns = unique_towns(x);
    println!("{:?}", towns);
    let mut dists: Vec<i32> = vec![];
    for p in towns.iter().permutations(towns.len()) {
        let mut dist: i32 = 0;
        for (i, start) in p[..p.len()-1].iter().enumerate() {
            let end = p[i+1];
            println!("{:?}", (start, end));
            // dist += x.get((start, end));
        }
        dists.push(dist);
    }
    vec![3, 4]
}

fn main() {
    let dists = parse_dists();
    path_distances(dists);
    // println!("{:?}", dists);
}

