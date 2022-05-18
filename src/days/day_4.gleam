import gleam/string
import gleam/list
import gleam/int
import gleam/result
import gleam/iterator
import gleam/function.{compose}
import gleam/map.{Map}
import gleam/set.{Set}

pub fn run(input) {
  let #(calls, boards) = process_input(input)
  #(pt_1(calls, boards), pt_2(input))
}

type Pos {
  Pos(row: Int, column: Int)
}

type Board {
  Board(spaces: Map(Int, Pos), hits: Set(Pos))
}

type Play {
  Play(Board)
  Bingo(List(Int))
}

fn process_input(input) {
  assert [calls, ..boards] = string.split(input, "\n\n")
  assert Ok(calls) =
    calls
    |> string.split(",")
    |> list.try_map(int.parse)

  let boards =
    boards
    |> iterator.from_list()
    |> iterator.map(string.split(_, "\n"))
    |> iterator.map(list.map(_, compose(
      string.split(_, " "),
      list.filter_map(_, int.parse),
    )))
    |> iterator.map(build_board)
    |> iterator.map(Play)
    |> iterator.to_list()

  #(calls, boards)
}

fn nested_index_fold(
  outer_list: List(List(a)),
  acc: b,
  f: fn(b, a, Int, Int) -> b,
) -> b {
  list.index_fold(
    over: outer_list,
    from: acc,
    with: fn(acc, inner_list, outer_idx) {
      list.index_fold(
        over: inner_list,
        from: acc,
        with: fn(acc, elem, inner_idx) { f(acc, elem, outer_idx, inner_idx) },
      )
    },
  )
}

fn build_board(data: List(List(Int))) -> Board {
  nested_index_fold(
    data,
    Board(spaces: map.new(), hits: set.new()),
    fn(board, elem, row_idx, col_idx) {
      Board(
        ..board,
        spaces: map.insert(
          board.spaces,
          elem,
          Pos(row: row_idx, column: col_idx),
        ),
      )
    },
  )
}

fn hit(game: Play, value: Int) -> Play {
  case game {
    Play(board) ->
      board.spaces
      |> map.get(value)
      |> result.map(fn(pos) {
        let hits = set.insert(board.hits, pos)
        let spaces = map.delete(board.spaces, value)
        case check_bingo(hits, pos) {
          True -> Bingo(map.keys(spaces))
          False -> Play(Board(spaces, hits))
        }
      })
      |> result.unwrap(game)

    _ -> game
  }
}

// const diagonal_positions = [
//   [Pos(0, 0), Pos(1, 1), Pos(2, 2), Pos(3, 3), Pos(4, 4)],
//   [Pos(0, 4), Pos(1, 3), Pos(2, 2), Pos(3, 1), Pos(4, 0)],
// ]
fn check_bingo(with hits: Set(Pos), for pos: Pos) -> Bool {
  let indices = iterator.range(0, 5)
  let bingo_row = fn() {
    indices
    |> iterator.map(Pos(row: pos.row, column: _))
    |> iterator.all(set.contains(hits, _))
  }
  let bingo_column = fn() {
    indices
    |> iterator.map(Pos(row: _, column: pos.column))
    |> iterator.all(set.contains(hits, _))
  }

  bingo_row() || bingo_column()
}

fn pt_1(calls: List(Int), boards: List(Play)) -> Int {
  let [call, ..calls] = calls
  let boards = list.map(boards, hit(_, call))
  case list.find(
    boards,
    fn(board) {
      case board {
        Play(_) -> False
        Bingo(_) -> True
      }
    },
  ) {
    Ok(Bingo(remaining)) -> call * int.sum(remaining)
    _ -> pt_1(calls, boards)
  }
}

fn pt_2(_input: String) -> Int {
  0
}
