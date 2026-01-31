=begin
Implement a method #stock_picker that takes in an array of stock prices, one for each hypothetical day. 
It should return a pair of days representing the best day to buy and the best day to sell. Days start at 0.
=end

def stock_picker(prices)
  return [] if prices.length < 2

  min_price = prices[0]
  min_day = 0
  max_profit = 0
  best_days = []

  prices.each_with_index do |price, day|
    if price - min_price > max_profit
      max_profit = price - min_price
      best_days = [min_day, day]
    end

    if price < min_price
      min_price = price
      min_day = day
    end
  end

  best_days
end

# test examples
puts stock_picker([17,3,6,9,15,8,6,10]) # => [1,4]
puts stock_picker([10,9,8,7,6,5])    # => []
puts stock_picker([5,10,4,8,6,12])  # => [2,5]