use adventofcode::read_file_or_stdin;

use std::collections::HashSet;
use std::ops::RangeInclusive;
use std::{cmp, env, fmt, io};

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

    pub fn find_all_fresh_ingredients_count(&self) -> i64 {
        self.fresh.iter().map(|r| r.end() + 1 - r.start()).sum()
    }

    pub fn reduce_ranges(&mut self) {
        self.fresh
            .sort_by_key(|i| (i.start().clone(), i.end().clone()));

        self.fresh = self.fresh.iter().fold(Vec::new(), |mut acc, c| {
            if acc.len() == 0 {
                acc.push(c.clone());
            } else if (acc.last().unwrap().end() + 1) >= *c.start() {
                let left = acc.pop().unwrap();
                acc.push(RangeInclusive::new(
                    left.start().clone(),
                    cmp::max(left.end().clone(), c.end().clone()),
                ));
            } else {
                acc.push(c.clone());
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
    fn it_should_reduce_ranges_with_overlaps() {
        let mut db = Database::from_input(
            "23029611009699-23029611009699
23029611009700-27519859263588

0",
        );
        db.reduce_ranges();
        assert_eq!(db.fresh, vec![(23029611009699..=27519859263588)])
    }

    #[test]
    fn it_should_find_all_ingredients_count() {
        let mut db = Database::from_input(SAMPLE_INPUT);
        db.reduce_ranges();
        assert_eq!(db.find_all_fresh_ingredients_count(), 14);
    }
}
