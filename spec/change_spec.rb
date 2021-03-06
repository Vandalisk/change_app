require 'change'
require 'sequel'
require './lib/connection_util'

RSpec.describe Change do
  let(:db_config) { ConnectionUtil.db_config }
  let!(:con) { Sequel.connect(db_config['test']) }

  subject { described_class.new('test') }

  let(:coins_table) { con[:coins] }
  let(:fixture) { { 50 => 2, 25 => 8, 10 => 14, 5 => 11, 2 => 3, 1 => 1 } }

  let(:coins) do
    fixture.each_with_object([]) do |(coin, count), object|
      object.push(value: coin, count: count)
    end
  end

  context 'should return right change' do
    before do
      coins_table.delete

      fixture.keys.each { |value| coins_table.insert(value: value, count: 0) }
    end

    after { coins_table.delete }

    it 'change recipe' do
      subject.put_coins(coins)

      expect(subject.get_change(2)).to eq([50, 50, 25, 25, 25, 25])
      expect(subject.get_change(2)).to eq(
        [25, 25, 25, 25, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
      )

      expect(subject.get_change(1)).to eq(
        [10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 2, 2, 1]
      )

      expect { subject.get_change(2) }.to raise_error(StandardError)
    end
  end
end
