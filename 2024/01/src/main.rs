use std::{collections::HashMap, fmt::Display, io};

struct HistorianLists {
    left: Vec<u32>,
    right: Vec<u32>,
}

impl TryFrom<Vec<String>> for HistorianLists {
    type Error = std::io::Error;

    fn try_from(value: Vec<String>) -> Result<Self, Self::Error> {
        let err = || io::Error::new(io::ErrorKind::InvalidInput, "Invalid Lists");

        let mut left = vec![0; value.len()];
        let mut right = vec![0; value.len()];

        for line in value {
            let elems: Vec<_> = line.split_whitespace().take(2).collect();
            left.push(elems[0].parse().map_err(|_| err())?);
            right.push(elems[1].parse().map_err(|_| err())?);
        }

        left.sort();
        right.sort();

        Ok(HistorianLists { left, right })
    }
}

impl HistorianLists {
    fn total_distance(&self) -> u32 {
        self.left
            .iter()
            .zip(self.right.iter())
            .map(|(l, r)| l.abs_diff(*r))
            .sum()
    }

    fn similarity_score(&self) -> u32 {
        let mut counts: HashMap<u32, u32> = HashMap::new();
        for i in self.right.iter() {
            counts
                .entry(*i)
                .and_modify(|value| *value += 1)
                .or_insert(1);
        }

        self.left
            .iter()
            .map(|i| i * counts.get(i).unwrap_or(&0))
            .sum()
    }
}

impl Display for HistorianLists {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}\n{}", self.total_distance(), self.similarity_score())
    }
}

fn main() -> Result<(), std::io::Error> {
    let lines: Vec<String> = io::stdin()
        .lines()
        .take_while(|i| i.is_ok())
        .flatten()
        .collect();

    let hists: HistorianLists = lines.try_into()?;
    println!("{hists}");

    Ok(())
}
