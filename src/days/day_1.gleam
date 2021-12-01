import gleam/list
import gleam/int
import gleam/io
import gleam/iterator
import gleam/string

pub fn run(input) {
  let input = process_input(input)
  #(pt_1(input), pt_2(input))
}

fn process_input(s: String) -> List(Int) {
  assert Ok(nums) =
    s
    |> string.split("\n")
    |> list.try_map(int.parse)

  nums
}

fn pt_1(input: List(Int)) -> Int {
  input
  |> list.window_by_2()
  |> list.fold(
    0,
    fn(acc: Int, pair: #(Int, Int)) {
      case pair.1 - pair.0 > 0 {
        True -> acc + 1
        False -> acc
      }
    },
  )
}

fn pt_2(input: List(Int)) -> Int {
  input
  |> list.window(by: 3)
  |> list.map(int.sum)
  |> pt_1()
}
