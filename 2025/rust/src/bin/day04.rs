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

fn print_grid(grid: &Vec<Vec<char>>) {
    for row in grid.iter() {
        for cell in row.iter() {
            print!("{}", cell);
        }
        print!("\n");
    }
    print!("\n");
}

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

fn remove_rolls(grid: Vec<Vec<char>>) -> (i32, Vec<Vec<char>>) {
    let mut remove_count = 0;
    let mut new_grid = grid.clone();
    for (y, row) in grid.iter().enumerate() {
        for (x, _) in row.iter().enumerate() {
            match new_grid[y][x] {
                '@' => {
                    let count = get_count(&new_grid, x as i32, y as i32);
                    if count < 4 {
                        new_grid[y][x] = 'x';
                        remove_count += 1;
                    }
                }
                'x' => {
                    new_grid[y][x] = '.';
                }
                _ => {}
            }
        }
    }
    (remove_count, new_grid)
}

fn remove_all_rolls(grid: Vec<Vec<char>>) -> i32 {
    let mut removed: i32 = 0;
    let (mut count, mut new_grid) = remove_rolls(grid);
    removed += count;
    while count > 0 {
        (count, new_grid) = remove_rolls(new_grid.clone());
        //println!("count = {}", count);
        //print_grid(&new_grid);
        removed += count;
    }
    removed
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let grid = content_to_grid(&contents);
    let adj = get_adjecent_count(grid.clone());
    println!("{:?}", adj);
    let removed = remove_all_rolls(grid);
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
        let count = remove_all_rolls(grid);
        assert_eq!(count, 43);
    }
}
