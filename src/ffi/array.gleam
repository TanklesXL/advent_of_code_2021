pub external type Array(a)

pub external fn from_list(List(a)) -> Array(a) =
  "array" "from_list"

pub external fn to_list(Array(a)) -> List(a) =
  "array" "to_list"

pub external fn get(Int, Array(a)) -> a =
  "array" "get"
