require 'colorize'
require_relative 'tile'
require_relative 'board'
require_relative 'user_interface'


class MinesweeperGame

    attr_reader :board, :user

    def initialize(board_size = 9)
        @board = Board.new(board_size)
        @user = User.new
        
    end

    def run
        @board.render
        take_turn until (game_over || solved?)
        @board.reveal_bombs
        @board.render
        if game_over
            puts "You stepped on a bomb. Sorry, the game is over."
        elsif solved?
            puts "Congratulations! You win."
        end
        puts "---------------------"
    end

    def take_turn
        input
        evaluate_input
        @board.render

    end

    def evaluate_input
        i, j = @user.coordinate
        unless game_over
            case @user.action
            when 'r'
                @board.reveal_tile(@user.coordinate)
            when 'f'
                @board.grid[i][j].flagged = true
                @board.grid[i][j].seen_value = "F".yellow
            end
        end
    end

    def solved?
        @board.grid.all? do |row|
            row.all? do |tile|
                tile.bomb || tile.revealed
            end
        end
    end

    def game_over
        if @user.action == 'r' && @board.[](@user.coordinate).bomb == true
            return true
        end
        false
    end

    def input
        @user.coordinate = []
        @user.action = ''

        until coordinate_valid?
            puts "Please enter a coordinate: two numbers, separated by a comma. (e.g. 3,4)"
            @user.coordinate = gets.chomp.split(",").map { |num| Integer(num)}
        end
        
        until action_valid?
            puts "Enter 'r' for reveal a space or 'f' for flag a bomb. Don't step on a bomb!"
            @user.action = gets.chomp
        end

    end

    def coordinate_valid?
        @user.coordinate.is_a?(Array) && 
            @user.coordinate.length == 2 &&
            @board.valid_index?(@user.coordinate)
    end

    def action_valid?
        @user.action == "r" || @user.action == "f"
    end

end