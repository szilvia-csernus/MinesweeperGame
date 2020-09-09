require_relative 'board'

class Tile

    attr_accessor :bomb, :flagged, :revealed, :seen_value, :adj_bomb_number

    def initialize(board, pos)
        @board, @pos = board, pos
        @bomb, @flagged, @revealed = false, false, false
        @adj_bomb_number = 0
        @seen_value = "*"
    end

    def neighbour_bomb_count
        @board.neighbours(@pos).count { |idx| @board.[](idx).bomb == true}
    end

    def reveal_tile
        if @revealed == true
            return
        else
            @revealed = true

            if @adj_bomb_number == 0
                @seen_value = " "
                @board.neighbours(@pos).each do |index| 
                    @board.[](index).reveal_tile unless @board.[](index).flagged == true
                end
            else
                @seen_value = @adj_bomb_number.to_s.green
            end
        end
    end

    def inspect
        { pos => @pos, 
        bomb => @bomb, 
        revealed => @revealed, 
        flagged => @flagged, 
        adj_bomb_number => @adj_bomb_number, 
        seen_value => @seen_value }.inspect
    end


end