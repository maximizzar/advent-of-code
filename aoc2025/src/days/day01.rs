// SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
//
// SPDX-License-Identifier: GPL-3.0-or-later
use std::io;
use std::io::{BufRead};
use std::str::FromStr;
use Direction::{Left, Right};

struct Dial {
    position: i64,
    min: i64,
    max: i64,
    zero_passes: i64,
}

impl Dial {
    fn new(position: i64, min: i64, max: i64) -> Self {
        Self{position, min, max, zero_passes: 0 }
    }
    fn rotate(&mut self, rotation: Rotation) {
        let range = self.max - self.min + 1;

        let full_rotations = rotation.rotations / range;
        let partial_rotations = rotation.rotations % range;

        println!("full_rotations: {}", full_rotations);
        println!("partial_rotations: {}", partial_rotations);

        let zero_based = self.position - self.min;
        let extra_passes = match rotation.direction {
            Left => if zero_based - partial_rotations < 0 { 1 } else { 0 },
            Right => if zero_based + partial_rotations >= range { 1 } else { 0 },
        };

        // Update total zero passes
        self.zero_passes += full_rotations + extra_passes;

        // Update Dial position
        self.position = match rotation.direction {
            Left => (zero_based - partial_rotations).rem_euclid(range) + self.min,
            Right => (zero_based + partial_rotations).rem_euclid(range) + self.min,
        };
    }
}

enum Direction {
    Left,
    Right,
}

struct Rotation {
    direction: Direction,
    rotations: i64,
}

impl Rotation {
    fn new(direction: Direction, rotations: i64) -> Self {
        Self{direction, rotations}
    }
}

impl FromStr for Rotation {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let dir_char = s.chars().next().unwrap();
        let num_str = &s[1..];
        let num = num_str.parse().map_err(|_|
            format!("Invalid number: {}", num_str))?;

        let direction: Result<Direction, Self::Err> = match dir_char {
            'L' => {
                Ok(Left)
            },
            'R' => {
                Ok(Right)
            }
            _ => {
                Err("Invalid direction".to_string())?

            }
        };
        Ok(Self::new(direction?, num))
    }
}

fn process_line(dial: &mut Dial, line: &str) -> usize {
    if let Ok(rotation) = Rotation::from_str(line) {
        dial.rotate(rotation);
        if dial.position == 0 {
            return 1usize
        }
    }
    0usize
}

pub fn main(part2: bool) {
    let stdin = io::stdin();
    let mut dial = Dial::new(50, 0, 99);
    let mut password: usize = 0;

    println!("The dial starts by pointing at {}", dial.position);
    for line in stdin.lock().lines() {
        if let Ok(rotation_string) = line {
            password += process_line(&mut dial, rotation_string.as_str());
            println!("{}", dial.position);
        }
    }
    match part2 {
        true => println!("{}", dial.zero_passes),
        false => println!("{}", password),
    }
}
