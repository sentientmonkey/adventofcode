use adventofcode::read_file_or_stdin;

use std::cmp::{max, min};
use std::ops::RangeInclusive;
use std::{env, fmt, io};

trait RangeOverlap {
    fn overlaps(&self, other: &Self) -> bool;
}

impl RangeOverlap for RangeInclusive<i64> {
    fn overlaps(&self, other: &Self) -> bool {
        (self.start() <= other.end()) & (other.start() <= self.end())
    }
}

trait RangeMerge {
    fn merge(&self, other: &Self) -> Self;
}

impl RangeMerge for RangeInclusive<i64> {
    fn merge(&self, other: &Self) -> Self {
        let min_start = min(self.start().clone(), other.start().clone());
        let max_end = max(self.end().clone(), other.end().clone());
        min_start..=max_end
    }
}

#[derive(Debug, PartialEq)]
struct Database {
    pub fresh: Vec<RangeInclusive<i64>>,
    pub inventory: Vec<i64>,
}

fn line_to_range(s: &str) -> RangeInclusive<i64> {
    let numbers = s
        .split("-")
        .map(|n| n.parse::<i64>().unwrap())
        .collect::<Vec<i64>>();
    numbers[0]..=numbers[1]
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

    pub fn find_all_fresh_ingredients_count(&self) -> i64 {
        self.fresh.iter().map(|r| r.end() + 1 - r.start()).sum()
    }

    pub fn reduce_ranges(&mut self) {
        self.fresh
            .sort_by_key(|i| (i.start().clone(), i.end().clone()));

        self.fresh = self.fresh.iter().fold(Vec::new(), |mut acc, c| {
            match acc.last_mut() {
                Some(left) if left.overlaps(&c) => {
                    *left = left.merge(&c);
                }
                _ => {
                    acc.push(c.clone());
                }
            }
            acc
        });
    }
}

impl fmt::Display for Database {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(f, "fresh:")?;
        for row in self.fresh.iter() {
            writeln!(f, "{}-{}", row.start(), row.end())?;
        }
        Ok(())
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let mut db = Database::from_input(&contents);
    let count = db.fresh_ingredients().len();
    println!("{}", count);
    db.reduce_ranges();
    let count = db.find_all_fresh_ingredients_count();
    println!("{}", count);
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

    #[test]
    fn it_should_reduce_ranges() {
        let mut db = Database::from_input(SAMPLE_INPUT);
        db.reduce_ranges();
        assert_eq!(db.fresh, vec![(3..=5), (10..=20)])
    }

    #[test]
    fn it_should_reduce_ranges_with_edge_case() {
        let mut db = Database::from_input(
            "3-5
10-14
16-20
12-18
9-21

0",
        );
        db.reduce_ranges();
        assert_eq!(db.fresh, vec![(3..=5), (9..=21)]);
        assert_eq!(db.find_all_fresh_ingredients_count(), 16);
    }

    #[test]
    fn it_should_find_all_ingredients_count() {
        let mut db = Database::from_input(SAMPLE_INPUT);
        db.reduce_ranges();
        assert_eq!(db.find_all_fresh_ingredients_count(), 14);
    }

    #[test]
    fn it_should_impl_range_overlap() {
        assert_eq!((3..=5).overlaps(&(6..=7)), false);
        assert_eq!((3..=5).overlaps(&(5..=7)), true);
        assert_eq!((5..=7).overlaps(&(3..=5)), true);
        assert_eq!((6..=7).overlaps(&(3..=5)), false);
    }
}
