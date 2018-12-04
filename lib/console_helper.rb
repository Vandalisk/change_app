# class for console commands
#
class ConsoleHelper
  class << self
    def help_text
      <<-TEXT
        Available commands:
        help - to see list of available commands

        puts [array or file_path] - to add coins into machine
          example:
            puts [50,50,50,10,2,2,1]

        change [number] - to get change from cash machine
          example:
            change 2

        exit - to exit program
      TEXT
    end

    def prepare_coins_input(input)
      i = input.first

      i.scan(/\d+/).map(&:to_i)
    end
  end
end
