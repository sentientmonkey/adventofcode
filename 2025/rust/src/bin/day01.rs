use adventofcode::read_file_or_stdin;
use std::{env, io};

fn move_dial(command: &str, start: i32) -> (i32, i32) {
    let (direction, amount_str) = command.split_at(1);
    let raw_amount: i32 = amount_str.parse().unwrap();
    let amount = raw_amount % 100;
    let wraps = raw_amount / 100;

    let movement = match direction {
        "L" => start - amount,
        "R" => start + amount,
        _ => start,
    };
    let zeros = match direction {
        "L" => {
            if movement <= 0 && start != 0 {
                1
            } else {
                0
            }
        }
        "R" => {
            if movement >= 100 {
                1
            } else {
                0
            }
        }
        _ => 0,
    };
    let position = (movement + 100) % 100;

    (position, zeros + wraps)
}

fn get_password(contents: &str) -> i32 {
    let mut position = 50;
    let mut password = 0;
    contents.lines().for_each(|line| {
        (position, _) = move_dial(line, position);
        if position == 0 {
            password += 1;
        }
    });
    password
}
pub fn get_new_password(contents: &str) -> i32 {
    let mut position = 50;
    let mut password = 0;
    let mut zeros = 0;
    contents.lines().for_each(|line| {
        (position, zeros) = move_dial(line, position);
        password += zeros;
    });
    password
}

#[cfg(test)]
mod tests {
    use super::*;
    const SAMPLE_INPUT: &str = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82";

    fn test_move_dial(command: &str, start: i32, expected: i32) {
        let (result, _) = move_dial(command, start);
        assert_eq!(result, expected);
    }
    fn test_moves_past_zero(command: &str, start: i32, expected: i32) {
        let (_, result) = move_dial(command, start);
        assert_eq!(result, expected);
    }

    #[test]
    fn it_moves_right() {
        test_move_dial("R8", 11, 19);
    }

    #[test]
    fn it_moves_left() {
        test_move_dial("L19", 19, 0);
    }

    #[test]
    fn it_wraps_around() {
        test_move_dial("L10", 5, 95);
    }

    #[test]
    fn it_returns_password() {
        let password = get_password(SAMPLE_INPUT);
        assert_eq!(password, 3);
    }

    #[test]
    fn it_moves_past_zero_left() {
        test_moves_past_zero("L68", 50, 1);
        test_moves_past_zero("L30", 82, 0);
        test_moves_past_zero("R48", 52, 1);
        test_moves_past_zero("L5", 0, 0);
        test_moves_past_zero("R60", 95, 1);
        test_moves_past_zero("L55", 55, 1);
    }

    #[test]
    fn it_returns_new_password() {
        let password = get_new_password(SAMPLE_INPUT);
        assert_eq!(password, 6);
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let password = get_password(&contents);
    println!("{}", password);
    let new_password = get_new_password(&contents);
    println!("{}", new_password);
    Ok(())
}
