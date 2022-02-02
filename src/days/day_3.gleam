import gleam/string
import gleam/map
import gleam/list
import gleam/int.{InvalidBase}
import gleam/io
import gleam/result
import gleam/pair
import gleam/function
import gleam/order
import ffi/array.{Array}

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
}

fn pt_1(input: List(List(Int))) -> Int {
  let gamma_list =
    input
    |> list.transpose()
    |> list.map(most_common_bit)

  assert Ok(gamma) = undigits(gamma_list, 2)

  assert Ok(epsilon) =
    gamma_list
    |> list.map(fn(i) { 1 - i })
    |> undigits(2)

  gamma * epsilon
}

fn most_common_bit(l: List(Int)) -> Int {
  list.fold(
    l,
    1,
    fn(acc, elem) {
      acc + case elem {
        1 -> 1
        0 -> -1
      }
    },
  )
  |> int.clamp(min: 0, max: 1)
}

fn least_common_bit(l: List(Int)) -> Int {
  1 - most_common_bit(l)
}

fn sieve(
  input: List(Array(a)),
  index: Int,
  finding: fn(List(a)) -> a,
) -> Result(List(a), Nil) {
  case input {
    [] -> Error(Nil)
    [res] -> Ok(array.to_list(res))
    _ -> {
      let to_find =
        input
        |> list.map(array.get(index, _))
        |> finding()
      input
      |> list.filter(fn(line) { array.get(index, line) == to_find })
      |> sieve(index + 1, finding)
    }
  }
}

fn pt_2(input: List(List(Int))) -> Int {
  let input = list.map(input, array.from_list)

  assert Ok(oxygen) = sieve(input, 0, most_common_bit)
  assert Ok(oxygen) = undigits(oxygen, 2)

  assert Ok(co2) = sieve(input, 0, least_common_bit)
  assert Ok(co2) = undigits(co2, 2)

  oxygen * co2
}

pub fn undigits(numbers: List(Int), base: Int) -> Result(Int, InvalidBase) {
  case base < 2 {
    True -> Error(InvalidBase)
    False -> do_undigits(numbers, base, 0)
  }
}

fn do_undigits(
  numbers: List(Int),
  base: Int,
  acc: Int,
) -> Result(Int, InvalidBase) {
  case numbers {
    [] -> Ok(acc)
    [digit, ..] if digit >= base -> Error(InvalidBase)
    [digit, ..rest] -> do_undigits(rest, base, acc * base + digit)
  }
}
