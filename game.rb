require 'yaml'
require 'colorize'
require_relative 'tile'
require_relative 'board'
require_relative 'user_interface'


class MinesweeperGame

    attr_reader :board, :user

    LEVELS = {
        beginner: { size: 9, bomb_nr: 10},
        intermediate: { size: 12, bomb_nr: 20},
        expert: { size: 15, bomb_nr: 30}
    }

    def initialize(difficulty_level)
        level = LEVELS[difficulty_level]
        @board = Board.new(level[:size], level[:bomb_nr])
        @user = User.new
        
    end

    def run
        @board.render
        take_turn until (lost? || solved?)
        @board.reveal_bombs
        @board.render
        if lost?
            puts "You stepped on a bomb. Sorry, the game is over."
        elsif solved?
            puts "Congratulations! You won."
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
        unless lost?
            case @user.action
            when 'r'
                @board.grid[i][j].reveal_tile
            when 'f'
                @board.grid[i][j].flagged = true
                @board.grid[i][j].seen_value = "F".yellow
            when 's'
                save
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

    def lost?
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
            puts "You also can save the game by entering 's'."
            @user.action = gets.chomp
        end

    end

    def coordinate_valid?
        @user.coordinate.is_a?(Array) && 
            @user.coordinate.length == 2 &&
            @board.valid_index?(@user.coordinate)
    end

    def action_valid?
        valid = ["f", "r", "s"]
        valid.include?(@user.action)
    end

    def save
        puts "File name:"
        filename = gets.chomp
        File.write(filename, YAML.dump(self))
        puts "Enter 'ctrl c' if you don't want to continue the game!"
        sleep(10)
    end

end

if $PROGRAM_NAME == __FILE__
    if ARGV.empty?
        MinesweeperGame.new(:intermediate).run
    else
        YAML.load_file(ARGV.shift).run
    end

end