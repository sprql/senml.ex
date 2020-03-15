defmodule SenML do
  @moduledoc """
  Lightweight implementation of RFC 8428 Sensor Measurement Lists (SenML)

  SenML Labels
  +---------------+-------+------------+------------+------------+
  |          Name | Label | CBOR Label | JSON Type  | XML Type   |
  +---------------+-------+------------+------------+------------+
  |     Base Name | bn    |         -2 | String     | string     |
  |     Base Time | bt    |         -3 | Number     | double     |
  |     Base Unit | bu    |         -4 | String     | string     |
  |    Base Value | bv    |         -5 | Number     | double     |
  |      Base Sum | bs    |         -6 | Number     | double     |
  |  Base Version | bver  |         -1 | Number     | int        |
  |          Name | n     |          0 | String     | string     |
  |          Unit | u     |          1 | String     | string     |
  |         Value | v     |          2 | Number     | double     |
  |  String Value | vs    |          3 | String     | string     |
  | Boolean Value | vb    |          4 | Boolean    | boolean    |
  |    Data Value | vd    |          8 | String (*) | string (*) |
  |           Sum | s     |          5 | Number     | double     |
  |          Time | t     |          6 | Number     | double     |
  |   Update Time | ut    |          7 | Number     | double     |
  +---------------+-------+------------+------------+------------+
  """

  defstruct [
    :base_name,
    :base_time,
    :base_unit,
    :base_value,
    :base_sum,
    :base_version,
    :name,
    :unit,
    :value,
    :string_value,
    :boolean_value,
    :data_value,
    :sum,
    :time,
    :update_time
  ]

  @spec decode(binary()) :: list(%SenML{})
  def decode(data) do
    data
    |> Jason.decode!()
    |> Enum.map(
      &%SenML{
        base_name: &1["bn"],
        base_time: &1["bt"],
        base_unit: &1["bu"],
        base_value: &1["bv"],
        base_sum: &1["bs"],
        base_version: &1["bver"],
        name: &1["n"],
        unit: &1["u"],
        value: &1["v"],
        string_value: &1["vs"],
        boolean_value: &1["vb"],
        data_value: &1["vd"],
        sum: &1["s"],
        time: &1["t"],
        update_time: &1["ut"]
      }
    )
  end

  @spec encode(list(%SenML{})) :: binary()
  def encode(list) do
    list
    |> Enum.map(&encode_senml(&1))
    |> Jason.encode!()
  end

  @spec normalize(list(%SenML{})) :: list(%SenML{})
  def normalize(list) do
    SenML.Normalizer.normalize(list)
  end

  defp encode_senml(%SenML{} = senml) do
    %{}
    |> map_maybe_put("bn", senml.base_name)
    |> map_maybe_put("bt", senml.base_time)
    |> map_maybe_put("bu", senml.base_unit)
    |> map_maybe_put("bv", senml.base_value)
    |> map_maybe_put("bs", senml.base_sum)
    |> map_maybe_put("bver", senml.base_version)
    |> map_maybe_put("n", senml.name)
    |> map_maybe_put("u", senml.unit)
    |> map_maybe_put("v", senml.value)
    |> map_maybe_put("vs", senml.string_value)
    |> map_maybe_put("vb", senml.boolean_value)
    |> map_maybe_put("vd", senml.data_value)
    |> map_maybe_put("s", senml.sum)
    |> map_maybe_put("t", senml.time)
    |> map_maybe_put("ut", senml.update_time)
  end

  defp map_maybe_put(map, _key, nil), do: map
  defp map_maybe_put(map, key, value), do: Map.put(map, key, value)
end
