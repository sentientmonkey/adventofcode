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

fn move_dial(command: &str, start: u32) -> u32 {
    let (direction, amount_str) = command.split_at(1);
    let mut amount: u32 = amount_str.parse().unwrap();
    amount = amount % 100;

    match direction {
        "L" => (start + 100 - amount) % 100,
        "R" => (start + amount) % 100,
        _ => start,
    }
}

fn get_password(contents: &str) -> u32 {
    let mut position = 50;
    let mut password = 0;
    contents.lines().for_each(|line| {
        position = move_dial(line, position);
        if position == 0 {
            password += 1;
        }
    });
    password
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_move_dial(command: &str, start: u32, expected: u32) {
        let result = move_dial(command, start);
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
        let contents = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82";
        let password = get_password(contents);
        assert_eq!(password, 3);
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let password = get_password(&contents);
    println!("{}", password);
    Ok(())
}
