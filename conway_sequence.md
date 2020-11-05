# Conway Sequence

You mission is to print a specific line of the Conway sequence with a specific original number.

Example with 1 as original number and 6 as line to put:

```
     1
    1 1
    2 1
  1 2 1 1
1 1 1 2 2 1
3 1 2 2 1 1 <= puts
```

[Link to challenge](https://www.codingame.com/ide/puzzle/conway-sequence)

---

### ruby

```ruby
@r = gets.to_i # original number
@l = gets.to_i # row to display

# Define line following another line
def next_line(line, acc = [])
  # take the first number in the line
  current = line.first
  # find the index of the first different number
  # if there is not, all numbers are the same so count = line.length
  count = line.index { |number| number != current } || line.length
  # add the count then the current number to the accumulator
  acc << count << current
  # if all the numbers are the same, return the accumulator
  return acc if count == line.length

  # continue to investigate following numbers
  next_line(line[count..-1], acc)
end

# Generate conway sequence and return the last line
def conway_sequence(line, size, count)
  # return line if row to display is reached
  return line.join(' ') if count == size

  # find next line and call method recursively
  conway_sequence(next_line(line), size, count + 1)
end

puts conway_sequence([@r], @l, 1)
```

### ruby - with #chunks

```ruby
@r = gets.to_i # original number
@l = gets.to_i # row to display

def conway_sequence(line, size, count)
  return line.join(' ') if count == size

  next_line = line.chunk { |n| n } .map { |c| [c[1].count, c[0]] } .flatten
  conway_sequence(next_line, size, count + 1)
end

puts conway_sequence([@r], @l, 1)
```