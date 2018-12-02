
## The Last Cruisade

> [Link to challenge](https://www.codingame.com/ide/puzzle/the-last-crusade-episode-1)

---

**Rules**

The tunnel consists of a patchwork of square rooms of different types.The rooms can be accessed and activated by computer using an ancient RS232 serial port (because Mayans aren't very technologically advanced, as is to be expected...).

There is a total of 14 room types (6 base shapes extended to 14 through rotations).

Upon entering a room, depending on the type of the room and Indy's entrance point (TOP,LEFT, or RIGHT) he will either exit the room through a specific exit point, suffer a lethal collision or lose momentum and get stuck.

Indy is perpetually drawn downwards: he cannot leave a room through the top.

At the start of the game, you are given the map of the tunnel in the form of a rectangular grid of rooms. Each room is represented by its type.

For this first mission, you will familiarize yourself with the tunnel system, the rooms have all been arranged in such a way that Indy will have a safe continuous route between his starting point (top of the temple) and the exit area (bottom of the temple).

Each game turn:
You receive Indy's current position
Then you specify what Indy's position will be next turn.
Indy will then move from the current room to the next according to the shape of the current room.

---

**Code**

```ruby
# width and height of the labyrinth (input)
@w, @h = gets.split(' ').collect(&:to_i)
# array to save rooms
@rooms = []
# generate rooms (input)
@h.times { @rooms << gets.chomp.split(' ').map(&:to_i) }
# exit (input)
@ex = gets.to_i

# pattern numbers that send to left or right, depending where Indy comes from
LEFT = [[2, 'RIGHT'], [4, 'TOP'], [6, 'RIGHT'], [10, 'TOP']]
RIGHT = [[2, 'LEFT'], [5, 'TOP'], [6, 'LEFT'], [11, 'TOP']]

# define the next position depending on the current room's pattern and entrance
def move(x, y, pos)
  return "#{x - 1} #{y}" if LEFT.find { |v| v.first == @rooms[y][x] }&.last == pos # => to left
  return "#{x + 1} #{y}" if RIGHT.find { |v| v.first == @rooms[y][x] }&.last == pos # => to right
  "#{x} #{y + 1}" # => to bottom
end

# loop each time Indy enter in a room and output the next position
loop do
  xi, yi, pos = gets.split(' ') # inputs
  puts move(xi.to_i, yi.to_i, pos)
end
```