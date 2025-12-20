use adventofcode::read_file_or_stdin;
use std::{env, io};

use std::str::FromStr;

#[derive(Clone, Debug, PartialEq)]
enum Op {
    Multiply,
    Add,
}

#[derive(Clone, Debug, PartialEq)]
enum Value {
    Num(i64),
    Op(Op),
}

impl FromStr for Value {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, String> {
        Ok(match s {
            "*" => Value::Op(Op::Multiply),
            "+" => Value::Op(Op::Add),
            s => Value::Num(s.parse::<i64>().expect("nope")),
        })
    }
}

#[derive(Debug)]
struct Calculators {
    pub stacks: Vec<Vec<Value>>,
}

fn read_op(val: Option<Value>) -> Result<Op, &'static str> {
    match val {
        Some(Value::Op(op)) => Ok(op),
        _ => Err("Expected operation"),
    }
}

fn read_num(val: Option<Value>) -> Result<i64, &'static str> {
    match val {
        Some(Value::Num(n)) => Ok(n),
        _ => Err("Expected number"),
    }
}

fn eval(s: &Vec<Value>) -> Result<i64, &str> {
    let mut stack = s.clone();
    let op = read_op(stack.pop())?;
    let val = read_num(stack.pop())?;

    let result = stack.iter().fold(val, |mut acc, val| {
        let n = read_num(Some(val.clone())).expect("num");
        match op {
            Op::Multiply => acc *= n,
            Op::Add => acc += n,
        };
        acc
    });
    Ok(result)
}

impl Calculators {
    fn new() -> Self {
        Calculators { stacks: Vec::new() }
    }

    fn total(&self) -> Result<i64, &str> {
        self.stacks.iter().map(|s| eval(&s)).sum()
    }
}

impl FromStr for Calculators {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, String> {
        let mut calculators = Calculators::new();

        for (i, line) in s.lines().enumerate() {
            for (j, tok) in line.split_whitespace().enumerate() {
                if i == 0 {
                    calculators.stacks.push(Vec::new());
                }
                calculators.stacks[j].push(tok.parse::<Value>().unwrap());
            }
        }

        Ok(calculators)
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let calculator = Calculators::from_str(&contents).expect("To parse input");
    let total = calculator.total().expect("To calculate total");
    println!("{}", total);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    const SAMPLE_INPUT: &str = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  ";

    #[test]
    fn it_should_parse_into_calculators() {
        let calc = SAMPLE_INPUT
            .parse::<Calculators>()
            .expect("Failed to parse");
        let first: Vec<Value> = vec![
            Value::Num(123),
            Value::Num(45),
            Value::Num(6),
            Value::Op(Op::Multiply),
        ];
        assert_eq!(calc.stacks[0], first);
    }

    #[test]
    fn it_should_eval_stack() {
        let calc = SAMPLE_INPUT
            .parse::<Calculators>()
            .expect("Failed to parse");

        assert_eq!(eval(&calc.stacks[0]), Ok(33210));
        assert_eq!(eval(&calc.stacks[1]), Ok(490));
        assert_eq!(eval(&calc.stacks[2]), Ok(4243455));
        assert_eq!(eval(&calc.stacks[3]), Ok(401));
    }

    #[test]
    fn it_should_total_stack() {
        let calc = SAMPLE_INPUT
            .parse::<Calculators>()
            .expect("Failed to parse");

        assert_eq!(calc.total(), Ok(4277556));
    }
}
