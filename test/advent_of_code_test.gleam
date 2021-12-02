import gleeunit
import ffi/file
import days/day_1
import days/day_2

pub fn main() {
  gleeunit.main()
}

pub fn day_1_test() {
  assert Ok(data) = file.read_file("input/day_1.txt")
  assert #(1624, 1653) = day_1.run(data)
}

pub fn day_2_test() {
  assert Ok(data) = file.read_file("input/day_2.txt")
  assert #(2117664, 2073416724) = day_2.run(data)
}
