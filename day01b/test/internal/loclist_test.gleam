import gleam/list
import gleam/result
import gleeunit/should
import internal/loclist

const empty_seq = []

const left_seq = [1, 2, 3]

const right_seq = [10, 0, 1]

const dist_seq = [1, 1, 7]

const dist_total = 9

// gleeunit test functions end in `_test`
pub fn new_uneven_test() {
  let result = loclist.new(left_seq, empty_seq)

  result |> should.equal(Error(loclist.UnevenListsError(3, 0)))
}

pub fn new_dist_test() {
  loclist.new(left_seq, right_seq)
  |> result.unwrap([])
  |> list.map(fn(loc) { loc.distance })
  |> should.equal(dist_seq)
}

pub fn total_distance_test() {
  loclist.new(left_seq, right_seq)
  |> result.unwrap([])
  |> loclist.total_distance
  |> should.equal(dist_total)
}
