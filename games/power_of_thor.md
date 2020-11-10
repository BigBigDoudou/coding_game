# Power of Thor

Your program must allow Thor to reach the light of power. Thor moves on a map which is 40 wide by 18 high. Note that the coordinates (X and Y) start at the top left! This means the most top left cell has the coordinates "X=0,Y=0" and the most bottom right one has the coordinates "X=39,Y=17".

Once the program starts you are given: the variable lightX: the X position of the light of power that Thor must reach ; the variable lightY: the Y position of the light of power that Thor must reach ; the variable initialTX: the starting X position of Thor ; the variable initialTY: the starting Y position of Thor.

At the end of the game turn, you must output the direction in which you want Thor to go among.

[Link to challenge](https://www.codingame.com/ide/puzzle/power-of-thor-episode-1)

---

## ruby

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

  move =
    if horizontal.abs > vertical.abs
      # move east or west
      horizontal.positive? ? 'E' : 'W'
    elsif horizontal.abs < vertical.abs
      # move south or north
      vertical.positive? ? 'S' : 'N'
    else
      # move diagonally
      (vertical.positive? ? 'S' : 'N') << (horizontal.positive? ? 'E' : 'W')
    end

  # define thor next position
  # define thor next position
  if move.include? 'E'
    x += 1
  elsif move.include? 'W' # do not test if include 'E'
    x -= 1
  end

  if move.include? 'N'
    y -= 1
  elsif move.include? 'S' # do not test if include 'N'
    y += 1
  end

  puts move
end
```
