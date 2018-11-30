## There is no Spoon - Episode 1

> [Link to challenge](https://www.codingame.com/ide/puzzle/there-is-no-spoon-episode-1)

**Rules**
    
**Code**

```ruby
@width = gets.to_i # the number of cells on the X axis
@height = gets.to_i # the number of cells on the Y axis

@lines = []
@height.times do
    line = gets.chomp # width characters, each either 0 or .
    @lines << line
end

@nodes = []
@lines.each_with_index do |line, y|
    line.gsub(/\./, '1').chars.map(&:to_i).each_with_index do |value, x|
        @nodes << [x, y] if value.zero?
    end
end

def right_node(coordinates)
    @nodes
        .select { |node| node[1] == coordinates[1] }
        .sort_by { |node| node[0] }
        .find { |node| node[0] > coordinates[0] }
end

def bottom_node(coordinates)
    @nodes
        .select { |node| node[0] == coordinates[0] }
        .sort_by { |node| node[1] }
        .find { |node| node[1] > coordinates[1] }
end

@nodes.each do |node|
    right = right_node(node) || [-1, -1]
    bottom = bottom_node(node) || [-1, -1]
    puts "#{node[0]} #{node[1]} #{right[0]} #{right[1]} #{bottom[0]} #{bottom[1]}"
end
```

**Or, with a Node class (longer but more understandable and reusable):**

```ruby
@width = gets.to_i # the number of cells on the X axis
@height = gets.to_i # the number of cells on the Y axis

lines = []
@height.times do
    line = gets.chomp # width characters, each either 0 or .
    lines << line
end

class Node
    @@nodes = []
    attr_reader :x, :y
    
    def initialize(x, y)
        @x, @y = x, y
        @@nodes << self
    end
    
    def self.coordinates
        @@nodes.each { |node| node.coordinates }
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
