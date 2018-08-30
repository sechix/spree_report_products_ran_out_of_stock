Spree::Variant.class_eval do
    # Returns variants that are in out in stock. When stock locations are provided as
    # a parameter, the scope is limited to variants that are out of stock in the
    # provided stock locations.
    
    def self.out_of_stock(stock_locations = nil)
      return all unless Spree::Config.track_inventory_levels
      out_of_stock_variants = joins(:stock_items).where(Spree::StockItem.arel_table[:count_on_hand].eq(0))
      if stock_locations.present?
        out_of_stock_variants = in_stock_variants.where(spree_stock_items: { stock_location_id: stock_locations.map(&:id) })
      end
      out_of_stock_variants
    end

end
