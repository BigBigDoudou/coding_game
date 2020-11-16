# Temperatures

Write a program that prints the temperature closest to 0 among input data. If two numbers are equally close to zero, positive integer has to be considered closest to zero (for instance, if the temperatures are -5 and 5, then display 5).

[Link to challenge](https://www.codingame.com/ide/puzzle/temperatures)

---

## ruby

```ruby
_ = gets.to_i # number of temperatures to analyse (unused)
# output min value after comparing them with absolute and choosing positive over negative if equal
puts gets.split(' ').map(&:to_i).min_by { |t| [t.abs, -t] } || 0
```
