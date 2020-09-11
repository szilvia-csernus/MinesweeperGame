require 'yaml'
require 'remedy'
require 'colorize'
require_relative 'tile'
require_relative 'board'
require_relative 'user'


class MinesweeperGame
    include Remedy

    attr_reader :board, :user

    LEVELS = {
        beginner: { size: 9, bomb_nr: 10},
        intermediate: { size: 12, bomb_nr: 20},
        expert: { size: 15, bomb_nr: 30}
    }

    def initialize(difficulty_level)
        level = LEVELS[difficulty_level]
        @size = level[:size]
        @board = Board.new(@size, level[:bomb_nr])
        @user = User.new
        
        
    end

    def evaluate_input(action, pos)
        case action
        when 'r'
            @board[pos].reveal_tile
        when 'f'
            @board[pos].flagged = true
            @board[pos].seen_value = "F".yellow
        when 's'
            save
        end
    end

    def solved?
        @board.grid.all? do |row|
            row.all? do |tile|
                tile.bomb || tile.revealed
            end
        end
    end

    def bombed?(pos)
        @board[pos].bomb
    end

    def run
        @start_time = Time.now
        user_input = Interaction.new
        x = y = 0
        pos = [x, y]
        @board.cursor = pos
        system("clear")
        puts @board.render
        puts "Please move using your keyboard arrow keys. When you are on the space you want selected, press an action key"
        puts "Action keys - r: reveal, f: flag, s: save"
        user_input.loop do |key|
            system("clear")

            case key.to_s
            when "right"
                y += 1 unless y >= (@size - 1)
            when "left"
                y -= 1 unless y <= 0
            when "up"
                x -= 1 unless x <= 0
            when "down"
                x += 1 unless x >= (@size - 1)
            when "r"
                if bombed?(pos)
                    game_over
                    return
                end
                evaluate_input("r", pos)
            when "f"
                evaluate_input("f", pos)
            when "s"
                evaluate_input("s", pos)
            end

            if solved?
                @end_time = Time.now
                @board.reveal_bombs
                @board.render
                if solved?
                    puts "Congratulations, you won! It took #{@end_time - @start_time} seconds."
                end
                puts "---------------------"
                return
            end

            pos = [x, y]
            @board.cursor = [x, y]
            puts @board.render
            puts "Action keys - r: reveal, f: flag, s: save"
        end
    end

    def game_over
        @board.reveal_bombs
        @board.render
        puts "You stepped on a bomb. Sorry, the game is over."
    end

    def save
        puts "File name:"
        filename = gets.chomp
        File.write(filename, YAML.dump(self))
        puts "Enter 'ctrl c' if you don't want to continue the game, otherwise, wait ;)"
        sleep(4)
    end

end

if $PROGRAM_NAME == __FILE__
    if ARGV.empty?
        answers = ["b", "i", "e"]
        inp = ""
        until answers.include?(inp)
            system("clear")
            puts "What level would you like to play?"
            puts "Beginner: 'b', Intermediate: 'i', Expert: 'e'"
            inp = gets.chomp
            case inp
            when 'b'
                level = :beginner
            when 'i'
                level = :intermediate
            when 'e'
                level = :expert
            end
        end
        MinesweeperGame.new(level).run
    else
        YAML.load_file(ARGV.shift).run
    end

end