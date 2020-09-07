require_relative 'tile'
require_relative 'board'
require_relative 'user_interface'


class MinesweeperGame

    def initialize(board_size = 9)
        @board = Board.new(board_size)
        @user = User.new
    end

    def run
        @board.render
        take_turn until solved?
        puts "Congratulations! You win."
    end

    def take_turn
        @user.input
        evaluate_input
        @board.render

    end

    def evaluate_input
        i, j = @user.coordinate
        game_over if (@user.action == 'r' && @board.grid[i][j].bomb == true)

        case @user.action
        when 'r'
            @board.reveal_tile(@user.coordinate)
        when 'f'
            @board.grid[i][j].flagged = true
            @board.grid[i][j].seen_value = "F"
        end
    end

    def solved?
        @board.grid.all? do |row|
            row.each do |tile|
                tile.bomb || tile.revealed
            end
        end
    end

    def game_over
        puts "You stepped on a bomb. Sorry, the game is over."
    end

end