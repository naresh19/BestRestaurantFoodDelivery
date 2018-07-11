class Store

  @@restaurant_delivery_charges = {}

  @@index = -1

  @@item_index_map = {}

  @@orders = {}

  def self.keep_restaurant_info(restaurant_id, charge)
    @@restaurant_delivery_charges[restaurant_id.to_i] = charge
  end

  def self.process(restaurant_id, price, item_name)
    items = item_name.split(',')
    bit_positions = []
    items.each do |item|
      item = item.lstrip.strip
      if @@item_index_map.key?(item)
        bit_positions << @@item_index_map[item]
      else
        @@index += 1
        @@item_index_map[item] = @@index
        bit_positions << @@index
      end
    end
    decimal_number = 0
    bit_positions.each do |bit_p|
      decimal_number = decimal_number | (1 << bit_p)
    end

    if @@orders.key?(decimal_number)
      @@orders[decimal_number] << [price.to_i + @@restaurant_delivery_charges[restaurant_id.to_i], restaurant_id]
    else
      @@orders[decimal_number] = [[price.to_i + @@restaurant_delivery_charges[restaurant_id.to_i], restaurant_id]]
    end
  end

  def self.find_best_price(items)
    bit_positions = []
    solutions = []
    items.each do |item|
      bit_positions << @@item_index_map[item]
    end
    decimal = 0
    bit_positions.each do |bit_p|
      decimal = decimal | (1 << bit_p)
    end
    @@orders.each do |k, v|
      if k & decimal == decimal
        solutions << v
      end
    end
    solutions.sort {|a, b| a[0] <=> b[0]}
    solutions[0]
  end
end