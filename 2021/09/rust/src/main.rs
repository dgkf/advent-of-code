use std::io::BufRead;
use std::time::Instant;

fn parse_input() -> Vec<Vec<u8>> {
    std::io::stdin()
        .lock()
        .lines()
        .filter_map(|s| s.ok())
        .map(|s| s.chars().map(|c| (c as u8) - 48).collect())
        .collect()
}

fn find_local_minima(m: &Vec<Vec<u8>>) -> Vec<(usize,usize)> {
    let mut pos: Vec<(usize,usize)> = vec![];
    for (x, vec) in m.iter().enumerate() {
        for (y, &val) in vec.iter().enumerate() {
            if (x == 0           || m[x-1][y] > val) &&
               (x == m.len()-1   || m[x+1][y] > val) &&
               (y == 0           || m[x][y-1] > val) &&
               (y == vec.len()-1 || m[x][y+1] > val) {
                pos.push((x, y));
            }
        }
    }
    pos
}

fn sum_local_minima_values(m: &Vec<Vec<u8>>) -> u32 {
    let mut sum: u32 = 0;
    for p in find_local_minima(m).iter() { sum += (m[p.0][p.1] + 1) as u32; }
    sum
}

fn basin_points(m: &Vec<Vec<u8>>, x: usize, y: usize) -> Vec<(usize, usize)> {
    let mut area: Vec<(usize, usize)> = vec![];

    if m[x][y] == 9 { return area }
    area.push((x, y));

    if x > 0            && m[x-1][y] > m[x][y] { area.append(&mut basin_points(m, x-1, y)) }
    if x < m.len()-1    && m[x+1][y] > m[x][y] { area.append(&mut basin_points(m, x+1, y)) }
    if y > 0            && m[x][y-1] > m[x][y] { area.append(&mut basin_points(m, x, y-1)) }
    if y < m[0].len()-1 && m[x][y+1] > m[x][y] { area.append(&mut basin_points(m, x, y+1)) }

    area.sort();
    area.dedup();
    area
}

fn area_of_three_largest_basins(m: &Vec<Vec<u8>>) -> u32 {
    let mut areas = find_local_minima(m).iter()
        .map(|(x, y)| basin_points(m, *x, *y).len() as u32)
        .collect::<Vec<u32>>();

    areas.sort();
    areas.iter().rev().take(3).copied().reduce(|l, r| l * r).unwrap()
}

fn main() {
    let now = Instant::now();
    let input = parse_input();
    println!("{:?}", sum_local_minima_values(&input));
    println!("{:?}", area_of_three_largest_basins(&input));
    println!("Elapsed: {:?}", now.elapsed());
}

