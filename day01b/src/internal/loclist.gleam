import gleam/int
import gleam/list

pub type Error {
  UnevenListsError(left_size: Int, right_size: Int)
}

pub type LocPair {
  LocDist(left: Int, right: Int, distance: Int)
}

pub fn new(left: List(Int), right: List(Int)) -> Result(List(LocPair), Error) {
  case list.length(left), list.length(right) {
    lsize, rsize if lsize != rsize -> Error(UnevenListsError(lsize, rsize))
    _, _ -> {
      let sorted_left = list.sort(left, int.compare)
      let sorted_right = list.sort(right, int.compare)

      let loclist =
        list.map2(sorted_left, sorted_right, fn(left, right) {
          LocDist(left, right, int.absolute_value(left - right))
        })

      Ok(loclist)
    }
  }
}

pub fn total_distance(locs: List(LocPair)) -> Int {
  list.fold(locs, 0, fn(acc, loc) { loc.distance + acc })
}
