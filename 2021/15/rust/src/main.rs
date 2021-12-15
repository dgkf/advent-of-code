use std::io::{stdin, BufRead};
use std::time::Instant;
use std::collections::HashMap;
use petgraph::graphmap::DiGraphMap;
use petgraph::algo::astar;

fn parse_input() -> ((DiGraphMap<(usize, usize), u32>, (usize, usize)), (DiGraphMap<(usize, usize), u32>, (usize, usize))) {
    let mut w = HashMap::new();
    let lines: Vec<String> = stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .collect();

    // creating original graph
    let mut g = DiGraphMap::new();  // original cave
    let mut size = (0, 0);
    for (y, l) in lines.iter().enumerate() {
        size.1 = y;
        for (x, val) in l.chars().enumerate() {
            size.0 = x;
            w.insert((x, y), val as u32 - b'0' as u32);
        }
    }

    for from in w.keys() {
        g.add_node((from.0, from.1));
    }

    for (x, y) in w.keys() {
        let from = (*x, *y);
        let from_w = w.get(&from).unwrap();
        for dx in [0, 2] { 
            if x + dx == 0 || x + dx > size.0 { continue }
            let to = (*x + dx - 1, *y);
            g.add_edge(from, to, *w.get(&to).unwrap());
            g.add_edge(to, from, *from_w);
        }

        for dy in [0, 2] {
            if y + dy == 0 || y + dy > size.1 { continue }
            let to = (*x, *y + dy - 1);
            g.add_edge(from, to, *w.get(&to).unwrap());
            g.add_edge(to, from, *from_w);
        }
    }

    // creating expanded graph
    let mut eg = DiGraphMap::new(); // expanded cave
    let esize = ((size.0 + 1) * 5 - 1, (size.1 + 1) * 5 - 1);
    
    let weight_at = |n: (usize, usize)| {
        let orig_n = (n.0 % (size.0 + 1), n.1 % (size.1 + 1));
        let mut weight = *w.get(&orig_n).unwrap();
        weight += (n.0 as u32) / (size.0 as u32 + 1);
        weight += (n.1 as u32) / (size.1 as u32 + 1);
        (weight - 1) % 9 + 1
    };

    for x in 0..=esize.0 { for y in 0..=esize.1 {
        eg.add_node((x, y));
    } }

    for x in 0..=esize.0 { for y in 0..=esize.1 {
        let from = (x, y);
        for dx in [0, 2] {
            if x + dx == 0 || x + dx > esize.0 { continue }
            let to = (x + dx - 1, y);
            eg.add_edge(from, to, weight_at(to));
            eg.add_edge(to, from, weight_at(from));
        }

        for dy in [0, 2] {
            if y + dy == 0 || y + dy > esize.1 { continue }
            let to = (x, y + dy - 1);
            eg.add_edge(from, to, weight_at(to));
            eg.add_edge(to, from, weight_at(from));
        }
    } }

    ((g, size), (eg, esize))
}

fn shortest_path_risk(g: &DiGraphMap<(usize, usize), u32>, size: &(usize, usize)) -> u32 {
    let start = (0, 0);
    let goal  = (size.1, size.1);

    let is_finished = |finish| finish == goal;
    if let Some((risk, _path)) = astar(g, start, is_finished, |(_from, _to, w)| *w, |_| 0) {
        return risk
    }

    0
}

fn main() {
    let now = Instant::now();
    let ((g, size), (eg, esize)) = parse_input();
    println!("{:?}", shortest_path_risk(&g, &size));
    println!("{:?}", shortest_path_risk(&eg, &esize));
    println!("Elapsed: {:?}", now.elapsed());
}
