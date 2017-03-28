require_relative 'menu_item'

class Menu

  attr_reader :items

  def initialize
    @items = MenuItem::TYPE_ENUM.values.inject({}) {|items,type| items.merge(type => {})}
  end

  # adds menu_item to menu
  def add_item(menu_item)
    # todo: add exception unless menu_item.is_a?(MenuItem)
    @items[menu_item.type][menu_item.item] = menu_item
  end

  # returns if menu contains sent items
  def has_items?(item_list)
    (item_list - items.values.flatten.map(&:keys).flatten).empty?
  end

  # returns the best price for a given item list
  def best_price_for_items(item_list)
    left_items = item_list
    price = 0.0
    items[:combo].each do |item, menu_item|
      break if left_items.empty?
      intersection = left_items & item
      if !intersection.empty?
        left_items -= item
        combo_price = menu_item.price
        normal_price = Float::INFINITY
        menu_items = items[:normal].values_at(*intersection).compact
        if menu_items.length == intersection.length
          normal_price = menu_items.inject(0) { |sum, mi| sum+mi.price }
        end
        price += [combo_price, normal_price].min
      end
    end
    items[:normal].each do |item, menu_item|
      break if left_items.empty?
      if !(left_items & [item]).empty?
        left_items -= [item]
        price += menu_item.price
      end
    end
    return unless left_items.empty?
    price
  end

end