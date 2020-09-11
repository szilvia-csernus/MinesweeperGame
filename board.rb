require 'colorize'
require_relative 'tile'

class Board

    attr_accessor :grid, :cursor

    def initialize(size, bomb_nr)
        @grid = Array.new(size) do |i|
            Array.new(size) { |j| Tile.new(self, [i,j] ) }
        end
        @size = size
        @cursor = [0,0]
        
        random_fill(bomb_nr)
        fill_bomb_numbers
    end

    def random_fill(bomb_nr)
        places = (0...@size).to_a.product((0...@size).to_a)
        bomb_places = places.sample(bomb_nr)
        bomb_places.each { |pos| self.[](pos).bomb = true}
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end

    def render
        @grid.each do |row|
            row.each do |tile|
                if tile.pos == @cursor
                    print " #{tile.seen_value.colorize(:background => :blue)}"
                else 
                    print " #{tile.seen_value}"
                end
            end
            puts
        end
        puts "---------------------"
    end

    def valid_index?(idx)
        idx.all? { |i| i.between?(0, @size-1)}
    end

    def neighbours(idx)
        neighbour_indices = Array.new(0) {[]}
        i, j = idx
        is = [i-1, i, i+1]
        js = [j-1, j, j+1]
        possible_indices = is.product(js)
        possible_indices.each do |index|
            neighbour_indices << index if (valid_index?(index) && (index != idx))
        end
        neighbour_indices
    end

    def fill_bomb_numbers
        @grid.each.with_index do |row, i|
            row.each.with_index do |tile, j|
                tile.adj_bomb_number = tile.neighbour_bomb_count
            end
        end
    end

    def reveal_bombs
        @grid.each do |row|
            row.each do |tile|
                tile.seen_value = "B".red if tile.bomb == true
            end
        end
    end

end