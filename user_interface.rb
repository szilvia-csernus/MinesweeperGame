require_relative 'board'
require_relative 'tile'

class User

    def initialize
        @user 
        @coordinate = nil
        @action = nil
    end

    def input
        
        until coordinate_valid?
            puts "Please enter a coordinate: two numbers, separated by a comma. (e.g. 3,4)"
            @coordinate = gets.chomp.split(",").each { |num| num.to_i}
        end
        
        until action_valid?
            puts "Enter 'r' for reveal a space or 'f' for flag a bomb. Don't step on a bomb!"
            @action = gets.chomp
        end

    end

    def coordinate_valid?
        @coordinate.is_a?(Array) && 
            @coordinate.length == 2 &&
            @board.valid_index?(@coordinate)
    end

    def action_valid?
        @action == "r" || @action == "f"
    end

    
