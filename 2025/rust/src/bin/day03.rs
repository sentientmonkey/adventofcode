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

fn max_joltagen(bank: &str, size: usize) -> u64 {
    bank.chars()
        .map(|s| s.to_digit(10).unwrap())
        .fold(Vec::new(), |acc, x| {
            let mut a = acc.clone();
            if a.len() < size {
                a.push(x);
            } else {
                for (i, n) in a.clone().iter().enumerate() {
                    println!("i = {}, n = {}, x = {}", i, n, x);
                    println!("a = {:?}", a);
                    if i < a.len() - 1 && *n < a[i + 1] {
                        a.remove(i);
                        a.insert(i, *n);
                        break;
                    }
                    if i == a.len() - 1 && x > *n {
                        a.pop();
                        a.push(x);
                        break;
                    }
                }
            }
            a
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

    #[test]
    fn it_finds_max_joltagn() {
        assert_eq!(max_joltagen("987654321111111", 12), 987654321111);
        assert_eq!(max_joltagen("811111111111119", 12), 811111111119);
        assert_eq!(max_joltagen("234234234234278", 12), 434234234278);
    }
}
