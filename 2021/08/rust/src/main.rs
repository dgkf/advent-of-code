use std::io::BufRead;
use std::time::Instant;
use std::collections::HashMap;

#[derive(Debug, PartialEq)]
struct Entry {
    signals: Vec<Vec<u8>>,
    output: Vec<Vec<u8>>
}

fn build_panel_counts_mapping() -> HashMap<u8, u8> {
    let mut panel_counts = HashMap::new();
    panel_counts.insert(6, 1);
    panel_counts.insert(4, 4);
    panel_counts.insert(9, 5);
    panel_counts
}

fn build_digit_array_mapping() -> HashMap<[u8; 7], u8> {
    let mut digits = HashMap::new();
    digits.insert([1, 1, 1, 0, 1, 1, 1], 0);
    digits.insert([0, 0, 1, 0, 0, 1, 0], 1);
    digits.insert([1, 0, 1, 1, 1, 0, 1], 2);
    digits.insert([1, 0, 1, 1, 0, 1, 1], 3);
    digits.insert([0, 1, 1, 1, 0, 1, 0], 4);
    digits.insert([1, 1, 0, 1, 0, 1, 1], 5);
    digits.insert([1, 1, 0, 1, 1, 1, 1], 6);
    digits.insert([1, 0, 1, 0, 0, 1, 0], 7);
    digits.insert([1, 1, 1, 1, 1, 1, 1], 8);
    digits.insert([1, 1, 1, 1, 0, 1, 1], 9);
    digits
}

fn signal_to_vec(signal: String) -> Vec<u8> {
    signal.chars().map(|c| (c as u8) - 97).collect()    
}

fn parse_line(line: String) -> Entry {
    let mut entryline = line.split(" | ");
    let signals = entryline.next().unwrap().split(" ").map(|s| signal_to_vec(s.to_string())).collect();
    let output  = entryline.next().unwrap().split(" ").map(|s| signal_to_vec(s.to_string())).collect();
    Entry{ signals: signals, output: output }
}

fn parse_input() -> Vec<Entry> {
    std::io::stdin()
        .lock()
        .lines()
        .map(|line| parse_line(line.unwrap()))
        .collect()
}

fn remap_signal(s: &Vec<u8>, map: &Vec<u8>) -> Vec<u8> {
    s.iter().map(|i| map[*i as usize]).collect()
}

fn remap_entry(ent: &Entry, pc: &HashMap<u8, u8>) -> Entry {
    let mut panel_counts = vec![0; 7];
    let mut panel_map = vec![0; 7];

    // count occurences of each panel
    for s in &ent.signals {
        for i in s {
            panel_counts[*i as usize] += 1;
        }
    }

    // map unique panel counts
    for (i, &c) in panel_counts.iter().enumerate() {
        if c == 7 {
            // if i in signal of length 4 => panel 3
            // else                       => panel 6
            if ent.signals.iter().find(|s| s.len() == 4).unwrap().contains(&(i as u8)) {
                panel_map[i] = 3
            } else {
                panel_map[i] = 6
            }
        } else if c == 8 {
            // if i in signal of length 2 => panel 2
            // else                       => panel 0
            if ent.signals.iter().find(|s| s.len() == 2).unwrap().contains(&(i as u8)) {
                panel_map[i] = 2
            } else {
                panel_map[i] = 0
            }
        } else {
            panel_map[i] = pc[&c]; 
        }
    }

    // build new entry with consistent numbering schemes
    let signals: Vec<Vec<u8>> = ent.signals.iter().map(|s| remap_signal(s, &panel_map)).collect();
    let output:  Vec<Vec<u8>> = ent.output.iter().map(|s| remap_signal(s, &panel_map)).collect();
    Entry{ signals, output }
}

fn remap_entries(entries: &Vec<Entry>, pc: &HashMap<u8, u8>) -> Vec<Entry> {
    entries.iter().map(|e| remap_entry(e, &pc)).collect()
}

fn output_vec_to_panel_vec(v: &Vec<u8>) -> [u8; 7] {
    let mut out: [u8; 7] = [0; 7];
    for i in v { out[*i as usize] = 1 }
    out
}

fn entry_output(ent: &Entry, digits: &HashMap<[u8; 7], u8>) -> Vec<u8> {
    ent.output.iter()
        .map(|o| digits[&output_vec_to_panel_vec(o)])
        .collect()
}

fn entry_outputs(entries: &Vec<Entry>, digits: &HashMap<[u8; 7], u8>) -> Vec<Vec<u8>> {
    entries.iter().map(|e| entry_output(e, &digits)).collect()
}

fn count_easy(output: &Vec<Vec<u8>>) -> u32 {
    const EASY: [u8; 4] = [1, 4, 7, 8];
    let mut count = 0;
    for output_i in output {
        for n in output_i {
            if EASY.contains(n) {
                count += 1;
            }
        }
    }
    count
}

fn sum_all(output: &Vec<Vec<u8>>) -> u32 {
    let mut sum: u32 = 0;
    for output_i in output {
        for (i, n) in output_i.iter().rev().enumerate() {
            sum += (*n as u32) * (10 as u32).pow(i as u32);
        }
    }
    sum
}

fn main() {
    let now = Instant::now();
    let input = parse_input();
    let panel_counts = build_panel_counts_mapping();
    let digits = build_digit_array_mapping();
    let output = entry_outputs(&remap_entries(&input, &panel_counts), &digits);
    println!("{:?}", count_easy(&output));
    println!("{:?}", sum_all(&output));
    println!("Elapsed: {:?}", now.elapsed());
}
