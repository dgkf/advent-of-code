use std::io;

fn main() -> Result<(), std::io::Error> {
    let reports = io::stdin()
        .lines()
        .take_while(|i| i.is_ok())
        .flat_map(|line| {
            line.map(|report| {
                report
                    .split_whitespace()
                    .flat_map(|i| i.parse::<i8>())
                    .collect::<Vec<_>>()
            })
        })
        .collect::<Vec<_>>();

    let safe_reports = reports
        .iter()
        .map(|report| {
            let diff = report.windows(2).map(|w| w[1] - w[0]);
            let min = diff.clone().min().unwrap();
            let max = diff.max().unwrap();
            min >= 1 && max <= 3 || min >= -3 && max <= -1
        })
        .collect::<Vec<_>>();

    let tolerant_safe_reports = reports
        .iter()
        .zip(&safe_reports)
        .map(|(report, is_safe)| {
            if *is_safe {
                return true;
            }

            for tolerate in 0..report.len() {
                let report_sub_one: Vec<_> = report
                    .iter()
                    .enumerate()
                    .filter(|(i, _)| *i != tolerate)
                    .map(|(_, x)| x)
                    .collect();

                let diff = report_sub_one.windows(2).map(|w| w[1] - w[0]);
                let min = diff.clone().min().unwrap();
                let max = diff.max().unwrap();
                if min >= 1 && max <= 3 || min >= -3 && max <= -1 {
                    return true;
                }
            }

            false
        })
        .collect::<Vec<_>>();

    println!("{}", safe_reports.iter().filter(|&i| *i).count());
    println!("{}", tolerant_safe_reports.iter().filter(|&i| *i).count());

    Ok(())
}
