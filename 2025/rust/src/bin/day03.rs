use adventofcode::read_file_or_stdin;
use std::{env, io};

fn max_joltage(bank: &str) -> u64 {
    bank.chars()
        .map(|s| s.to_digit(10).unwrap())
        .fold(Vec::new(), |mut acc, x| {
            if acc.len() < 2 {
                acc.push(x);
            } else if acc.last() > acc.first() {
                acc.remove(0);
                acc.push(x);
            } else if x > *acc.last().unwrap() {
                acc.pop();
                acc.push(x);
            }
            acc
        })
        .into_iter()
        .map(|c| c.to_string())
        .collect::<Vec<String>>()
        .join("")
        .parse()
        .unwrap()
}

fn max_output(s: &str) -> u64 {
    s.lines().map(|l| max_joltage(l.trim())).sum()
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    println!("{}", max_output(&contents));
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE_INPUT: &str = "987654321111111
811111111111119
234234234234278
818181911112111";

    #[test]
    fn it_finds_max_joltage() {
        assert_eq!(max_joltage("987654321111111"), 98);
        assert_eq!(max_joltage("811111111111119"), 89);
        assert_eq!(max_joltage("234234234234278"), 78);
        assert_eq!(max_joltage("818181911112111"), 92);
    }

    #[test]
    fn it_finds_max_output() {
        assert_eq!(max_output(SAMPLE_INPUT), 357);
    }
}
