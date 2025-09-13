module ApplicationHelper
  def format_currency(value)
    number_to_currency(
      value,
      unit: "$ ",
      separator: ",",
      delimiter: ".",
      precision: 2
    )
  end

  def uf_value_format(uf_value)
    return "---" unless uf_value
    number_to_currency(uf_value.value)
  end
  def uf_to_dolar_value_format(uf_value, dolar_value)
    return "" unless uf_value && dolar_value
    "#{number_to_currency(uf_value.value / dolar_value.value)} <small>USD</small>"
  end
end
