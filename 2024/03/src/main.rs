use regex_static::regex;
use std::time::SystemTime;

fn main() {
    let time = SystemTime::now();
    let input = aoc::input();

    let re = regex!(r"mul\((?P<l>\d{1,3}),(?P<r>\d{1,3})\)");
    let res: u32 = re
        .captures_iter(&input)
        .map(|cap| {
            let (_, [l, r]) = cap.extract();
            l.parse::<u32>().unwrap() * r.parse::<u32>().unwrap()
        })
        .reduce(|l, r| l + r)
        .unwrap();

    println!("{res} ({:?})", time.elapsed().unwrap());

    let re = regex!(r"do\(()()\)|don't\(()()\)|mul\((?P<l>\d{1,3}),(?P<r>\d{1,3})\)");
    let res = re
        .captures_iter(&input)
        .scan(
            // enabled; sum
            (true, 0),
            |state, cap| {
                match (state.0, cap[0].to_string().as_str()) {
                    (_, "do()") => state.0 = true,
                    (_, "don't()") => state.0 = false,
                    (true, _) => {
                        let (_, [l, r]) = cap.extract();
                        state.1 += l.parse::<u32>().unwrap() * r.parse::<u32>().unwrap()
                    }
                    _ => (),
                }

                Some(state.1)
            },
        )
        .last()
        .unwrap_or(0);

    println!("{res} ({:?})", time.elapsed().unwrap());
}
