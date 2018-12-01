# change giving class
#
class Change
  attr_reader :coins_table

  def initialize(env = 'development')
    @coins_table = Sequel.connect(ConnectionUtil.db_config[env])[:coins]
  end

  def put_coins(coins)
    coins.each { |coin| coins_table.insert(coin) }
  end

  def get_odd(sum)
    sum *= 100
    balance = sum

    result = []

    [50, 25, 10, 5, 2, 1].each do |cash_value|
      coins_by_value = coins_table.where(value: cash_value)
      total_amount = coins_by_value.limit(1).first[:count]

      unit = balance / cash_value

      if total_amount >= unit
        coins_by_value.update(count: total_amount - unit)

        balance -= unit * cash_value

        result.push(*Array.new(unit) { cash_value })
      elsif total_amount < unit
        coins_by_value.update(count: 0)

        balance -= total_amount * cash_value

        result.push(*Array.new(total_amount) { cash_value })
      end

      break if balance.zero?
    end

    raise StandardError, 'Not enough coins to give odd' unless balance.zero?

    result
  end
end
