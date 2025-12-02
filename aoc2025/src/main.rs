// SPDX-FileCopyrightText: 2025 maximizzar <mail@maximizzar.de>
//
// SPDX-License-Identifier: GPL-3.0-or-later

mod days;

use clap::{Parser, Subcommand};
use days::*;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
	#[arg(short, long, global = true)]
	///Use Logic for Part 2
	part_2: bool,
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
		Commands::Day01 => day01::main(cli.part_2),
		Commands::Day02 => day02::part1("day02"),
	}
}
