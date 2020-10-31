# There is no Spoon

The game is played on a rectangular grid with a given size. Some cells contain power nodes. The rest of the cells are empty. The goal is to find, when they exist, the horizontal and vertical neighbors of each node.

To do this, you must find each (x1,y1) coordinates containing a node, and display the (x2,y2) coordinates of the next node to the right, and the (x3,y3) coordinates of the next node to the bottom within the grid. If a neighbor does not exist, you must output the coordinates -1 -1 instead of (x2,y2) and/or (x3,y3).

You lose if: You give an incorrect neighbor for a node ; You give the neighbors for an empty cell ; You compute the same node twice ; You forget to compute the neighbors of a node.

[Link to challenge](https://www.codingame.com/ide/puzzle/there-is-no-spoon-episode-1)

---

### ruby (1)

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

### ruby (2)

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

### go

```go
package main

import "fmt"
import "os"
import "bufio"
import "strings"

type Node struct {
	isNode               bool
	x, y, rx, ry, bx, by int
}

type Nodes []Node

func (nodes *Nodes) Push(node Node) Nodes {
	*nodes = append(*nodes, node)
	return *nodes
}

// find the first right node to given coordinates
func (nodes Nodes) Right(x, y int) (rx, ry int) {
	closest := 0
	rx = -1
	ry = -1
	for _, node := range nodes {
		if node.isNode && node.y == y && node.x > x {
			distance := node.x - x
			if closest == 0 || distance < closest {
				closest = distance
				rx = node.x
				ry = node.y
			}
		}
	}
	return rx, ry
}

// find the first bottom node to given coordinates
func (nodes Nodes) Bottom(x, y int) (bx, by int) {
	closest := 0
	bx = -1
	by = -1
	for _, node := range nodes {
		if node.isNode && node.x == x && node.y > y {
			distance := node.y - y
			if closest == 0 || distance < closest {
				closest = distance
				bx = node.x
				by = node.y
			}
		}
	}
	return bx, by
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	// width: the number of cells on the X axis
	var width int
	scanner.Scan()
	fmt.Sscan(scanner.Text(), &width)

	// height: the number of cells on the Y axis
	var height int
	scanner.Scan()
	fmt.Sscan(scanner.Text(), &height)

	// read lines from inputs
	// and create node for each value
	// and push it to nodes array
	nodes := Nodes{}
	for y := 0; y < height; y++ {
		scanner.Scan()
		line := scanner.Text() // width characters, each either 0 or .
		fmt.Fprintln(os.Stderr, line)
		values := strings.Split(line, "")
		for x, v := range values {
			node := Node{v == "0", x, y, -1, -1, -1, -1}
			nodes.Push(node)
		}
	}

	for _, node := range nodes {
		if node.isNode {
			rx, ry := nodes.Right(node.x, node.y)
			bx, by := nodes.Bottom(node.x, node.y)
			fmt.Println(node.x, node.y, rx, ry, bx, by)
		}
	}
}
```
