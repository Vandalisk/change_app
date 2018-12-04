require 'interactor'
require 'active_support/core_ext/module'

# Interactor for getting change
#
class GetChange
  include Interactor

  COINS_TYPE_LIST = [50, 25, 10, 5, 2, 1].freeze

  delegate :input, :coins_table, :result, :balance, :transactions, to: :context

  before do
    context.input *= 100
    context.balance = input

    context.result = []
    context.transactions = []
  end

  def call
    COINS_TYPE_LIST.each do |cash_value|
      params = initialize_params(cash_value)

      if params[:total_amount] >= params[:unit]
        remember_first_type_transaction(params)
      elsif params[:total_amount] < params[:unit]
        remember_second_type_transaction(params)
      end

      break if balance.zero?
    end
  end

  def initialize_params(cash_value)
    coins_by_value = coins_table.where(value: cash_value)
    total_amount = coins_by_value.limit(1).first[:count]

    unit = balance / cash_value

    {
      coins_by_value: coins_by_value,
      cash_value: cash_value,
      total_amount: total_amount,
      unit: unit
    }
  end

  def remember_first_type_transaction(params)
    transactions << {
      table: params[:coins_by_value],
      count: params[:total_amount] - params[:unit]
    }

    context.balance -= params[:unit] * params[:cash_value]

    push_to_results(params[:unit], params[:cash_value])
  end

  def remember_second_type_transaction(params)
    transactions << { table: params[:coins_by_value], count: 0 }

    context.balance -= params[:total_amount] * params[:cash_value]

    push_to_results(params[:total_amount], params[:cash_value])
  end

  def push_to_results(count, value)
    result.push(*Array.new(count) { value })
  end
end
