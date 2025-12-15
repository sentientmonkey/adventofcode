use adventofcode::read_file_or_stdin;
use std::{env, fmt, io};

fn content_to_grid(content: &str) -> Grid {
    Grid::new(
        content
            .lines()
            .map(|l| l.chars().collect::<Vec<char>>())
            .collect(),
    )
}

const NEIGHBORS: [[i32; 2]; 8] = [
    [-1, -1],
    [0, -1],
    [1, -1],
    [-1, 0],
    [1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
];

#[derive(Clone)]
struct Grid {
    pub elements: Vec<Vec<char>>,
}

impl Grid {
    fn new(elements: Vec<Vec<char>>) -> Grid {
        Grid { elements: elements }
    }

    fn get(&self, x: i32, y: i32) -> Option<char> {
        if self.contains(x, y) {
            Some(self.elements[y as usize][x as usize])
        } else {
            None
        }
    }

    fn set(&mut self, x: i32, y: i32, c: char) {
        self.elements[y as usize][x as usize] = c
    }

    fn contains(&self, x: i32, y: i32) -> bool {
        (0..self.elements.len() as i32).contains(&y)
            && (0..self.elements[y as usize].len() as i32).contains(&x)
    }

    fn get_count(&self, x: i32, y: i32) -> i32 {
        let mut count = 0;
        for d in NEIGHBORS {
            let nx = x + d[0];
            let ny = y + d[1];
            match self.get(nx, ny) {
                Some('@') => {
                    count += 1;
                }
                _ => {}
            }
        }
        count
    }

    fn get_adjecent_count(&self) -> i32 {
        let mut adj_count = 0;
        for (y, row) in self.elements.iter().enumerate() {
            for (x, _) in row.iter().enumerate() {
                if self.get(x as i32, y as i32).unwrap() == '@' {
                    let count = self.get_count(x as i32, y as i32);
                    if count < 4 {
                        adj_count += 1;
                    }
                }
            }
        }
        adj_count
    }
    fn remove_rolls(&self) -> (i32, Self) {
        let mut remove_count = 0;
        let mut new_grid = self.clone();
        for (y, row) in self.elements.iter().enumerate() {
            for (x, _) in row.iter().enumerate() {
                match new_grid.get(x as i32, y as i32) {
                    Some('@') => {
                        let count = new_grid.get_count(x as i32, y as i32);
                        if count < 4 {
                            new_grid.set(x as i32, y as i32, 'x');
                            remove_count += 1;
                        }
                    }
                    Some('x') => {
                        new_grid.set(x as i32, y as i32, '.');
                    }
                    _ => {}
                }
            }
        }
        (remove_count, new_grid)
    }

    fn remove_all_rolls(&self) -> i32 {
        let mut removed: i32 = 0;
        let (mut count, mut new_grid) = self.remove_rolls();
        removed += count;
        while count > 0 {
            (count, new_grid) = new_grid.clone().remove_rolls();
            //println!("count = {}", count);
            //println!("{}", new_grid);
            removed += count;
        }
        removed
    }
}

impl fmt::Display for Grid {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for row in self.elements.iter() {
            for cell in row.iter() {
                write!(f, "{}", cell)?;
            }
            write!(f, "\n")?;
        }
        Ok(())
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let grid = content_to_grid(&contents);
    let adj = grid.get_adjecent_count();
    println!("{:?}", adj);
    let removed = grid.remove_all_rolls();
    println!("{:?}", removed);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    const SAMPLE_INPUT: &str = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.";

    #[test]
    fn it_should_remove_all_rolls() {
        let grid = content_to_grid(SAMPLE_INPUT);
        let count = grid.remove_all_rolls();
        assert_eq!(count, 43);
    }
}
