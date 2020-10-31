
# Shadows of the knight

Batman will look for the hostages on a given building by jumping from one window to another using his grapnel gun. Batman's goal is to jump to the window where the hostages are located in order to disarm the bombs. Unfortunately he has a limited number of jumps before the bombs go off...

Before each jump, the heat-signature device will provide Batman with the direction of the bombs based on Batman current position: `U` (Up), `UR` (Up-Right), `R` (Right), `DR` (Down-Right), `D` (Down), `DL` (Down-Left), `L` (Left), `UL` (Up-Left).

Your mission is to program the device so that it indicates the location of the next window Batman should jump to in order to reach the bombs' room as soon as possible. Buildings are represented as a rectangular array of windows, the window in the top left corner of the building is at index (0,0).

**Game input**

The program must first read the initialization data from standard input. Then, within an infinite loop, read the device data from the standard input and provide to the standard output the next movement instruction.

**Initialization input**

Line 1 : 2 integers `W` `H`. The (`W`, `H`) couple represents the width and height of the building as a number of windows.

Line 2 : 1 integer `N`, which represents the number of jumps Batman can make before the bombs go off.

Line 3 : 2 integers `X0` `Y0`, representing the starting position of Batman.

**Input for one game turn**

The direction indicating where the bomb is.

**Output**

A single line with 2 integers `X` `Y` separated by a space character. (`X`, `Y`) represents the location of the next window Batman should jump to. `X` represents the index along the horizontal axis, `Y` represents the index along the vertical axis. (0,0) is located in the top-left corner of the building.

[Link to challenge](https://www.codingame.com/ide/puzzle/shadows-of-the-knight-episode-1)

---

### Ruby

```ruby
STDOUT.sync = true
w, h = gets.split(' ').map(&:to_i) # width and height of the building
n = gets.to_i # maximum number of turns before game over (unused => specs input)
x, y = gets.split(' ').map(&:to_i) # current position
area = [0, w, 0, h] # search area

loop do
  # direction of the bombs from batman's location
  # (U, UR, R, DR, D, DL, L or UL)
  bomb_dir = gets.chomp

  # reduce the search area
  area[0] = x if x > area[0] && bomb_dir.include?('R')
  area[1] = x if x < area[1] && bomb_dir.include?('L')
  area[2] = y if y > area[2] && bomb_dir.include?('D')
  area[3] = y if y < area[3] && bomb_dir.include?('U')

  # jump in the middle of the new search area (divide and conquer algorithm)
  x = (area[0] + area[1]) >> 1 # divide with bitwise operator
  y = (area[2] + area[3]) >> 1
  puts "#{x} #{y}"
end
```

### Go

```go
package main

import (
	"fmt"
	"strings"
)

// Area represents a square defined by its four edges
type Area struct {
	L, R, T, B int
}

// tighten to reduce the search area
func (area *Area) tighten(dir string, X, Y int) {
	if strings.Contains(dir, "R") {
		// set the left value of the area to the current X
		area.L = X
	}

	if strings.Contains(dir, "L") {
		// set the right value of the area to the current X
		area.R = X
	}

	if strings.Contains(dir, "D") {
		// set the top value of the area to the current Y
		area.T = Y
	}

	if strings.Contains(dir, "U") {
		// set the bottom value of the area to the current Y
		area.B = Y
	}
}

// return the horizontal and vertical centers of the area
func (area Area) centers() (int, int) {
	x := (area.L + area.R) >> 1 // divide with bitwise operator
	y := (area.T + area.B) >> 1
	return x, y
}

func main() {
	// width and height of the building
	var W, H int
	fmt.Scan(&W, &H)

	// maximum number of turns before game over
	var N int
	fmt.Scan(&N)

	// position of batman
	var X0, Y0 int
	fmt.Scan(&X0, &Y0)

	// initialize an Area matching the building size
	area := Area{0, W, 0, H}

	for {
		// bombDir: the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
		var bombDir string
		fmt.Scan(&bombDir)

		// tighten the search area
		area.tighten(bombDir, X0, Y0)

		// jump to the center of the area (divide-and-conquer algorithm)
		X0, Y0 = area.centers()

		// the location of the next window Batman should jump to
		fmt.Println(X0, Y0)
	}
}
```

### Javascript

```javascript
const [w, h] = readline().split(' ').map(input => parseInt(input)); // width and height
const n = parseInt(readline()); // maximum number of turns before game over.
let [x, y] = readline().split(' ').map(input => parseInt(input)); // batman position
const area = [0, w, 0, h] // search area

while (true) {
  const bombDir = readline(); // the direction of the bomb (U, UR, R, DR, D, DL, L or UL)

  // reduce the search area
  if (x > area[0] && bombDir.includes('R')) {
    area[0] = x
  } else if (x < area[1] && bombDir.includes('L')) { // search left only if not right
    area[1] = x
  }

  if (y > area[2] && bombDir.includes('D')) {
    area[2] = y
  } else if (y < area[3] && bombDir.includes('U')) { // search up only if not down
    area[3] = y
  }


  // jump in the middle of the new search area
  x = (area[0] + area[1]) >> 1 // divide by 2*1 with right shift operator
  y = (area[2] + area[3]) >> 1

  // the location of the next window batman should jump to
  console.log(x, y);
}
```
