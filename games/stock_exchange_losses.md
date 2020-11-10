# Stock Exchange Losses

A finance company is carrying out a study on the worst stock investments and would like to acquire a program to do so. The program must be able to analyze a chronological series of stock values in order to show the largest loss that it is possible to make by buying a share at a given time t0 and by selling it at a later date t1. The loss will be expressed as the difference in value between t0 and t1. If there is no loss, the loss will be worth 0.

[Link to challenge](https://www.codingame.com/ide/puzzle/stock-exchange-losses)

---

## ruby

**Solution 1** -> Iterate on each number and update current value and max delta where necessary.

```ruby
gets.to_i # the count of inputs is unused

# <current> is the compared number
#   on first iteration, it is set to the given number
#   then it is replaced each time a greater number is found
current = 0

# <delta> is the maximum delta found (negatively)
#   it is initialized to 0
#   then it is replaced each time a greatest delta is found
delta = 0

# for each given number (stock value)
numbers = gets.split(' ').map(&:to_i)
numbers.each do |number|
    # if the delta between number and current is less than the one ever found
    #   then replace it
    delta = [delta, number - current].min
    # if the number is greater than the current
    #   then replace it
    current = [current, number].max
end

puts delta
```

**Solution 2** -> Use recursion to check each period between recoveries.

```ruby
gets.to_i # the count of inputs is unused
@inputs = gets.split(' ').map(&:to_i)

def max_delta(inputs, current_max = 0)
    # index where first value is recover (same or equal)
    recover_index = inputs[1..-1].index { |input| input >= inputs.first }&.+1
    # find the min value in this period and check the delta with studied value
    delta = inputs.first - inputs[1..(recover_index || -1)].min
    # replace current_max if delta is greater
    current_max = delta if delta > current_max
    # return if value is never recovered or if there is only one value left
    return current_max if !recover_index || (inputs.length - recover_index) == 1

    # find (and eventually replace) max delta for the following period
    max_delta(inputs[recover_index..-1], current_max)
end

# switch the sign
puts max_delta(@inputs) * -1
```

## go

**Solution 1** -> Iterate on each number and update current value and max delta where necessary.

```go
package main

import(
    "fmt"
    "bufio"
    "os"
    "strings"
    "strconv"
)

func min(x, y int64) int64 {
    if x < y {
        return x
    }
    return y
}

func max(x, y int64) int64 {
    if x > y {
        return x
    }
    return y
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Buffer(make([]byte, 1000000), 1000000)
	scanner.Scan() // run unused scanner
	scanner.Scan() // run unused scanner

    // <current> is the compared number
    //   on first iteration, it is set to the given number
    //   then it is replaced each time a greater number is found
    current := int64(0)

    // <delta> is the maximum delta found (negatively)
    //   it is initialized to 0
    //   then it is replaced each time a greatest delta is found
    delta := int64(0)

    str_numbers := strings.Split(scanner.Text()," ")
    for _, str_number := range str_numbers {
        // convert number to int64
        number, _ := strconv.ParseInt(str_number, 10, 32)
        // if the delta between number and current is less than the one ever found
        //   then replace it
        delta = min(delta, number - current)
        // if the number is greater than the current
        //   then replace it
        current = max(current, number)
    }

    fmt.Println(delta)
}
```

**Solution 2** -> Use recursion to check each period between recoveries.

```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func maxDelta(numbers []int64, currentMax int64) int64 {
	// compared value
	value := numbers[0]

	// index where first value is recover (same or equal)
	recoverIndex := 0
	minNumber := value
	for i, number := range numbers[1:] {
		if number < minNumber {
			minNumber = number
		}

		if number >= value {
			recoverIndex = i + 1
			break
		}
	}

	// update max delta
	delta := value - minNumber
	if delta > currentMax {
		currentMax = delta
	}

	// return if value is never recovered or if there is only one value left
	if recoverIndex == 0 || len(numbers)-recoverIndex == 1 {
		return currentMax
	}

	// find (and eventually replace) max delta for the following period
	return maxDelta(numbers[recoverIndex:], currentMax)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	var n int
	scanner.Scan()
	fmt.Sscan(scanner.Text(), &n)

	scanner.Scan()
	inputs := strings.Split(scanner.Text(), " ")
	numbers := make([]int64, n)
	for i := 0; i < n; i++ {
		v, _ := strconv.ParseInt(inputs[i], 10, 32)
		numbers[i] = v
	}

	// use maxDelta() and switch sign
	fmt.Println(maxDelta(numbers, 0) * -1)
}
```

## javascript

**Solution 1** -> Iterate on each number and update current value and max delta where necessary.

```javascript
readline() // the count of inputs is unused

// <current> is the compared number
//   on first iteration, it is set to the given number
//   then it is replaced each time a greater number is found
let current = 0

// <delta> is the maximum delta found (negatively)
//   it is initialized to 0
//   then it is replaced each time a greatest delta is found
let delta = 0

// for each given number (stock value)
const numbers = readline().split(' ')
numbers.forEach((number) => {
	// if the delta between number and current is less than the one ever found
	//   then replace it
	delta = Math.min(delta, number - current)
	// if the number is greater than the current
	//   then replace it
	current = Math.max(current, number)
})

console.log(delta)
```

**Solution 2** -> Use recursion to check each period between recoveries.

```javascript
readline() // the count of inputs is unused
const inputs = readline().split(' ').map((input) => parseInt(input))

const maxDelta = (numbers, currentMax = 0) => {
	// index where first value is recover (same or equal)
	let recoverIndex = 0
	let minNumber = numbers[0]
	for (let i = 1; i < numbers.length; i += 1) {
		if (numbers[i] >= numbers[0]) {
			recoverIndex = i
			break
		}

		if (numbers[i] < minNumber) {
			minNumber = numbers[i]
		}
	}

	// update max delta
	const nextMax = minNumber - numbers[0] < currentMax
        ? minNumber - numbers[0]
        : currentMax

	// return if numbers[0] is never recovered or if there is only one number left
	if (recoverIndex === 0 || numbers.length - recoverIndex === 1) {
		return nextMax
	}

	// find (and eventually replace) max delta for the following period
    // the purpose is to analyze only necessary numbers and not to iterate on each
	return maxDelta(numbers.slice(recoverIndex), nextMax)
}

console.log(maxDelta(inputs));
```