import gleeunit/should
import internal/loclist
import internal/locparse

pub fn read_broken_test() {
  locparse.read("test/internal/locparse_data/broken.txt")
  |> should.be_error
}

pub fn read_empty_test() {
  locparse.read("test/internal/locparse_data/empty.txt")
  |> should.equal(Ok([]))
}

pub fn read_ok_test() {
  let assert Ok(loc_seq) = loclist.new([1, 2, 3], [10, 0, 1])

  locparse.read("test/internal/locparse_data/ok.txt")
  |> should.equal(Ok(loc_seq))
}
