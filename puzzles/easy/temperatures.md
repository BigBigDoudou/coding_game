## Temperatures

> [Link to challenge](https://www.codingame.com/ide/puzzle/temperatures)

---

**Rules**

Write a program that prints the temperature closest to 0 among input data. If two numbers are equally close to zero, positive integer has to be considered closest to zero (for instance, if the temperatures are -5 and 5, then display 5).

---

**Code**

```ruby
@n = gets.to_i # the number of temperatures to analyse
inputs = gets.split(' ')
closest = 0

for i in 0..(@n-1)
  t = inputs[i].to_i
  closest = t if t.abs < closest.abs ||
                 (t.abs == closest.abs && t.positive?) ||
                 i.zero?
end

puts closest
```
