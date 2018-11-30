
## Shadows of the knight - Episode 1

> [Link to challenge](https://www.codingame.com/ide/puzzle/shadows-of-the-knight-episode-1)

---

**Rules**

Batman will look for the hostages on a given building by jumping from one window to another using his grapnel gun. Batman's goal is to jump to the window where the hostages are located in order to disarm the bombs. Unfortunately he has a limited number of jumps before the bombs go off...

Before each jump, the heat-signature device will provide Batman with the direction of the bombs based on Batman current position: U (Up), UR (Up-Right), R (Right), DR (Down-Right), D (Down), DL (Down-Left), L (Left), UL (Up-Left).

Your mission is to program the device so that it indicates the location of the next window Batman should jump to in order to reach the bombs' room as soon as possible. Buildings are represented as a rectangular array of windows, the window in the top left corner of the building is at index (0,0).

Input // The program must first read the initialization data from standard input. Then, within an infinite loop, read the device data from the standard input and provide to the standard output the next movement instruction.

Output // A single line with 2 integers X Y separated by a space character. (X, Y) represents the location of the next window Batman should jump to. X represents the index along the horizontal axis, Y represents the index along the vertical axis. (0,0) is located in the top-left corner of the building.

---

**Code**

```ruby
@w, @h = gets.split(" ").collect {|x| x.to_i} # w: width of the building, h: height of the building
@n = gets.to_i # maximum number of turns before game over.
@x0, @y0 = gets.split(" ").collect {|x| x.to_i} # starting position of Batman

y = @y0
x = @x0
area = [0, @w, 0, @h]

loop do
    bomb_dir = gets.chomp # direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    
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
