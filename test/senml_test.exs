defmodule SenMLTest do
  use ExUnit.Case
  doctest SenML

  test "greets the world" do
    json_string = ~s([
      {"bn":"urn:dev:ow:10e2073a0108006:","bt":1.276020076001e+09, "bu":"A","bver":5, "n":"voltage","u":"V","v":120.1},
      {"n":"current","t":-5,"v":1.2},
      {"n":"current","t":-4,"v":1.3},
      {"n":"current","t":-3,"v":1.4},
      {"n":"current","t":-2,"v":1.5},
      {"n":"current","t":-1,"v":1.6},
      {"n":"current","v":1.7}
    ]) |> Jason.decode!() |> Jason.encode!()

    encoded =
      json_string
      |> SenML.decode()
      |> SenML.encode()

    assert encoded == json_string
  end
end
