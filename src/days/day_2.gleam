import gleam/list
import gleam/int
import gleam/io
import gleam/iterator.{Iterator}
import gleam/string

pub fn run(input) {
  let input = process_input(input)
  #(pt_1(input), pt_2(input))
}

type Move {
  Up(Int)
  Down(Int)
  Forward(Int)
}

fn process_input(s: String) -> Iterator(Move) {
  s
  |> string.split("\n")
  |> iterator.from_list()
  |> iterator.map(fn(line: String) -> Move {
    assert [direction, steps] = string.split(line, " ")
    assert Ok(steps) = int.parse(steps)

    case direction {
      "up" -> Up(steps)
      "down" -> Down(steps)
      "forward" -> Forward(steps)
    }
  })
}

type Position {
  Position(depth: Int, horizontal: Int, aim: Int)
}

fn pt_1(input: Iterator(Move)) -> Int {
  let end =
    iterator.fold(
      input,
      Position(depth: 0, horizontal: 0, aim: 0),
      fn(from pos: Position, do move: Move) -> Position {
        case move {
          Up(steps) -> Position(..pos, depth: pos.depth - steps)
          Down(steps) -> Position(..pos, depth: pos.depth + steps)
          Forward(steps) -> Position(..pos, horizontal: pos.horizontal + steps)
        }
      },
    )
  end.depth * end.horizontal
}

fn pt_2(input: Iterator(Move)) -> Int {
  let end =
    iterator.fold(
      input,
      Position(depth: 0, horizontal: 0, aim: 0),
      fn(from pos: Position, do move: Move) -> Position {
        case move {
          Up(steps) -> Position(..pos, aim: pos.aim - steps)
          Down(steps) -> Position(..pos, aim: pos.aim + steps)
          Forward(steps) ->
            Position(
              ..pos,
              horizontal: pos.horizontal + steps,
              depth: pos.depth + pos.aim * steps,
            )
        }
      },
    )
  end.depth * end.horizontal
}
