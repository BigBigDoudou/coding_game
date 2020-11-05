# The Labyrinth

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

[Link to challenge](https://www.codingame.com/ide/puzzle/the-labyrinth)

---

### ruby

```ruby
# height and width of the labyrinth and time before alarm is triggered
@height, @width, @countdown = gets.split(' ').map(&:to_i)
@labyrinth = '' # labyrinth represented as a serial
@teleport, @control = nil, nil # teleport and control room positions
@node = nil # node currently analyzed in pathfinding
@finish = nil # information of last node reached in pathfinding
@position = nil # current position
@passages = Array.new(@height * @width, 0) # passages on a specific node
@open_list, @closed_list = [] # open list and closed list for pathfinding
@current_to_control, @control_to_teleport = nil, nil # pathes from point to another
@step_to_control, @step_to_teleport = 0, 0 # steps done in the pathes
@alarm = false # triggered alarm

# node above position
def up(position)
  position - @width if position >= @width
end

# node below position
def down(position)
  position + @width
end

# node left to position
def left(position)
  position - 1 if (position % @width).positive?
end

# node right to position
def right(position)
  position + 1 if ((position + 1) % @width).positive?
end

# reachable positions from a position (respecting reachable_chars)
def reachable_positions(position, allowed_chars)
  positions = [up(position), down(position), left(position), right(position)]
  positions.compact!
  positions.select { |side| allowed_chars.include?(@labyrinth[side]) }
end

# next position to explore when Kirk is only discovering the labyrinth
def next_position_to_explore
  positions = reachable_positions(@position, ['.', 'T'])
  # go to the reachable position where Kirk has less been
  positions.min_by { |position| @passages[position] }
end

# define the movement command from a position to go
def define_movement(position)
  return 'RIGHT' if position == @position + 1
  return 'LEFT' if position == @position - 1

  position < @position ? 'UP' : 'DOWN'
end

# find the shortest path from @node to a specific character (C, T)
def shortest_path(target, allowed_nodes)
  positions = reachable_positions(@node[:position], allowed_nodes)
  positions.each do |position|
    # do nothing if position is in the closed list
    next if @closed_list.map { |node| node[:position] }.include? position

    # update finish if position is finish, else update open list
    position == @labyrinth.index(target) ? update_finish(target) : update_open_list(position)
  end
  return if @open_list.empty? # stop the method if all nodes have been analyzed

  update_current_node # update next node to analyse
  shortest_path(target, allowed_nodes) # recall the method
end

# update finish node if distance found is shortest than the previous one
def update_finish(position)
  return if @finish && @node[:distance] + 1 >= @finish[:distance]

  @finish = {
    position: @labyrinth.index(position),
    parent: @node,
    distance: @node[:distance] + 1
  }
end

# define if node should be updated or created
def update_open_list(position)
  node = @open_list.find { |n| n[:position] == position }
  node ? update_node(node) : create_node(position)
end

# add node in the open list
def create_node(position)
  @open_list << {
    position: position,
    parent: @node,
    distance: @node[:distance] + 1
  }
end

# update node in the open list if distance found is shortest than the previous one
def update_node(node)
  return if @node[:distance] + 1 >= node[:distance]

  node[:parent] = @node
  node[:distance] = @node[:distance] + 1
end

# update node to analyze
def update_current_node
  @node = @open_list.shift
  @closed_list << @node
end

# generate path after path has been found by browding parents from finish
def generate_path
  node = @finish
  steps = []
  loop do
    steps << node[:position]
    node[:parent] ? node = node[:parent] : break
  end
  steps.reverse
end

# clean pathfinder variables
def clean_pathfinder
  @finish = nil
  @open_list = []
  @closed_list = []
end

loop do
  y, x = gets.split(' ').map(&:to_i) # y as row and x as column
  @position = y * @width + x # define current position
  @passages[@position] += 1 # add a passage on current position
  @alarm = true if @position == @labyrinth.index('C') # trigger alarm if enter control room
  @labyrinth = '' # empty labyrinth
  @height.times { @labyrinth << gets.chomp } # populate labyrinth (gets.chomp = row)
  @teleport ||= @labyrinth.index('T') # define teleport position
  @control ||= @labyrinth.index('C') # define control position
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
  if @control_to_teleport && @current_to_control.nil?
    clean_pathfinder
    @node = { position: @position, parent: nil, distance: 0 }
    @closed_list << @node
    shortest_path('C', ['T', '.', 'C'])
    if @finish
      @current_to_control = generate_path
    else
      next_position = next_position_to_explore(['T', '.'])
    end
  end

  # if there is a path between current position room and control room
  # (meaning a valid path has been found between control room and teleport)
  # and player is not in the control room
  # => reach control room
  if @current_to_control && !@alarm
    next_position = @current_to_control[@step_to_control + 1]
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
