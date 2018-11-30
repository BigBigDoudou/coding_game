## Power of Thor - Episode 1

> [Link to challenge](https://www.codingame.com/ide/puzzle/power-of-thor-episode-1)

---

**Rules**

Your program must allow Thor to reach the light of power. Thor moves on a map which is 40 wide by 18 high. Note that the coordinates (X and Y) start at the top left! This means the most top left cell has the coordinates "X=0,Y=0" and the most bottom right one has the coordinates "X=39,Y=17".

Once the program starts you are given: the variable lightX: the X position of the light of power that Thor must reach ; the variable lightY: the Y position of the light of power that Thor must reach ; the variable initialTX: the starting X position of Thor ; the variable initialTY: the starting Y position of Thor.

At the end of the game turn, you must output the direction in which you want Thor to go among.

---

**Code**

```ruby
@light_x, @light_y, @initial_tx, @initial_ty = gets.split(' ').collect { |x| x.to_i }

y = @initial_ty
x = @initial_tx

loop do
  vertical = @light_y - y
  horizontal = @light_x - x
  move = horizontal.positive? ? 'E' : 'W' if horizontal.abs > vertical.abs
  move = vertical.positive? ? 'S' : 'N' if horizontal.abs < vertical.abs

  if vertical.abs == horizontal.abs
    move = (vertical.positive? ? 'S' : 'N') << (horizontal.positive? ? 'E' : 'W')
  end

  x += 1 if move.include? 'E'
  x -= 1 if move.include? 'W'
  y -= 1 if move.include? 'N'
  y += 1 if move.include? 'S'

  puts move
end
```