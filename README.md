# coding_game

Challenges on [codingame.com](https://www.codingame.com/ide/puzzle/shadows-of-the-knight-episode-1)

## Shadows of the knight - Episode 1

> [Link to challenge](https://www.codingame.com/ide/puzzle/shadows-of-the-knight-episode-1)

```ruby
@w, @h = gets.split(" ").collect {|x| x.to_i} # w: width of the building, h: height of the building
@n = gets.to_i # maximum number of turns before game over.
@x0, @y0 = gets.split(" ").collect {|x| x.to_i}

y = @y0
x = @x0
area = [0, @w, 0, @h]

loop do
    bomb_dir = gets.chomp # the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    
    # STEP 1: reduce the search area
    # STEP 2: jump in the middle of the new search area
    
    area[0] = [x, area[0]].max if bomb_dir.include?('R')
    area[1] = [x, area[1]].min if bomb_dir.include?('L')
    area[2] = [y, area[2]].max if bomb_dir.include?('D')
    area[3] = [y, area[3]].min if bomb_dir.include?('U')
    x = area[0..1].sum./2
    y = area[2..3].sum./2
    puts "#{x} #{y}"
end
```

## There is no Spoon - Episode 1

> [Link to challenge](https://www.codingame.com/ide/puzzle/there-is-no-spoon-episode-1)


```ruby
@width = gets.to_i # the number of cells on the X axis
@height = gets.to_i # the number of cells on the Y axis

@lines = []

@height.times do
    line = gets.chomp # width characters, each either 0 or .
    @lines << line
end

# Write an action using puts
# To debug: STDERR.puts "Debug messages..."

@nodes = []

@lines.each_with_index do |line, y|
    line.gsub(/\./, '1').chars.map(&:to_i).each_with_index do |value, x|
        @nodes << [x, y] if value.zero?
    end
end

def right_node(coordinates)
    @nodes
        .select { |node| node[1] == coordinates[1] }
        .sort_by { |node| node[0] }
        .find { |node| node[0] > coordinates[0] }
end

def bottom_node(coordinates)
    @nodes
        .select { |node| node[0] == coordinates[0] }
        .sort_by { |node| node[1] }
        .find { |node| node[1] > coordinates[1] }
end

@nodes.each do |node|
    right = right_node(node) || [-1, -1]
    bottom = bottom_node(node) || [-1, -1]
    puts "#{node[0]} #{node[1]} #{right[0]} #{right[1]} #{bottom[0]} #{bottom[1]}"
end
```
