## Don't panic

> [Link to challenge](https://www.codingame.com/ide/puzzle/don't-panic-episode-1)

---

**Rules**

You need to help Marvin and his clones (or is it the other way round?) reach the exit in order to help them escape the inside of the Infinite Improbability Drive.

The drive has a rectangular shape of variable size. It is composed of several floors (0 = lower floor) and each floor has several possible positions that the clones can occupy (0 = leftmost position, width - 1 = rightmost position).

The goal is to save at least one clone in a limited amount of rounds.

The details:
Clones appear from a unique generator at regular intervals, every three game turns. The generator is located on floor 0. Clones exit the generator heading towards the right.

Clones move one position per turn in a straight line, moving in their current direction.

A clone is destroyed by a laser if it is goes below position 0 or beyond position width - 1.

Elevators are scattered throughout the drive and can be used to move from one floor to the one above. When a clone arrives on the location of an elevator, it moves up one floor. Moving up one floor takes one game turn. On the next turn, the clone continues to move in the direction it had before moving upward.

On each game turn you can either block the leading clone - meaning the one that got out the earliest - or do nothing.

Once a clone is blocked, you can no longer act on it. The next clone in line takes the role of "leading clone" and can be blocked at a later time.

When a clone moves towards a blocked clone, it changes direction from left to right or right to left. It also changes direction when getting out of the generator directly on a blocked clone or when going up an elevator onto a blocked clone.

If a clone is blocked in front of an elevator, the elevator can no longer be used.

When a clone reaches the location of the exit, it is saved and disappears from the area.

---

**Code**

```ruby
# nb_floors: number of floors (input)
# width: width of the area (input)
# nb_rounds: maximum number of rounds (input)
# exit_floor: floor on which the exit is found (input)
# exit_pos: position of the exit on its floor (input)
# nb_total_clones: number of generated clones (input)
# nb_additional_elevators: ignore (always zero) (input)
# nb_elevators: number of elevators (input)
@nb_floors, @width, @nb_rounds, @exit_floor, @exit_pos, @nb_total_clones,
@nb_additional_elevators, @nb_elevators = gets.split(' ').collect(&:to_i)

elevators = []
@nb_elevators.times do
  # floor + position of the elevator
  elevators << gets.split(' ').collect(&:to_i)
end

loop do
  # clone_floor: floor where the leading clone is (input)
  # clone_pos: position where the leading clone is (input)
  # direction: direction of the leading clone: LEFT or RIGHT (input)
  clone_floor, clone_pos, direction = gets.split(' ')
  clone_floor, clone_pos = clone_floor.to_i, clone_pos.to_i

  block = elevators.find { |elevator| elevator.first == clone_floor }&.last ||
          @exit_pos

  # if leading clone reaches the start or the end of the floor
  # or if clone is between an elevator / the exit and the start / the end of the floor
  # then block leading clone, else let him walk
  action = if clone_pos.zero? || clone_pos == @width - 1 ||
              (direction == 'LEFT' && clone_pos < block) ||
              (direction == 'RIGHT' && clone_pos > block)
             'BLOCK'
           else
             'WAIT'
           end

  puts action
end
```
