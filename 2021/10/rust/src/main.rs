use std::io::BufRead;
use std::time::Instant;

#[derive(Debug)]
enum LineStatus {
    NoError,
    SyntaxError(char),
    IncompleteLineError(Vec<char>),
}

fn parse_input() -> Vec<Vec<char>> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .map(|s| s.chars().collect())
        .collect()
}

fn analyze_syntax_errors(line: &Vec<char>) -> LineStatus {
    let mut stack: Vec<char> = vec![];

    for c in line {
        if vec!['[', '(', '<', '{'].contains(c) { 
            stack.push(*c);
        } else if (c == &']' && stack.last().unwrap() != &'[') ||
            (c == &')' && stack.last().unwrap() != &'(') ||
            (c == &'>' && stack.last().unwrap() != &'<') ||
            (c == &'}' && stack.last().unwrap() != &'{') { 
            return LineStatus::SyntaxError(*c);
        } else {
            stack.pop();
        }
    }

    if stack.len() == 0 { 
        return LineStatus::NoError;
    } else { 
        stack.reverse();
        return LineStatus::IncompleteLineError(stack);
    }
}

fn score_syntax_errors(lines: &Vec<Vec<char>>) -> u32 {
    lines.iter()
        .map(|i| match analyze_syntax_errors(i) {
            LineStatus::SyntaxError(')') => 3,
            LineStatus::SyntaxError(']') => 57,
            LineStatus::SyntaxError('}') => 1197,
            LineStatus::SyntaxError('>') => 25137,
            _                            => 0,
        })
        .sum()
}

fn score_incomplete_line_error(v: &Vec<char>) -> u64 {
    v.iter()
        .map(|c| match c {
            '(' => 1,
            '[' => 2,
            '{' => 3,
            '<' => 4,
            _   => 0,
        })
        .reduce(|l, r| l * 5 + r)
        .unwrap()
}

fn score_incomplete_line_errors(lines: &Vec<Vec<char>>) -> u64 {
    let mut scores: Vec<u64> = lines.iter()
        .map(|i| match analyze_syntax_errors(i) {
            LineStatus::IncompleteLineError(v) => score_incomplete_line_error(&v),
            _ => 0,
        })
        .filter(|i| i > &0)
        .collect();

    scores.sort();
    scores[scores.len() / 2]
}


fn main() {
    let now = Instant::now();
    let input = parse_input();
    println!("{:?}", score_syntax_errors(&input));
    println!("{:?}", score_incomplete_line_errors(&input));
    println!("Elapsed: {:?}", now.elapsed());
}
