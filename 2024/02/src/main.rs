use std::time::SystemTime;

fn is_safe_report(report: &[i8]) -> bool {
    let diff = report.windows(2).map(|w| w[1] - w[0]);
    let min = diff.clone().min().unwrap();
    let max = diff.max().unwrap();
    min >= 1 && max <= 3 || min >= -3 && max <= -1
}

fn is_tolerable_report(report: &[i8]) -> bool {
    if is_safe_report(report) {
        return true;
    }

    for i_to_remove in 0..report.len() {
        let mut r: Vec<_> = report.into();
        r.remove(i_to_remove);
        if is_safe_report(&r) {
            return true;
        }
    }

    false
}

fn main() -> Result<(), std::io::Error> {
    let time = SystemTime::now();
    let reports: Vec<Vec<_>> = aoc::input_lines_iter()
        .map(|report| {
            report
                .split_whitespace()
                .map(|i| i.parse::<i8>().unwrap())
                .collect()
        })
        .collect();

    println!(
        "{} ({:?})",
        reports
            .iter()
            .map(|i| is_safe_report(i))
            .filter(|&i| i)
            .count(),
        time.elapsed().unwrap()
    );

    println!(
        "{} ({:?})",
        reports
            .iter()
            .map(|i| is_tolerable_report(i))
            .filter(|&i| i)
            .count(),
        time.elapsed().unwrap()
    );

    Ok(())
}
