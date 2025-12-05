use adventofcode::read_file_or_stdin;
use std::{env, io};

fn max_joltagen(bank: &str, size: usize) -> u64 {
    bank.chars()
        .map(|s| s.to_digit(10).unwrap())
        .fold(Vec::new(), |mut acc, x| {
            acc.push(x);
            if acc.len() > size {
                for i in 0..(acc.len()) {
                    if i == (acc.len() - 1) || acc[i] < acc[i + 1] {
                        acc.remove(i);
                        break;
                    }
                }
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

fn max_outputn(s: &str, n: usize) -> u64 {
    s.lines().map(|l| max_joltagen(l.trim(), n)).sum()
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    println!("{}", max_outputn(&contents, 2));
    println!("{}", max_outputn(&contents, 12));
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
        assert_eq!(max_joltagen("987654321111111", 2), 98);
        assert_eq!(max_joltagen("811111111111119", 2), 89);
        assert_eq!(max_joltagen("234234234234278", 2), 78);
        assert_eq!(max_joltagen("818181911112111", 2), 92);
    }

    #[test]
    fn it_finds_max_output() {
        assert_eq!(max_outputn(SAMPLE_INPUT, 2), 357);
    }

    #[test]
    fn it_finds_max_joltagn() {
        assert_eq!(max_joltagen("987654321111111", 12), 987654321111);
        assert_eq!(max_joltagen("811111111111119", 12), 811111111119);
        assert_eq!(max_joltagen("234234234234278", 12), 434234234278);
        assert_eq!(max_joltagen("818181911112111", 12), 888911112111);
    }

    #[test]
    fn it_finds_max_outputn() {
        assert_eq!(max_outputn(SAMPLE_INPUT, 12), 3121910778619);
    }
}
