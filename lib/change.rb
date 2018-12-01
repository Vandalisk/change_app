# change giving class
#
class Change
  attr_reader :con

  def initialize
    @con = Sequel.connect
  end
end
