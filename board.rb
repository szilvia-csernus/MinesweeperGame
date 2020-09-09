require 'colorize'
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
        bomb_places.each { |pos| self.[](pos).bomb = true}
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end

    def render
        puts "  #{(0...@size).to_a.join(" ")}".blue
        @grid.each.with_index do |row, i|
            print "#{i}".blue
            row.each do |tile|
                print " #{tile.seen_value}"
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

    def neighbour_bomb_count(idx)
        neighbours(idx).count { |index| self.[](index).bomb == true}
    end

    def fill_bomb_numbers
        @grid.each.with_index do |row, i|
            row.each.with_index do |tile, j|
                tile.adj_bomb_number = neighbour_bomb_count([i,j])
            end
        end
    end

    def reveal_tile(idx)
        i, j = idx
        if @grid[i][j].revealed == true
            return
        else
            @grid[i][j].revealed = true

            if @grid[i][j].adj_bomb_number == 0
                @grid[i][j].seen_value = " "
                neighbours(idx).each do |index| 
                    reveal_tile(index) unless self.[](index).flagged == true
                end
            else
                @grid[i][j].seen_value = @grid[i][j].adj_bomb_number.to_s.green
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