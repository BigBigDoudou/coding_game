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

## ruby

**Solution 1** -> Use recursion

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

  # investigate following numbers
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

**Solution 2** -> Use `#chunk`

> Enumerates over the items, chunking them together based on the return value of the block. Consecutive elements which return the same block value are chunked together.
>
> -- <cite>[API dock /ruby/Enumerable/chunk](https://apidock.com/ruby/Enumerable/chunk)</cite>



```ruby
@r = gets.to_i # original number
@l = gets.to_i # row to display

def conway_sequence(line, size, count)
  return line.join(' ') if count == size

  next_line = line.chunk { |n| n } .map { |c| [c[1].count, c[0]] }.flatten
  conway_sequence(next_line, size, count + 1)
end

puts conway_sequence([@r], @l, 1)
```

## go

```go
package main

import(
    "fmt"
    "strconv"
)

// Define line following another line
func nextLine(line []int, acc []int) []int {
  // take the first number in the line
  current := line[0]
  // find the index of the first different number
  // if there is not, all numbers are the same so count is line length
  count := len(line)
  for i, v := range line {
      if v != current {
          count = i
          break
      }
  }
  // add the count then the current number to the accumulator
  acc = append(acc, count, current)
  // if all the numbers are the same, return the accumulator
  if count == len(line) {
      return acc
  }

  // investigate following numbers
  return nextLine(line[count:], acc)
}

//Generate conway sequence and return the last line
func conwaySequence(line []int, size int, count int) string {
    // return line if row to display is reached
    if count == size {
        res := ""
        for _, v := range line {
            res = res + " " + strconv.Itoa(v)
        }
        return res[1:] // remove first space char
    }

    // find next line and call method recursively
    nextLine := nextLine(line, []int{})
    return conwaySequence(nextLine, size, count + 1)
}

func main() {
    var R int
    fmt.Scan(&R)
    
    var L int
    fmt.Scan(&L)

    fmt.Println(conwaySequence([]int{R}, L, 1))// Write answer to stdout
}
```

## javascript

```javascript
// Define line following another line
const nextLine = (line, acc = []) => {
  // find the index of the first number diffrent than the first one
  const diffIndex = line.findIndex((v) => v !== line[0]) // -1 if not found
  // if there is not (-1), all numbers are the same so count is line length
  const count = diffIndex === -1 ? line.length : diffIndex
  // add the count then the first number to the accumulator
  acc.push(count, line[0])
  return count === line.length
    // return the accumulator
    ? acc
    // investigate following numbers
    : nextLine(line.slice(count), acc)
}

// Generate conway sequence and return the last line
const conwaySequence = (line, size, count = 1) => (
  count === size
  // return line as string
    ? line.join(' ')
    // find next line and call method recursively
    : conwaySequence(nextLine(line), size, count + 1)
)

const R = parseInt(readline())
const L = parseInt(readline())

console.log(conwaySequence([R], L))
```