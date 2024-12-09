import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError}
import gleam/int
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import gleam/yielder.{type Yielder}
import internal/dbg
import internal/loclist

pub type Error {
  DataSchemaError(loclist.Error)
  IOError(FileStreamError)
  ParseError(String)
  ListError(loclist.Error)
}

pub fn read(path: String) {
  let tryio = fn(res: Result(a, FileStreamError), with) {
    result.map_error(res, IOError(_))
    |> result.try(with)
  }
  let tryloc = fn(res, with) {
    result.map_error(res, ListError(_))
    |> result.try(with)
  }

  use stream <- tryio(file_stream.open_read(path))
  let res_seqs =
    read_lines(stream)
    |> yielder.map(parse)
    |> yielder.filter(fn(res) {
      case res {
        Ok(_) -> True
        Error(err) -> {
          dbg.print(err)
          True
        }
      }
    })
    |> yielder.fold(Ok(#([], [])), fn(acc, plocs) {
      use #(lloc, rloc) <- result.try(plocs)
      use #(left, right) <- result.try(acc)
      Ok(#([lloc, ..left], [rloc, ..right]))
    })
  use _ <- tryio(file_stream.close(stream))
  use #(left_seq, right_seq) <- result.try(res_seqs)
  use loc_seq <- tryloc(loclist.new(left_seq, right_seq))
  Ok(loc_seq)
}

fn read_lines(stream: FileStream) -> Yielder(String) {
  yielder.unfold(stream, fn(stream) {
    case file_stream.read_line(stream) {
      Ok(line) -> yielder.Next(line, stream)
      Error(_) -> yielder.Done
    }
  })
}

fn parse(line: String) -> Result(#(Int, Int), Error) {
  let assert Ok(re) = regexp.from_string("\\s*([0-9]+)\\s+([0-9]+)\\s*")
  let matches = regexp.scan(with: re, content: line)
  dbg.print(matches)

  case matches {
    [regexp.Match(_, [Some(m1), Some(m2)])] -> {
      let tryln = fn(res, with) {
        result.replace_error(res, ParseError(line))
        |> result.try(with)
      }

      use left <- tryln(int.parse(m1))
      use right <- tryln(int.parse(m2))
      Ok(#(left, right))
    }
    _ -> Error(ParseError(line))
  }
}
