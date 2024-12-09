import gleam/int
import gleam/io
import gleam/result
import gleam/string
import internal/loclist
import internal/locparse

pub fn main() {
  io.println("Day 01")
  case get_distance_msg() {
    Ok(msg) -> io.println(msg)
    Error(err) -> {
      io.println("Failed to get distance")
      io.debug(err)
      Nil
    }
  }
}

fn get_distance_msg() {
  use loc_seq <- result.try(locparse.read("input.txt"))
  let dist = loclist.total_distance(loc_seq)
  let msg = string.concat(["Total distance: ", int.to_string(dist)])
  Ok(msg)
}
