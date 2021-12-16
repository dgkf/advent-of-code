use std::io::{stdin, BufRead};
use std::time::Instant;
use std::collections::HashMap;

#[derive(Debug)]
enum PacketData {
    Literal(u64),
    Operator(Vec<Packet>),
}

#[derive(Debug)]
struct Packet {
    version: u8,
    type_id: u8,
    data: PacketData
}

fn read_bits_as_value<T>(x: &mut T, n: usize) -> Option<u64>
where T: Iterator<Item = bool> {
    Some(bits_as_value(read_bits(x, n)?))
}

fn bits_as_value(x: Vec<bool>) -> u64 {
    let mut val: u64 = 0;
    for (i, b) in x.iter().rev().enumerate() {
        if *b { val += 2_u64.pow(i as u32) }
    }
    val
}

fn read_bits<T, U>(x: &mut T, n: usize) -> Option<Vec<U>>
where T: Iterator<Item = U> {
    let mut v = vec![];
    for _ in 0..n { v.push(x.next()?) }
    Some(v)
}

fn parse_packet<T>(x: &mut T) -> Option<(Packet, u64)> 
where T: Iterator<Item = bool> {
    let mut bitn: u64 = 0;
    let version: u8 = read_bits_as_value(x, 3)? as u8;
    let type_id: u8 = read_bits_as_value(x, 3)? as u8;
    bitn += 6;

    match type_id {
        4 => {
            // read packet data in groups of 5 until a segment starts with 0
            let mut packetdata: Vec<bool> = vec![];

            loop {
                let nextfive = read_bits(x, 5)?;
                bitn += 5;
                if !nextfive[0] {
                    packetdata.extend_from_slice(&nextfive[1..]);
                    break;
                } else {
                    packetdata.extend_from_slice(&nextfive[1..]);
                }
            }

            // calculate literal value
            let l = bits_as_value(packetdata);

            // append to packets vector
            Some((Packet{ version, type_id, data: PacketData::Literal(l) }, bitn))
        },
        _ => {
            // initialize a set of subpackets to populate
            let mut subpackets: Vec<Packet> = vec![];

            // get length id from next bit
            let len_id = (read_bits(x, 1)?)[0];
            bitn += 1;
            match len_id {
                true => {
                    let mut n_packets = bits_as_value(read_bits(x, 11)?);
                    bitn += 11;
                    while n_packets > 0 {
                        let (subpacket, subpacketlen) = parse_packet(x)?;
                        subpackets.push(subpacket);
                        n_packets -= 1;
                        bitn += subpacketlen;
                    }
                },
                false => {
                    let mut total_len = bits_as_value(read_bits(x, 15)?) as u64;
                    bitn += 15;
                    while total_len > 0 {
                        let (subpacket, subpacketlen) = parse_packet(x)?;
                        subpackets.push(subpacket);
                        total_len -= subpacketlen;
                        bitn += subpacketlen; 
                    }
                }
            }

            Some((Packet{ version, type_id, data: PacketData::Operator(subpackets) }, bitn))
        }
    }
}

fn parse_input() -> Option<Packet> {
    let encoding = HashMap::from([
        ('0', [false, false, false, false]),
        ('1', [false, false, false,  true]),
        ('2', [false, false,  true, false]),
        ('3', [false, false,  true,  true]),
        ('4', [false,  true, false, false]),
        ('5', [false,  true, false,  true]),
        ('6', [false,  true,  true, false]),
        ('7', [false,  true,  true,  true]),
        ('8', [ true, false, false, false]),
        ('9', [ true, false, false,  true]),
        ('A', [ true, false,  true, false]),
        ('B', [ true, false,  true,  true]),
        ('C', [ true,  true, false, false]),
        ('D', [ true,  true, false,  true]),
        ('E', [ true,  true,  true, false]),
        ('F', [ true,  true,  true,  true]),
    ]);

    let input = stdin().lock().lines().next().unwrap().unwrap();
    let mut bitstream = input.chars().flat_map(|i| *encoding.get(&i).unwrap());
    let (packet, _) = parse_packet(&mut bitstream)?;
    Some(packet)
}

fn sum_versions(x: &Packet) -> u32 {
    let mut sum = x.version as u32;
    if let PacketData::Operator(packets) = &x.data {
        for p in packets { sum += sum_versions(p) }
    }
    sum
}

fn eval(x: &Packet) -> Option<u64> {
    match (x.type_id, &x.data) {
        (0, PacketData::Operator(ps)) => 
            ps.iter().filter_map(eval).reduce(|l, r| l + r),
        (1, PacketData::Operator(ps)) => 
            ps.iter().filter_map(eval).reduce(|l, r| l * r),
        (2, PacketData::Operator(ps)) => 
            ps.iter().filter_map(eval).min(),
        (3, PacketData::Operator(ps)) => 
            ps.iter().filter_map(eval).max(),
        (4, PacketData::Literal(v)) => 
            Some(*v),
        (5, PacketData::Operator(ps)) => 
            if eval(&ps[0]) > eval(&ps[1]) { Some(1) } else { Some(0) },
        (6, PacketData::Operator(ps)) => 
            if eval(&ps[0]) < eval(&ps[1]) { Some(1) } else { Some(0) },
        (7, PacketData::Operator(ps)) => 
            if eval(&ps[0]) == eval(&ps[1]) { Some(1) } else { Some(0) },
        _ => None
    }
}

fn main() {
    let now = Instant::now();
    if let Some(input) = parse_input() {
        println!("{:?}", sum_versions(&input));
        println!("{:?}", eval(&input).unwrap());
    }
    println!("Elapsed: {:?}", now.elapsed());
}

