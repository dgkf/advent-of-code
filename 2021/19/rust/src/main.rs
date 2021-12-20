use std::io::{stdin, BufRead};
use std::time::Instant;
use std::str::FromStr;
use std::collections::HashMap;
use nalgebra::*;

// I can't for the life of me figure out how to add a matrix row and a vector.
// Instead of continuing to pour over rust docs, I'll bear the shame of writing
// out vector additions by hand.

#[derive(Debug, Clone)]
struct Scanner {
    beacons: MatrixXx3<i32>,
    location: Option<Vector3<i32>>,
}

fn parse_vec(s: &str) -> RowVector3<i32> {
    let mut strs = s.split(',').map(i32::from_str);
    let x = strs.next().unwrap().unwrap();
    let y = strs.next().unwrap().unwrap();
    let z = strs.next().unwrap().unwrap();
    RowVector3::<i32>::from([x, y, z])
}

fn parse_input() -> Vec<Scanner> {
    let input: Vec<String> = stdin()
        .lock()
        .lines()
        .filter_map(|i| i.ok())
        .collect();

    let mut lines = input.iter()
        .peekable();

    let mut scanners: Vec<Scanner> = vec![];
    while let Some(l) = lines.peek() {
        if l.starts_with("--- scanner") {
            lines.next();
            let rows = lines.by_ref()
                .take_while(|i| !i.is_empty())
                .map(|i| parse_vec(i))
                .collect::<Vec<RowVector3<i32>>>();

            let beacons = MatrixXx3::from_rows(&rows);
            scanners.push(Scanner{ beacons, location: None });
        }

    }

    scanners
}

fn rotations() -> Vec<Matrix3<i32>> {
    let mut rotations = vec![];
    let base = Matrix3::<i32>::identity();

    let rot_x = Matrix3::<i32>::new(
         1,  0,  0,
         0,  0, -1,
         0,  1,  0);

    let rot_y = Matrix3::<i32>::new(
         0,  0,  1,
         0,  1,  0,
        -1,  0,  0);

    let rot_z = Matrix3::<i32>::new(
         0, -1,  0,
         1,  0,  0,
         0,  0,  1);

    for x in 0..4 { for y in 0..4 { for z in 0..4 {
        let mut next_rot = base;
        for _ in 0..x { next_rot *= rot_x; }
        for _ in 0..y { next_rot *= rot_y; }
        for _ in 0..z { next_rot *= rot_z; }
        if !rotations.contains(&next_rot) { rotations.push(next_rot) } 
    } } }

    rotations
}

fn align_scanner_to(s: &Scanner, to: &Scanner) -> Option<Scanner> {
    let mut aligned = s.clone();
    let mut offset_pairs: HashMap<[i32; 3], (usize, usize)>; // map s_row to to_row
    let mut offset_counts: HashMap<[i32; 3], u32>;
    let to_location = to.location?;

    for rot in rotations() {
        offset_pairs = HashMap::new();
        offset_counts = HashMap::new();
        aligned.beacons = &s.beacons * rot;

        // count unique offsets between scanners
        for s_row in 0..aligned.beacons.nrows() { for to_row in 0..to.beacons.nrows() {
            let diff = aligned.beacons.row(s_row) - to.beacons.row(to_row);
            let diff_vec = [diff[0], diff[1], diff[2]];

            if let Some(count) = offset_counts.get_mut(&diff_vec) {
                *count += 1;
            } else {
                offset_counts.insert(diff_vec, 1);
                offset_pairs.insert(diff_vec, (s_row, to_row));
            }

        } }

        // find the offset that occurs most frequently
        let (offset, count) = offset_counts.iter()
            .reduce(|l @ (_, lv), r @ (_, rv)| if lv > rv { l } else { r })
            .unwrap();

        // if the maximum offset count is >= 12, this is our aligned scanner
        if *count >= 12 {
            let (aligned_r, to_r) = offset_pairs.get(offset).unwrap();
            let aligned_point = aligned.beacons.row(*aligned_r);
            let to_point = to.beacons.row(*to_r);

            // to.location + to_point - aligned_point
            let location = Vector3::new(
                to_location[0] + to_point[0] - aligned_point[0] ,
                to_location[1] + to_point[1] - aligned_point[1] ,
                to_location[2] + to_point[2] - aligned_point[2] 
            );

            aligned.location = Some(location);
            return Some(aligned);
        }
    }

    None
}

fn align_scanners(s: &mut Vec<Scanner>) -> Vec<Scanner> {
    // set a default origin for the first scanner
    s[0].location = Some(Vector3::new(0, 0, 0));
    
    while s.iter().any(|i| i.location.is_none()) {
        for i in 0..s.len() { 
            if s[i].location.is_some() { continue }
            for j in 0..s.len() {
                if s[j].location.is_none() { continue } 
                if let Some(aligned) = align_scanner_to(&s[i], &s[j]) {
                    s[i] = aligned;
                    break
                }
            } 
        }
    }

    s.to_vec()
}

fn count_beacons(scanners: &[Scanner]) -> usize {
    let mut beacon_coverage = HashMap::<[i32; 3], u32>::new();
    for scanner in scanners {
        for i in 0..scanner.beacons.nrows() {
            let beacon = scanner.beacons.row(i);
            if let Some(scanner_loc) = scanner.location {
                let beacon_loc = [
                    scanner_loc[0] + beacon[0],
                    scanner_loc[1] + beacon[1],
                    scanner_loc[2] + beacon[2]
                ];

                if let Some(count) = beacon_coverage.get_mut(&beacon_loc) {
                    *count += 1;
                } else {
                    beacon_coverage.insert(beacon_loc, 1);
                }
            } else {
                panic!("Scanner has not been aligned");
            }
        }
    }

    beacon_coverage.len()
}

fn furthest_scanner_distance(scanners: &[Scanner]) -> i32 {
    let mut max_manh_dist = 0;

    for i in scanners {
        for j in scanners {
            if i.location.is_none() || j.location.is_none() { 
                panic!("Scanner has not been aligned")
            }

            let iloc = i.location.unwrap();
            let jloc = j.location.unwrap();
            
            let manh_dist = 
                (iloc[0] - jloc[0]).abs() + 
                (iloc[1] - jloc[1]).abs() + 
                (iloc[2] - jloc[2]).abs();

            if manh_dist > max_manh_dist { max_manh_dist = manh_dist };
        }
    }

    max_manh_dist
}

fn main() {
    let now = Instant::now();
    let mut scanners = parse_input();
    align_scanners(&mut scanners);
    println!("{}", count_beacons(&scanners));
    println!("{}", furthest_scanner_distance(&scanners));
    println!("Elapsed: {:?}", now.elapsed());
}


