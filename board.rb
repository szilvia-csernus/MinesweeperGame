require 'byebug'
require_relative 'tile'

class Board

    attr_accessor :grid

    def initialize(size)
        @grid = Array.new(size) do
            Array.new(size) { Tile.new }
        end
        @size = size
        random_fill
        fill_bomb_numbers
    end

    def random_fill
        places = (0...@size).to_a.product((0...@size).to_a)
        bomb_places = places.sample(@size)

        @grid.each.with_index do |row, i|
            row.each.with_index do |tile, j|
                tile.bomb = true if bomb_places.include?([i,j])
            end
        end
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end

    def render
        puts "  #{(0...@size).to_a.join(" ")}"
        @grid.each.with_index do |row, i|
            print "#{i}"
            row.each do |tile|
                print " #{tile.seen_value}"
            end
            puts
        end
    end

    def valid_index?(idx)
        i, j = idx
        i.between?(0, @size-1) && j.between?(0, @size-1)
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

    def neighbour_bomb_count(idx)
        i, j = idx
        count = neighbours(idx).count do |index| 
            x,y = index
            @grid[x][y].bomb == true
        end
        @grid[i][j].neighbour_bomb_number = count
        count
    end

    def fill_bomb_numbers
        @grid.each.with_index do |row, i|
            row.each.with_index do |tile, j|
                tile.neighbour_bomb_number = neighbour_bomb_count([i,j])
            end
        end
    end

    def reveal_tile(idx)
        i, j = idx
        if @grid[i][j].revealed == true
            return
        else
            @grid[i][j].revealed = true

            if @grid[i][j].neighbour_bomb_number == 0
                @grid[i][j].seen_value = "_"
                neighbours(idx).each do |index| 
                    reveal_tile(index) unless @board.[](index).flagged == true
                end
            else
                @grid[i][j].seen_value = @grid[i][j].neighbour_bomb_number.to_s
            end
        end
    end


end