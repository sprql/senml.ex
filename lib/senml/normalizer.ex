defmodule SenML.Normalizer do
  @default_version 10

  @spec normalize(list(%SenML{})) :: list(%SenML{})
  def normalize(list) do
    # https://tools.ietf.org/html/rfc8428#section-4.6
    # The Records need to be in chronological order in the Pack

    list
    |> _normalize([], "", 0, nil, 0, 0, nil)
    |> Enum.sort(&(&1.time <= &2.time))
  end

  defp _normalize([], normalized_list, _, _, _, _, _, _), do: normalized_list

  defp _normalize(
         [record | list],
         normalized_list,
         base_name,
         base_time,
         base_unit,
         base_value,
         base_sum,
         base_version
       ) do
    base_name = if record.base_name != nil, do: record.base_name, else: base_name
    base_time = if record.base_time != nil, do: record.base_time, else: base_time
    base_unit = if record.base_unit != nil, do: record.base_unit, else: base_unit
    base_value = if record.base_value != nil, do: record.base_value, else: base_value
    base_sum = if record.base_sum != nil, do: record.base_sum, else: base_sum
    # https://tools.ietf.org/html/rfc8428#section-4.1
    # Version number of the media type format. This field is an optional positive integer and defaults to 10 if not present.
    # if the version is default, it must not be present in resolved records.
    base_version =
      if record.base_version != nil && record.base_version != @default_version,
        do: record.base_version,
        else: base_version

    # https://tools.ietf.org/html/rfc8428#section-4.6
    # A SenML Record is referred to as "resolved" if it does not contain any base values,
    # except for Base Version fields, and has no relative times
    normalized_record = %SenML{
      base_version: base_version,
      name: "#{base_name}#{record.name}",
      unit: record_unit(record, base_unit),
      value: record_value(record, base_value),
      string_value: record.string_value,
      boolean_value: record.boolean_value,
      data_value: record.data_value,
      sum: record_sum(record, base_sum),
      time: record_time(record, base_time),
      update_time: record.update_time
    }

    _normalize(
      list,
      [normalized_record | normalized_list],
      base_name,
      base_time,
      base_unit,
      base_value,
      base_sum,
      base_version
    )
  end

  defp record_unit(record, base_unit) do
    if record.unit == nil && base_unit != nil, do: base_unit, else: record.unit
  end

  defp record_value(record, base_value) do
    if record.value != nil && base_value != nil, do: base_value + record.value, else: record.value
  end

  defp record_sum(record, base_sum) do
    if record.sum != nil, do: base_sum + record.sum, else: record.sum
  end

  defp record_time(record, base_time) do
    cond do
      base_time != nil && record.time != nil -> base_time + record.time
      base_time != nil && record.time == nil -> base_time
      true -> record.time
    end
  end
end
