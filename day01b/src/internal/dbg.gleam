import dot_env/env
import gleam/io

pub fn print(input: a) -> a {
  case env.get_bool("DEBUG") {
    Ok(True) -> io.debug(input)
    _ -> input
  }
}
