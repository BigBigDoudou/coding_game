## ANEO Sponsored Puzzle

> [Link to challenge](https://www.codingame.com/ide/puzzle/aneo)

---

**Rules**

You enter a section of road and you plan to rest entirely on your cruise control to cross the area without having to stop or slow down.

The goal is to find the maximum speed (off speeding) that will allow you to cross all the traffic lights to green.

Warning: You can not cross a traffic light the second it turns red !

Your vehicle enters the zone directly at the speed programmed on the cruise control which ensures that it does not change anymore.

---

**Code**

```ruby
@max_speed = gets.to_i # (input)
@light_count = gets.to_i # (input)

@lights = []
@light_count.times do
  @lights << gets.split(' ').collect(&:to_i) # (input)
end

def best_speed(speed)
  all_green = true
  @lights.each do |light|
    # time (in seconds) when car reaches the light
    time = (light[0] / (speed * 1_000 / 3_600.to_f)).round(2)
    # if light is red (lights alternate between green (even) and red (odd))
    if ((time - time % light[1]) / light[1]).round.odd?
      all_green = false
      break
    end
  end
  # return speed if car crosses only green lights
  return speed if all_green

  # else, test with the speed below
  best_speed(speed - 1)
end

puts best_speed(@max_speed)
```
