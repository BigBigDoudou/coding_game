## Conway Sequence

> [Link to challenge](https://www.codingame.com/ide/puzzle/conway-sequence)

---

**Rules**
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

---

**Code**

```ruby
STDOUT.sync = true
@r = gets.to_i # original number
@l = gets.to_i # row to display

# define line following another line
def next_line(line)
  count = 1
  next_line = []
  line.each_with_index do |number, index|
    # if succession of similar numbers
    if line[index + 1] == number
      count += 1 # update count of similar numbers
      next
    end
    # ...else
    next_line << count << number # add count and number to next_line
    count = 1 # restart count
  end
  next_line
end

# generate conway sequence and return the last line
def conway_sequence(line, size, count)
  # return line if row to display is reached
  return line.join(' ') if count == size

  # find next line and call method recursively
  next_line = next_line(line)
  conway_sequence(next_line, size, count + 1)
end

puts conway_sequence([@r], @l, 1)
```
