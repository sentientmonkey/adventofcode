use adventofcode::read_file_or_stdin;
use std::{env, io};

fn content_to_grid(content: &str) -> Vec<Vec<char>> {
    content
        .lines()
        .map(|l| l.chars().collect::<Vec<char>>())
        .collect()
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

fn get_count(grid: &Vec<Vec<char>>, x: i32, y: i32) -> i32 {
    let mut count = 0;
    for d in NEIGHBORS {
        let nx = x + d[0];
        let ny = y + d[1];
        if (0..grid.len() as i32).contains(&ny)
            && (0..grid[ny as usize].len() as i32).contains(&nx)
            && grid[ny as usize][nx as usize] == '@'
        {
            count += 1;
        }
    }
    count
}
fn get_adjecent_count(grid: Vec<Vec<char>>) -> i32 {
    let mut adj_count = 0;
    for (y, row) in grid.iter().enumerate() {
        for (x, _) in row.iter().enumerate() {
            if grid[y][x] == '@' {
                let count = get_count(&grid, x as i32, y as i32);
                if count < 4 {
                    adj_count += 1;
                }
            }
        }
    }
    adj_count
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let grid = content_to_grid(&contents);
    let adj = get_adjecent_count(grid);
    println!("{:?}", adj);
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
}
