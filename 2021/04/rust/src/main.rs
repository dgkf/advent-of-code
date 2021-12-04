use std::io::BufRead;
use std::str::FromStr;
use std::time::Instant;

#[derive(Debug, PartialEq)]
struct BingoCard {
    vals: Vec<Vec<u32>>,
}

impl FromStr for BingoCard {
    type Err = Box<dyn std::error::Error>;
    fn from_str(lines: &str) -> Result<Self, Self::Err> {
        let vals = lines.split("\n")
            .map(|line| {
                line.trim()
                    .split_whitespace()
                    .map(|c| u32::from_str(c).unwrap())
                    .collect()
            })
            .collect();

        Ok(BingoCard{ vals: vals }) 
    }
}


fn parse_input() -> (Vec<u32>, Vec<BingoCard>) {
    let input = std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .collect::<Vec<String>>()
        .join("\n");

    let mut blocks = input.split("\n\n");
    let numbers = blocks.next()
        .unwrap()
        .split(",")
        .map(|c| u32::from_str(c).unwrap())
        .collect();

    let cards = blocks
        .map(|s| BingoCard::from_str(s).unwrap())
        .collect();

    (numbers, cards)
}

fn has_bingo(card: &BingoCard, numbers: &[u32]) -> bool {
    let mut bingo: bool;

    // check to see if any rows contain bingo
    for row in 0..5 {
        bingo = true;
        for col in 0..5 {
            if !numbers.contains(&card.vals[row][col]) { bingo = false; }
        }
        if bingo { return true };
    }

    // check to see if any columns contain bingo
    for col in 0..5 {
        bingo = true;
        for row in 0..5 {
            if !numbers.contains(&card.vals[row][col]) { bingo = false }
        }
        if bingo { return true };
    }

    return false;
}

fn score_card(card: &BingoCard, numbers: &[u32]) -> u32 {
    let mut unmarked_sum: u32 = 0;

    for row in 0..5 {
        for col in 0..5 {
            if !numbers.contains(&card.vals[row][col]) {
                unmarked_sum += &card.vals[row][col]
            }
        }
    }

    unmarked_sum * (numbers[numbers.len() - 1] as u32)
}

fn first_winning_score(cards: &Vec<BingoCard>, numbers: &Vec<u32>) -> u32 {
    for n in 5..numbers.len() {
        for card in cards {
            if has_bingo(&card, &numbers[0..n]) { 
                return score_card(&card, &numbers[0..n])
            }
        }
    }
    0
}

fn last_winning_score(cards: &Vec<BingoCard>, numbers: &Vec<u32>) -> u32 {
    let mut card_mask = vec![true; cards.len()];
    let mut last_winning_score: u32 = 0;
    for n in 5..numbers.len() {
        for (i, card) in cards.iter().enumerate() {
            if !card_mask[i] { continue }
            if has_bingo(&card, &numbers[0..n]) { 
                last_winning_score = score_card(&card, &numbers[0..n]);
                card_mask[i] = false;
            }
        }
    }
    last_winning_score
}

fn main() {
    let now = Instant::now();
    let (numbers, cards) = parse_input();
    println!("{:?}", first_winning_score(&cards, &numbers));
    println!("{:?}", last_winning_score(&cards, &numbers));
    println!("Elapsed: {:?}", now.elapsed());
}
