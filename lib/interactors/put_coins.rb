require 'interactor'
require 'active_support/core_ext/module'

# Interactor for adding coins
#
class PutCoins
  include Interactor

  delegate :coins_table, :coins, to: :context

  def call
    coins.each { |coin| update_coin_count(coin) }

    context.result = coins.map do |coin|
      create_array(coin[:count], coin[:value])
    end.flatten
  end

  def update_coin_count(coin)
    current_coins = coins_table.where(value: coin[:value])

    coins_count = current_coins.limit(1).first[:count]

    current_coins.update(count: coins_count + coin[:count])
  end

  def create_array(count, value)
    Array.new(count) { value }
  end
end
