## There is no Spoon

> [Link to challenge](https://www.codingame.com/ide/puzzle/there-is-no-spoon-episode-1)

---

**Rules**

The game is played on a rectangular grid with a given size. Some cells contain power nodes. The rest of the cells are empty. The goal is to find, when they exist, the horizontal and vertical neighbors of each node.

To do this, you must find each (x1,y1) coordinates containing a node, and display the (x2,y2) coordinates of the next node to the right, and the (x3,y3) coordinates of the next node to the bottom within the grid. If a neighbor does not exist, you must output the coordinates -1 -1 instead of (x2,y2) and/or (x3,y3).

You lose if: You give an incorrect neighbor for a node ; You give the neighbors for an empty cell ; You compute the same node twice ; You forget to compute the neighbors of a node.

---

**Code Version 1**

*Straight code without class*

```ruby
@width = gets.to_i # number of cells on the X axis
@height = gets.to_i # number of cells on the Y axis

lines = []
@height.times do { lines << gets.chomp } # width characters, each either 0 or .

@nodes = []
lines.each_with_index do |line, y|
  line.chars.each_with_index do |value, x|
    # add coordinates x and y unless there is no node (input is .)
    @nodes << [x, y] unless value == '.'
  end
end

# find next node on the right
def right_node(coordinates)
  @nodes
    .select { |node| node[1] == coordinates[1] } # nodes on the same line (y)
    .sort_by { |node| node[0] } # sort from left to right (by x)
    .find { |node| node[0] > coordinates[0] } # take first node found (or return nil)
end

# find next node on the bottom
def bottom_node(coordinates)
  @nodes
    .select { |node| node[0] == coordinates[0] } # nodes on the same column (x)
    .sort_by { |node| node[1] } # sort from top to bottom (by y)
    .find { |node| node[1] > coordinates[1] } # take first node found (or return nil)
end

@nodes.each do |node|
  right = right_node(node) || [-1, -1] # return [-1, -1] if right_node return nil
  bottom = bottom_node(node) || [-1, -1] # return [-1, -1] if bottom_node return nil
  puts "#{node[0]} #{node[1]} #{right[0]} #{right[1]} #{bottom[0]} #{bottom[1]}"
end
```

---

**Code Version 2**

*With a Node class, longer but understandable and reusable*

```ruby
@width = gets.to_i # the number of cells on the X axis
@height = gets.to_i # the number of cells on the Y axis

lines = []
@height.times do { lines << gets.chomp } # width characters, each either 0 or .

class Node
  @@nodes = []
  attr_reader :x, :y
  def initialize(x, y)
    @x, @y = x, y
    @@nodes << self
  end

  def self.coordinates
    @@nodes.each(&:coordinates)
  end

  def coordinates
    right = self.right ? "#{self.right.x} #{self.right.y}" : '-1 -1'
    bottom = self.bottom ? "#{self.bottom.x} #{self.bottom.y}" : '-1 -1'
    puts "#{@x} #{@y} #{right} #{bottom}"
  end

  def right
    @@nodes
      .select { |node| node.y == @y }
      .sort_by(&:x)
      .find { |node| node.x > @x }
  end

  def bottom
    @@nodes
      .select { |node| node.x == @x }
      .sort_by(&:x)
      .find { |node| node.y > @y }
  end
end

lines.each_with_index do |line, y|
  line.chars.each_with_index do |value, x|
    Node.new(x, y) unless value == '.'
  end
end

Node.coordinates
```
