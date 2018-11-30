## Temperatures

> [Link to challenge](https://www.codingame.com/ide/puzzle/temperatures)

```ruby
@n = gets.to_i # the number of temperatures to analyse
inputs = gets.split(" ")
closest = 0
for i in 0..(@n-1)
    t = inputs[i].to_i
    closest = t if t.abs < closest.abs || (t.abs == closest.abs && t.positive?) || i.zero?
end

puts closest
```
