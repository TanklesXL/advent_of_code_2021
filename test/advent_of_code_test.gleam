import gleeunit
import days/day_1
import days/day_2
import days/day_3
import days/day_4

pub fn main() {
  gleeunit.main()
}

pub external fn read_file(String) -> Result(String, a) =
  "file" "read_file"

pub fn day_1_test() {
  assert Ok(data) = read_file("input/day_1.txt")
  assert #(1624, 1653) = day_1.run(data)
}

pub fn day_2_test() {
  assert Ok(data) = read_file("input/day_2.txt")
  assert #(2117664, 2073416724) = day_2.run(data)
}

pub fn day_3_test() {
  assert Ok(data) = read_file("input/day_3.txt")
  assert #(2498354, 3277956) = day_3.run(data)
}

pub fn day_4_test() {
  assert Ok(data) = read_file("input/day_4.txt")
  assert #(10374, 0) = day_4.run(data)
}
