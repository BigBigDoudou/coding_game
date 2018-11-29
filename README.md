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
