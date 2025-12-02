use std::{
    env,
    fs::File,
    io::{self, Read},
};

fn read_file_or_stdin(path: &str) -> io::Result<String> {
    let mut reader: Box<dyn Read> = if path == "-" {
        Box::new(io::stdin())
    } else {
        Box::new(File::open(path)?)
    };

    let mut contents = String::new();
    reader.read_to_string(&mut contents)?;
    Ok(contents)
}

fn repeats(id: u64) -> bool {
    let s = id.to_string();
    let (first, second) = s.split_at(s.len() / 2);
    if first.len() != second.len() {
        return false;
    }

    first.chars().zip(second.chars()).all(|(a, b)| a == b)
}

fn get_repeating(start: u64, end: u64) -> Vec<u64> {
    (start..end + 1).filter(|id| repeats(*id)).collect()
}

fn sum_of_repeating(ids: &str) -> u64 {
    ids.trim()
        .split(",")
        .map(|r| {
            let parts: Vec<u64> = r.splitn(2, "-").map(|s| s.parse().unwrap()).collect();
            get_repeating(parts[0], parts[1])
        })
        .flatten()
        .sum()
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let sum = sum_of_repeating(&contents);
    println!("{}", sum);
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
        assert_eq!(get_repeating(11, 22), vec![11, 22]);
        assert_eq!(get_repeating(99, 115), vec![99]);
        assert_eq!(get_repeating(998, 1012), vec![1010]);
        assert_eq!(get_repeating(1188511880, 1188511890), vec![1188511885]);
        assert_eq!(get_repeating(222220, 222224), vec![222222]);
    }

    #[test]
    fn it_returns_sum_of_repeating() {
        assert_eq!(sum_of_repeating(SAMPLE_INPUT), 1227775554);
    }
}
