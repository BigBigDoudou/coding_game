

## The Labyrinth

> [Link to challenge](https://www.codingame.com/ide/puzzle/the-labyrinth)

---

**Rules**

Once teleported inside the structure, your mission is to:
* find the control room from which you will be able to deactivate the tracker beam;
* get back to your starting position once you've deactivated the tracker beam.

The structure is arranged as a rectangular maze composed of cells. Within the maze Kirk can go in any of the following directions: UP, DOWN, LEFT or RIGHT.

Kirk is using his tricorder to scan the area around him but due to a disruptor field, he is only able to scan the cells located in a 5-cell wide square centered on him.

Unfortunately, Spock was correct, there is a trap! Once you reach the control room an alarm countdown is triggered and you have only a limited number of rounds before the alarm goes off. Once the alarm goes off, Kirk is doomed...

Kirk will die if any of the following happens:
* Kirk's jetpack runs out of fuel. You have enough fuel for 1200 movements;
* Kirk does not reach the starting position before the alarm goes off (the alarm countdown is triggered once the control room has been reached);
* Kirk touches a wall or the ground: he is ripped apart by a mechanical trap.
You will be successful if you reach the control room and get back to the starting position before the alarm goes off.

Maze format // A maze in ASCII format is provided as input. The character # represents a wall, the letter . represents a hollow space, the letter T represents your starting position, the letter C represents the control room and the character ? represents a cell that you have not scanned yet.

---

**Code**

```ruby
STDOUT.sync = true
@height, @width, @countdown = gets.split(' ').collect.map(&:to_i)
@maze = ''
@teleport = nil
@control = nil
@node = nil
@finish = nil
@position = nil
@passages = Array.new(@height * @width, 0)
@open_list = []
@closed_list = []
@current_to_control_path = nil
@control_to_teleport = nil
@step_to_control = 0
@step_to_teleport = 0
@alarm = false

def up(position)
  position >= @width ? position - @width : nil
end

def down(position)
  position + @width
end

def left(position)
  (position % @width).zero? ? nil : position - 1
end

def right(position)
  ((position + 1) % @width).zero? ? nil : position + 1
end

def reachable_positions(position, reachable_chars)
  [up(position), down(position), left(position), right(position)]
    .select { |side| side && reachable_chars.include?(@maze[side]) }
end

def next_position_to_explore
  positions = reachable_positions(@position, ['.', 'T'])
  top_position = positions[0]
  positions[1..-1].each do |position|
    top_position = position if @passages[position] < @passages[top_position]
  end
  top_position
end

def define_movement(position)
  return 'RIGHT' if position == @position + 1
  return 'LEFT' if position == @position - 1
  return 'UP' if position < @position
  return 'DOWN' if position > @position
end

def shortest_path(char, reachable_chars)
  reachable_positions(@node[:position], reachable_chars).each do |position|
    next if @closed_list.map { |node| node[:position] }.include? position

    position == @maze.index(char) ? update_finish(char) : update_open_list(position, char)
  end
  return nil if @open_list.empty?

  update_current_node
  shortest_path(char, reachable_chars)
end

def update_finish(char)
  return nil if @finish && @node[:distance] + 1 >= @finish[:distance]

  @finish = {
    position: @maze.index(char),
    parent: @node,
    distance: @node[:distance] + 1
  }
end

def update_open_list(position, char)
  node = @open_list.find { |n| n[:position] == position }
  node ? update_node(node) : create_node(position, char)
end

def create_node(position, char)
  return nil if position == @maze.index(char)

  @open_list << {
    position: position,
    parent: @node,
    distance: @node[:distance] + 1
  }
end

def update_node(node)
  return nil if @node[:distance] + 1 >= node[:distance]

  node[:parent] = @node
  node[:distance] = @node[:distance] + 1
end

def update_current_node
  @node = @open_list.shift
  @closed_list << @node
end

def generate_path
  node = @finish
  steps = []
  loop do
    steps << node[:position]
    node[:parent] ? node = node[:parent] : break
  end
  steps.reverse
end

def clean_pathfinder
  @finish = nil
  @open_list = []
  @closed_list = []
end

loop do
  y, x = gets.split(' ').collect.map(&:to_i)
  @position = y * @width + x
  @passages[@position] += 1
  @alarm = true if @position == @maze.index('C')
  @maze = ''
  @height.times do
    @maze << gets.chomp
  end
  @teleport ||= @maze.index('T')
  @control ||= @maze.index('C')
  @node ||= { position: @teleport, parent: nil, distance: 0 }

  # while no valid path has been found between control room and teleport
  # => continue exploration
  next_position = next_position_to_explore if @control_to_teleport.nil?

  # if control room is known
  # and no valid path has been found between control room and teleport
  # try to find a valid path
  if @control && @control_to_teleport.nil?
    clean_pathfinder
    @node = { position: @control, parent: nil, distance: 0 }
    @closed_list << @node
    shortest_path('T', ['T', '.'])
    @control_to_teleport = generate_path if @finish && @finish[:distance] <= @countdown
  end

  # if a valid path has been found between control room and teleport
  # but no path has been found between current position room and control room
  # try to find a path
  if @control_to_teleport && @current_to_control_path.nil?
    clean_pathfinder
    @node = { position: @position, parent: nil, distance: 0 }
    @closed_list << @node
    shortest_path('C', ['T', '.', 'C'])
    if @finish
      @current_to_control_path = generate_path
    else
      next_position = next_position_to_explore(['T', '.'])
    end
  end

  # if there is a path between current position room and control room
  # (meaning a valid path has been found between control room and teleport)
  # and player is not in the control room
  # => reach control room
  if @current_to_control_path && !@alarm
    next_position = @current_to_control_path[@step_to_control + 1]
    @step_to_control += 1
  end

  # if player is in the control room
  # => go back to teleport
  if @alarm
    next_position = @control_to_teleport[@step_to_teleport + 1]
    @step_to_teleport += 1
  end

  puts define_movement(next_position)
end
```
