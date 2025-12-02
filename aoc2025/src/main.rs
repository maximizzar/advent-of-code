// SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
//
// SPDX-License-Identifier: GPL-3.0-or-later

mod days;

use clap::{Parser, Subcommand};
use days::*;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
	#[command(subcommand)]
	command: Commands,
}

#[derive(Subcommand)]
enum Commands {
	///Secret Entrance
	Day01,
	///Gift Shop
	Day02
}

fn main() {
	println!("AoC 2025!");
	let cli = Cli::parse();
	match &cli.command {
		Commands::Day01 { .. } => {
			println!("Day 01");
			day01::part1("day01");
		}
		Commands::Day02 {} => {
			println!("Day 02");
			day02::part1("day02");
		}
	}
}
