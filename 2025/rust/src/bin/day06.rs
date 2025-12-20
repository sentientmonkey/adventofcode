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

#[derive(Debug, PartialEq)]
struct Stack {
    pub values: Vec<Value>,
}

impl Stack {
    pub fn new() -> Self {
        Stack { values: Vec::new() }
    }

    fn eval(self: &Stack) -> Result<i64, &str> {
        let mut stack = self.values.clone();
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
}

#[derive(Debug)]
struct Calculator {
    pub stacks: Vec<Stack>,
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

impl Calculator {
    fn new() -> Self {
        Calculator { stacks: Vec::new() }
    }

    fn total(&self) -> Result<i64, &str> {
        self.stacks.iter().map(|s| s.eval()).sum()
    }
}

impl FromStr for Calculator {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, String> {
        let mut calculators = Calculator::new();

        for (i, line) in s.lines().enumerate() {
            for (j, tok) in line.split_whitespace().enumerate() {
                if i == 0 {
                    calculators.stacks.push(Stack::new());
                }
                calculators.stacks[j]
                    .values
                    .push(tok.parse::<Value>().unwrap());
            }
        }

        Ok(calculators)
    }
}

fn main() -> io::Result<()> {
    let input = env::args().nth(1).unwrap_or_else(|| "-".to_string());
    let contents = read_file_or_stdin(&input)?;
    let calculator = Calculator::from_str(&contents).expect("To parse input");
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
        let calc = SAMPLE_INPUT.parse::<Calculator>().expect("Failed to parse");
        let first = vec![
            Value::Num(123),
            Value::Num(45),
            Value::Num(6),
            Value::Op(Op::Multiply),
        ];
        assert_eq!(calc.stacks[0].values, first);
    }

    #[test]
    fn it_should_eval_stack() {
        let calc = SAMPLE_INPUT.parse::<Calculator>().expect("Failed to parse");

        assert_eq!(calc.stacks[0].eval(), Ok(33210));
        assert_eq!(calc.stacks[1].eval(), Ok(490));
        assert_eq!(calc.stacks[2].eval(), Ok(4243455));
        assert_eq!(calc.stacks[3].eval(), Ok(401));
    }

    #[test]
    fn it_should_total_stack() {
        let calc = SAMPLE_INPUT.parse::<Calculator>().expect("Failed to parse");

        assert_eq!(calc.total(), Ok(4277556));
    }
}
