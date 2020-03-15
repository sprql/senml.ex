defmodule SenMLTest.Normalizer do
  use ExUnit.Case

  @json_string ~s([
      {"bn":"urn:dev:ow:10e2073a0108006:","bt":1.276020076001e+09, "bu":"A","bver":5, "n":"voltage","u":"V","v":120.1},
      {"n":"current","t":-5,"v":1.2},
      {"n":"current","t":-4,"v":1.3},
      {"n":"current","t":-3,"v":1.4},
      {"n":"current","t":-2,"v":1.5},
      {"n":"current","t":-1,"v":1.6},
      {"n":"current","v":1.7}
    ])

  @expected_normalized_list [
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:current",
      time: 1_276_020_071.001,
      unit: "A",
      value: 1.2
    },
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:current",
      time: 1_276_020_072.001,
      unit: "A",
      value: 1.3
    },
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:current",
      time: 1_276_020_073.001,
      unit: "A",
      value: 1.4
    },
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:current",
      time: 1_276_020_074.001,
      unit: "A",
      value: 1.5
    },
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:current",
      time: 1_276_020_075.001,
      unit: "A",
      value: 1.6
    },
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:current",
      time: 1_276_020_076.001,
      unit: "A",
      value: 1.7
    },
    %SenML{
      base_version: 5,
      name: "urn:dev:ow:10e2073a0108006:voltage",
      time: 1_276_020_076.001,
      unit: "V",
      value: 120.1
    }
  ]

  test "normalization" do
    normalized_list =
      @json_string
      |> Jason.decode!()
      |> Jason.encode!()
      |> SenML.decode()
      |> SenML.normalize()

    assert @expected_normalized_list == normalized_list
  end
end
