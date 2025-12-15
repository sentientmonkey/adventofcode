use adventofcode::read_file_or_stdin;

use std::ops::RangeInclusive;
use std::{env, io};

#[derive(Debug, PartialEq)]
struct Database {
    pub fresh: Vec<std::ops::RangeInclusive<i64>>,
    pub inventory: Vec<i64>,
}

fn line_to_range(s: &str) -> RangeInclusive<i64> {
    let numbers = s
        .split("-")
        .map(|n| n.parse::<i64>().unwrap())
        .collect::<Vec<i64>>();
    RangeInclusive::new(numbers[0], numbers[1])
}

fn line_to_number(s: &str) -> i64 {
    s.parse::<i64>().unwrap()
}

impl Database {
    pub fn from_input(input: &str) -> Database {
        let mut sections = input.split("\n\n");
        let ranges = sections.next().unwrap();
        let ids = sections.next().unwrap();
        Database {
            fresh: ranges.lines().map(line_to_range).collect(),
            inventory: ids.lines().map(line_to_number).collect(),
        }
    }

    pub fn fresh_ingredients(&self) -> Vec<i64> {
        self.inventory
            .clone()
            .into_iter()
            .filter(|i| self.fresh.clone().into_iter().any(|r| r.contains(i)))
            .collect()
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let db = Database::from_input(&contents);
    let fresh_count = db.fresh_ingredients().len();
    println!("{}", fresh_count);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    const SAMPLE_INPUT: &str = "3-5
10-14
16-20
12-18

1
5
8
11
17
32";

    #[test]
    fn it_should_parse_input() {
        let db = Database::from_input(SAMPLE_INPUT);
        let expected = Database {
            fresh: vec![(3..=5), (10..=14), (16..=20), (12..=18)],
            inventory: vec![1, 5, 8, 11, 17, 32],
        };
        assert_eq!(expected, db);
    }

    #[test]
    fn it_should_find_fresh() {
        let db = Database::from_input(SAMPLE_INPUT);
        assert_eq!(vec![5, 11, 17], db.fresh_ingredients());
    }
}
