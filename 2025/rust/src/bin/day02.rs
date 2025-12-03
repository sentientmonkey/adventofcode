use adventofcode::read_file_or_stdin;
use std::{env, io};

type RepeatFn = fn(u64) -> bool;

fn repeats(id: u64) -> bool {
    let s = id.to_string();
    let (first, second) = s.split_at(s.len() / 2);
    if first.len() != second.len() {
        return false;
    }

    first.chars().zip(second.chars()).all(|(a, b)| a == b)
}

fn repeatsn(id: u64) -> bool {
    let s = id.to_string();
    (1..(s.len())).any(|n| {
        s.chars()
            .collect::<Vec<char>>()
            .chunks(n)
            .collect::<Vec<&[char]>>()
            .windows(2)
            .all(|a| a[0] == a[1])
    })
}

fn get_repeating(start: u64, end: u64, f: RepeatFn) -> Vec<u64> {
    (start..end + 1).filter(|id| f(*id)).collect()
}

fn sum_of_repeating(ids: &str, f: RepeatFn) -> u64 {
    ids.trim()
        .split(",")
        .map(|r| {
            let parts: Vec<u64> = r.splitn(2, "-").map(|s| s.parse().unwrap()).collect();
            get_repeating(parts[0], parts[1], f)
        })
        .flatten()
        .sum()
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let sum = sum_of_repeating(&contents, repeats);
    println!("{}", sum);
    let sumn = sum_of_repeating(&contents, repeatsn);
    println!("{}", sumn);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    const SAMPLE_INPUT: &str = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

    #[test]
    fn it_repeats() {
        assert!(repeats(11));
        assert!(!repeats(12));
        assert!(!repeats(21));
        assert!(repeats(22));
    }

    #[test]
    fn it_returns_repeating_ids() {
        assert_eq!(get_repeating(11, 22, repeats), vec![11, 22]);
        assert_eq!(get_repeating(99, 115, repeats), vec![99]);
        assert_eq!(get_repeating(998, 1012, repeats), vec![1010]);
        assert_eq!(
            get_repeating(1188511880, 1188511890, repeats),
            vec![1188511885]
        );
        assert_eq!(get_repeating(222220, 222224, repeats), vec![222222]);
    }

    #[test]
    fn it_returns_sum_of_repeating() {
        assert_eq!(sum_of_repeating(SAMPLE_INPUT, repeats), 1227775554);
    }

    #[test]
    fn it_repeatsn() {
        assert!(repeatsn(55));
        assert!(repeatsn(123123123));
        assert!(repeatsn(12121212121212));
        assert!(repeatsn(1111111));
        assert!(!repeatsn(1234));
    }

    #[test]
    fn it_gets_repeatingn() {
        assert_eq!(get_repeating(11, 22, repeatsn), vec![11, 22]);
        assert_eq!(get_repeating(99, 115, repeatsn), vec![99, 111]);
        assert_eq!(get_repeating(998, 1012, repeatsn), vec![999, 1010]);
        assert_eq!(
            get_repeating(1188511880, 1188511890, repeatsn),
            vec![1188511885]
        );
        assert_eq!(get_repeating(222220, 222224, repeatsn), vec![222222]);
    }

    #[test]
    fn it_returns_sum_of_repeatingn() {
        assert_eq!(sum_of_repeating(SAMPLE_INPUT, repeatsn), 4174379265);
    }
}
