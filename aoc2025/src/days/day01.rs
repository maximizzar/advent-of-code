// SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
//
// SPDX-License-Identifier: GPL-3.0-or-later

use std::{fmt, io};
use std::io::BufRead;

#[derive(Debug)]
struct Dial(u8); // 0..99

impl Dial {
    fn new(value: u8) -> Self {
        Self(value % 100)
    }

    fn rotate(&mut self, rotation: &str) -> Result<(), String> {
        if rotation.len() < 2 {
            return Err("Rotation too short".to_string());
        }

        let dir = rotation.chars().next().unwrap();
        let dist: u32 = rotation[1..]
            .parse()
            .map_err(|_| "Invalid distance".to_string())?;

        match dir {
            'L' => self.0 = ((100 + self.0 as u32 - (dist % 100)) % 100) as u8,
            'R' => self.0 = ((self.0 as u32 + (dist % 100)) % 100) as u8,
            _ => return Err("Invalid direction, must be L or R".to_string()),
        }

        Ok(())
    }

    fn value(&self) -> u8 {
        self.0
    }
}

impl fmt::Display for Dial {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

pub fn part1(_input: &str) {
    let stdin = io::stdin();
    let mut dial = Dial::new(50);
    let mut password: u16 = 0;

    for line in stdin.lock().lines() {
        if let Ok(rotation_string) = line {
            if let Err(e) = dial.rotate(rotation_string.as_str().trim()) {
                println!("Error: {}", e);
            } else {
                if dial.value() == 0 {
                    password += 1;
                }
            }
        }
    }
    println!("The password is: {}", password);
}
