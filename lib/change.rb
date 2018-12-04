require 'sequel'
require './lib/connection_util'
require './lib/interactors/get_change'
require './lib/interactors/put_coins'

# change giving class
#
class Change
  attr_reader :coins_table

  def initialize(env = 'development')
    @coins_table = Sequel.connect(ConnectionUtil.db_config[env])[:coins]
  end

  def put_coins(coins)
    PutCoins.call(coins_table: coins_table, coins: coins)
  end

  def get_change(input)
    interactor = GetChange.call(input: input, coins_table: coins_table)

    unless interactor.balance.zero?
      raise StandardError, 'Not enough coins to give odd'
    end

    make_transactions(interactor.transactions)

    interactor.result
  end

  def make_transactions(transactions)
    transactions.each do |transaction|
      transaction[:table].update(count: transaction[:count])
    end
  end
end
