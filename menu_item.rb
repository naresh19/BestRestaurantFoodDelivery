class MenuItem

  TYPE_ENUM= {normal: :normal, combo: :combo}

  attr_reader :item, :price

  def initialize(item:, price: 0)
    items = item.to_s.split(',').map(&:strip)
    @item = items.length > 1 ? items : items.first
    @price = price.to_f
  end

  def type
    @item.is_a?(Array) ? TYPE_ENUM[:combo] : TYPE_ENUM[:normal]
  end

end