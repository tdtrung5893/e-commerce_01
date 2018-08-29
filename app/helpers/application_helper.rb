module ApplicationHelper
  def config_price price
    number_to_currency(price, unit: "đ", delimiter: ".", precision: 0,
      format: "%n %u")
  end
end
