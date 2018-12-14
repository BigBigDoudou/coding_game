## Power of Thor

> [Link to challenge](https://www.codingame.com/ide/puzzle/power-of-thor-episode-1)

---

**Rules**

Your program must allow Thor to reach the light of power. Thor moves on a map which is 40 wide by 18 high. Note that the coordinates (X and Y) start at the top left! This means the most top left cell has the coordinates "X=0,Y=0" and the most bottom right one has the coordinates "X=39,Y=17".

Once the program starts you are given: the variable lightX: the X position of the light of power that Thor must reach ; the variable lightY: the Y position of the light of power that Thor must reach ; the variable initialTX: the starting X position of Thor ; the variable initialTY: the starting Y position of Thor.

At the end of the game turn, you must output the direction in which you want Thor to go among.

---

**Code**

```ruby
# light_x: the X position of the light of power
# light_y: the Y position of the light of power
# initial_tx: Thor's starting X position
# initial_ty: Thor's starting Y position
@light_x, @light_y, @initial_tx, @initial_ty = gets.split(' ').map(&:to_i)

y = @initial_ty
x = @initial_tx

loop do
  remaining_turns = gets.to_i # remaining amount of turns Thor can move (unused => specs input)

  # define vertical and horizontal distances
  vertical = @light_y - y
  horizontal = @light_x - x

  # if thor is most far on the horizontal axe
  move = horizontal.positive? ? 'E' : 'W' if horizontal.abs > vertical.abs

  # if thor is most far on the vertical axe
  move = vertical.positive? ? 'S' : 'N' if horizontal.abs < vertical.abs

  # if distances on two axes are equal
  if vertical.abs == horizontal.abs
    move = (vertical.positive? ? 'S' : 'N') << (horizontal.positive? ? 'E' : 'W')
  end

  # define thor next position
  x += 1 if move.include? 'E'
  x -= 1 if move.include? 'W'
  y -= 1 if move.include? 'N'
  y += 1 if move.include? 'S'

  puts move
end
```
