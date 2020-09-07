require_relative 'board'

class Tile

    attr_accessor :bomb, :flagged, :revealed, :seen_value, :neighbour_bomb_number

    def initialize

        @bomb = false
        @flagged = false
        @revealed = false
        @neighbour_bomb_number = 0
        @seen_value = "*"
    end

    


end