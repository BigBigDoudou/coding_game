## Temperatures

> [Link to challenge](https://www.codingame.com/ide/puzzle/temperatures)

---

**Rules**

Write a program that prints the temperature closest to 0 among input data. If two numbers are equally close to zero, positive integer has to be considered closest to zero (for instance, if the temperatures are -5 and 5, then display 5).

---

**Code**

```ruby
@n = gets.to_i # number of temperatures to analyse
# output min values compared after absolute them and choosing positive over negative is they are equal
puts gets.split(' ').map(&:to_i).min_by {|t| [t.abs, -t]} || 0
```
