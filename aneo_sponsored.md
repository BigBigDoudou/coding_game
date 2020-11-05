# ANEO Sponsored Puzzle

You enter a section of road and you plan to rest entirely on your cruise control to cross the area without having to stop or slow down.

The goal is to find the maximum speed (off speeding) that will allow you to cross all the traffic lights to green.

Warning: You can not cross a traffic light the second it turns red !

Your vehicle enters the zone directly at the speed programmed on the cruise control which ensures that it does not change anymore.

[Link to challenge](https://www.codingame.com/ide/puzzle/aneo)

---

### ruby

```ruby
@max_kmh_speed = gets.to_i
@light_count = gets.to_i

@lights = []
@light_count.times do
  @lights << gets.split(' ').collect(&:to_i)
end

# Returns true if lights will be all green at the given speed
def all_green?(kmh_speed)
  # switch from kilometers/hour to meters/second
  # since light.distance is in meter and light.duration in second
  ms_speed = kmh_speed * 1_000 / 3_600.to_f
  @lights.all? do |light|
    time = (light[0] / ms_speed).round(2)
    # check if line is green at the given time
    ((time - time % light[1]) / light[1]).round.even?
  end
end

# Returns the best possible speed (decrement recursively)
def best_speed(kmh_speed)
  all_green?(kmh_speed) ? kmh_speed : best_speed(kmh_speed - 1)
end

puts best_speed(@max_kmh_speed)
```

### go

```go
package main

import (
	"fmt"
	"math"
)

type Light struct {
	distance float64
	duration int
}

// Returns true if lights will be all green at the given speed
func allGreen(lights []Light, kmhSpeed int) bool {
	// switch from kilometers/hour to meters/second
	// since light.distance is in meter and light.duration in second
	msSpeed := float64(kmhSpeed) * 1_000 / 3_600
	for _, light := range lights {
		// rounding to one decimal before casting to int is necessary
		// due to the tests implementation
		time := int(math.Round(light.distance/msSpeed*10) / 10)
		// define if the light is green at the given time
		green := ((time-time%light.duration)/light.duration)%2 == 0
		if !green {
			return false
		}
	}

	return true
}

// Returns the highest possible speed (decrement recursively)
func bestSpeed(lights []Light, kmhSpeed int) int {
	if allGreen(lights, kmhSpeed) {
		return kmhSpeed
	}

	return bestSpeed(lights, kmhSpeed-1)
}

func main() {
	var kmhSpeed int
	fmt.Scan(&kmhSpeed)

	var lightCount int
	fmt.Scan(&lightCount)

	lights := []Light{}

	for i := 0; i < lightCount; i++ {
		var distance float64
		var duration int
		fmt.Scan(&distance, &duration)
		lights = append(lights, Light{distance, duration})
	}

	fmt.Println(bestSpeed(lights, kmhSpeed))
}
```