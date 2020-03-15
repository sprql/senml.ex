json_string = ~s([
  {"bn":"urn:dev:ow:10e2073a0108006:","bt":1.276020076001e+09, "bu":"A","bver":5, "n":"voltage","u":"V","v":120.1},
  {"n":"current","t":-5,"v":1.2},
  {"n":"current","t":-4,"v":1.3},
  {"n":"current","t":-3,"v":1.4},
  {"n":"current","t":-2,"v":1.5},
  {"n":"current","t":-1,"v":1.6},
  {"n":"current","v":1.7}
]) |> Jason.decode!() |> Jason.encode!()

list = SenML.decode(json_string)
normalized_list = SenML.normalize(list)

Benchee.run(%{
  decode: fn -> SenML.decode(json_string) end,
  encode: fn -> SenML.encode(list) end,
  normalize: fn -> SenML.normalize(list) end,
  encode_normalized: fn -> SenML.encode(normalized_list) end,
  normalize_normalized: fn -> SenML.normalize(normalized_list) end
})
