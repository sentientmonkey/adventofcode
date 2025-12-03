use std::{
    fs::File,
    io::{self, Read},
};

pub fn read_file_or_stdin(path: &str) -> io::Result<String> {
    let mut reader: Box<dyn Read> = if path == "-" {
        Box::new(io::stdin())
    } else {
        Box::new(File::open(path)?)
    };

    let mut contents = String::new();
    reader.read_to_string(&mut contents)?;
    Ok(contents)
}
