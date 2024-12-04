use std::{collections::HashMap, io};

fn main() {
    let lines = io::stdin().lines();

    let mut list1: Vec<u32> = vec![];
    let mut list2: Vec<u32> = vec![];

    for line in lines {
        let line = line.unwrap();
        let elems: Vec<_> = line.split_whitespace().take(2).collect();
        list1.push(elems[0].parse().unwrap());
        list2.push(elems[1].parse().unwrap());
    }

    list1.sort();
    list2.sort();

    // part 1
    let part1: u32 = list1
        .iter()
        .zip(list2.iter())
        .map(|(l, r)| l.abs_diff(*r))
        .sum();

    // part 2
    let mut list2counts: HashMap<u32, u32> = HashMap::new();
    for i in list2.iter() {
        list2counts
            .entry(*i)
            .and_modify(|value| *value += 1)
            .or_insert(1);
    }

    let part2: u32 = list1
        .iter()
        .map(|i| i * list2counts.get(i).unwrap_or(&0))
        .sum();

    println!("{part1}");
    println!("{part2}");
}
