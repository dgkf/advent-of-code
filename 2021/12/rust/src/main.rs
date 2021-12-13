use std::io::BufRead;
use std::time::Instant;
use std::collections::HashMap;
use std::str::FromStr;

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
enum Cave {
    Start,
    End,
    Small(u32),
    Big(u32),
}

impl FromStr for Cave {
    type Err = std::string::ParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let n = convert_cave_str_to_int(s);
        let is_upper = s.chars().next().unwrap().is_uppercase();
        match (s, is_upper, n) {
            ("start", _, _) => Ok(Cave::Start),
            ("end", _, _)   => Ok(Cave::End),
            (_, true, i)    => Ok(Cave::Big(i)),
            (_, false, i)   => Ok(Cave::Small(i)),
        }
    }
}

fn convert_cave_str_to_int(x: &str) -> u32 {
    // spent way too long struggling with &str lifetimes out of stdin, so here 
    // we are
    const CHAR_TO_INT: fn(char) -> u32 = |c| ((c as u8) - b'A' + 1) as u32;
    const CHAR_COUNT: u32 = (b'z' - b'A' + 1) as u32;
    let mut out: u32 = 0;
    for (i, c) in x.chars().rev().enumerate() {
        out += CHAR_COUNT.pow(i as u32) * CHAR_TO_INT(c)
    }
    out
}

fn parse_input() -> HashMap<Cave, Vec<Cave>> {
    let mut edges: HashMap<Cave, Vec<Cave>> = HashMap::new();
    let lines: Vec<Vec<Cave>> = std::io::stdin()
        .lock()
        .lines()
        .filter_map(|line| line.ok())
        .map(|line| line.split("-").map(|i| Cave::from_str(i).unwrap()).collect())
        .collect();

    for line in lines {
        let start = line[0];
        let end = line[1];

        if let Some(start) = edges.get_mut(&start) {
            start.push(end);
        } else {
            edges.insert(start, vec![end]);
        }

        if let Some(end) = edges.get_mut(&end) {
            end.push(start);
        } else {
            edges.insert(end, vec![start]);
        }
    }

    edges
}

fn count_distinct_paths(graph: &HashMap<Cave, Vec<Cave>>, visited: &mut Vec<Cave>, 
    permit_one_small_dupl: bool) -> u32 {

    let mut n = 0;
    if visited.len() == 0 { visited.push(Cave::Start) } 
    if let Some(x) = graph.get(&visited[visited.len() - 1]) {
        for next in x {
            match next {
                Cave::Start => {},
                Cave::End => n += 1,
                Cave::Small(x) => {
                    // please forgive this nonsense... i've lost interest in trying to clean this up
                    let xcount = visited.iter().filter(|i| *i == &Cave::Small(*x)).count();
                    if !permit_one_small_dupl && xcount > 0 { continue }
                    if permit_one_small_dupl && xcount > 1 { continue }
                    visited.push(Cave::Small(*x));
                    n += count_distinct_paths(graph, visited, permit_one_small_dupl && xcount == 0);
                    visited.pop();
                },
                Cave::Big(x)   => {
                    visited.push(Cave::Big(*x));
                    n += count_distinct_paths(graph, visited, permit_one_small_dupl);
                    visited.pop();
                },
            }
        }
    }

    n
}

fn main() {
    let now = Instant::now();
    let g = parse_input();
    println!("{:?}", count_distinct_paths(&g, &mut vec![], false));
    println!("{:?}", count_distinct_paths(&g, &mut vec![], true));
    println!("Elapsed: {:?}", now.elapsed());
}
