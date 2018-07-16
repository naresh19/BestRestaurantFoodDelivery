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
      @@orders[decimal_number] << [price.to_i, restaurant_id]
    else
      @@orders[decimal_number] = [[price.to_i, restaurant_id]]
    end
  end

  def self.find_best_price(items)
    bit_positions = []
    items.each do |item|
      bit_positions << @@item_index_map[item]
    end
    decimal = 0
    bit_positions.each do |bit_p|
      decimal = decimal | (1 << bit_p)
    end
    restaurant_hash = {}
    @@orders.each do |k, v|
      if k & decimal >= 1
        v.each do |val|
          if restaurant_hash.key?(val[1].to_i)
            restaurant_hash[val[1].to_i] << [k, val[0]]
          else
            restaurant_hash[val[1].to_i] = [[k, val[0]]]
          end
        end
      end
    end
    solutions = []
    restaurant_hash.each do |k, v|
      for i in 0...(1 << v.size)
        result = 0
        sum_price = 0
        for j in 0..v.size
          if i & (1 << (j)) != 0
            result = result | v[j][0]
            sum_price += v[j][1]
          end
        end
        if result & decimal == decimal
          solutions << [k, sum_price].flatten
        end
      end
    end
    solutions = solutions.sort{|a, b| (a[1] + @@restaurant_delivery_charges[a[0]]) <=> (b[1] + @@restaurant_delivery_charges[b[0]])}
    solutions[0][1] = solutions[0][1] + @@restaurant_delivery_charges[solutions[0][0]]
    solutions[0]
  end
end