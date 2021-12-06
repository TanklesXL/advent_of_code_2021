import gleam/string
import gleam/map.{Map}
import gleam/list
import gleam/int
import gleam/io
import gleam/pair
import gleam/function.{compose}
import gleam/order.{Eq, Gt, Lt}

pub fn run(input) {
  let input = process_input(input)
  #(pt_1(input), pt_2(input))
}

fn process_input(input: String) -> List(List(Int)) {
  assert Ok(input) =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.try_map(fn(line) { list.try_map(line, int.parse) })

  input
  |> list.transpose()
}

external fn string_to_integer(String, Int) -> Int =
  "erlang" "binary_to_integer"

fn gamma_list(input: List(List(Int))) -> List(Int) {
  input
  |> list.map(fn(column) {
    list.fold(
      column,
      0,
      fn(acc, elem) {
        acc + case elem {
          1 -> 1
          0 -> -1
        }
      },
    )
    |> int.clamp(min: 0, max: 1)
  })
}

fn epsilon_list(from gamma_list: List(Int)) -> List(Int) {
  list.map(
    gamma_list,
    fn(i) {
      case i {
        0 -> 1
        1 -> 0
      }
    },
  )
}

fn compress(l: List(Int)) -> Int {
  l
  |> list.map(int.to_string)
  |> string.concat()
  |> string_to_integer(2)
}

fn pt_1(input: List(List(Int))) -> Int {
  let gamma_list = gamma_list(input)
  let gamma = compress(gamma_list)

  let epsilon =
    gamma_list
    |> epsilon_list()
    |> compress()

  gamma * epsilon
}

fn pt_2(input: List(List(Int))) -> Int {
  0
}
