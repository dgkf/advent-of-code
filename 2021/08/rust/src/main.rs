use std::io::BufRead;
use std::time::Instant;
use std::str::FromStr;

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
struct SevenPanelDisplay {
    panels: [bool; 7],
}

impl FromStr for SevenPanelDisplay {
    type Err = std::string::ParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        const LETTERS: [char; 7] = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];
        let mut panels: [bool; 7] = [false; 7];
        for i in 0..panels.len() { panels[i] = s.contains(LETTERS[i]) }
        Ok(SevenPanelDisplay{ panels })
    }
}

#[derive(Debug, PartialEq)]
struct Entry {
    output: Vec<u8>,
}

impl FromStr for Entry {
    type Err = std::string::ParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut entryline = s.split(" | ");

        let mut signals: [SevenPanelDisplay; 10] = [SevenPanelDisplay{ panels: [false; 7] }; 10];
        for (i, s) in entryline.next().unwrap().split(" ").enumerate() {
            signals[i] = SevenPanelDisplay::from_str(s).unwrap();
        }

        let panel_map = remap_signals(&mut signals);
        let output = entryline.next().unwrap().split(" ")
            .map(|s| SevenPanelDisplay::from_str(s).unwrap())
            .map(|s| panel_to_value(&remap_signal(&s, &panel_map)))
            .collect();

        Ok(Entry{ output })
    }
}

fn panel_to_value(s: &SevenPanelDisplay) -> u8 {
    match s.panels {
        [ true,  true,  true, false,  true,  true,  true] => 0,
        [false, false,  true, false, false,  true, false] => 1,
        [ true, false,  true,  true,  true, false,  true] => 2,
        [ true, false,  true,  true, false,  true,  true] => 3,
        [false,  true,  true,  true, false,  true, false] => 4,
        [ true,  true, false,  true, false,  true,  true] => 5,
        [ true,  true, false,  true,  true,  true,  true] => 6,
        [ true, false,  true, false, false,  true, false] => 7,
        [ true,  true,  true,  true,  true,  true,  true] => 8,
        [ true,  true,  true,  true, false,  true,  true] => 9,
        _                                                 => 0,
    }
}

fn parse_input() -> Vec<Entry> {
    std::io::stdin()
        .lock()
        .lines()
        .map(|line| Entry::from_str(&line.unwrap()).unwrap())
        .collect()
}

fn remap_signal(s: &SevenPanelDisplay, map: &Vec<usize>) -> SevenPanelDisplay {
    let mut panels = [false; 7];
    for i in 0..s.panels.len() {
        panels[i] = s.panels[map[i]];
    }
    SevenPanelDisplay{ panels }
}

fn remap_signals(signals: &mut [SevenPanelDisplay; 10]) -> Vec<usize> {
    let mut panel_counts = vec![0; 7];
    let mut panel_map: Vec<usize> = vec![0; 7];

    let signal_of_len = |s: [SevenPanelDisplay; 10], n| s.into_iter()
        .filter(|s| s.panels.iter().filter(|i| **i).count() == n)
        .next()
        .unwrap();

    let signal_of_len_4 = signal_of_len(*signals, 4);
    let signal_of_len_2 = signal_of_len(*signals, 2);

    // count occurences of each panel
    for s in *signals {
        for (i, b) in s.panels.iter().enumerate() {
            if *b { panel_counts[i] += 1; }
        }
    }

    // map unique panel counts (rely primarily on panel counts, using 
    // occurance in unambiguous signals when panel count is ambiguous)
    for (i, &c) in panel_counts.iter().enumerate() {
        let map_to = match c {
            // if panel count of 7, use occurance in signal of len 4 to determine
            7 => if signal_of_len_4.panels[i] { 3 } else { 6 },
            // if panel count of 8, use occurance in signal of len 2 to determine
            8 => if signal_of_len_2.panels[i] { 2 } else { 0 },
            4 => 4,
            6 => 1,
            9 => 5,
            _ => 0,
        };

        panel_map[map_to] = i;
    }

    // build new display with consistent numbering schemes
    for i in 0..signals.len() {
        signals[i] = remap_signal(&signals[i], &panel_map)
    }

    panel_map
}

fn count_easy(entries: &Vec<Entry>) -> u32 {
    const EASY: [u8; 4] = [1, 4, 7, 8];
    let mut count = 0;
    for e in entries {
        for o in &e.output {
            if EASY.contains(o) { count += 1 }
        }
    }
    count
}

fn sum_all(entries: &Vec<Entry>) -> u64 {
    let mut sum: u64 = 0;
    for e in entries {
        for (i, o) in e.output.iter().rev().enumerate() {
            sum += (*o as u64) * 10_u64.pow(i as u32);
        }
    }
    sum
}

fn main() {
    let now = Instant::now();
    let input = parse_input();
    println!("{:?}", count_easy(&input));
    println!("{:?}", sum_all(&input));
    println!("Elapsed: {:?}", now.elapsed());
}
