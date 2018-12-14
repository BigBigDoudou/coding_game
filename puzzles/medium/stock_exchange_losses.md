## Stock Exchange Losses

> [Link to challenge](https://www.codingame.com/ide/puzzle/stock-exchange-losses)

---

**Rules**

A finance company is carrying out a study on the worst stock investments and would like to acquire a program to do so. The program must be able to analyze a chronological series of stock values in order to show the largest loss that it is possible to make by buying a share at a given time t0 and by selling it at a later date t1. The loss will be expressed as the difference in value between t0 and t1. If there is no loss, the loss will be worth 0.

---

**Code Version 1**

```ruby
STDOUT.sync = true
@n = gets.to_i
inputs = gets.split(' ')

values = []
(0..@n - 1).each { |i| values << inputs[i].to_i }

# find next index where value is greater or equal to current index value
def next_index(values, index)
  next_index = values[index + 1..-1]
               .index { |value| value >= values[index] }
  next_index.nil? ? values.length - 1 : next_index + index + 1
end

lost = values.each_index.map do |index|
  # find minimal value in the area returned by next_index method and minus current value
  values[index..next_index(values, index)].min - values[index]
end.min

puts lost
```

---

**Code Version 2**

It could be done with a recursive method but the stack level is too deep for large dataset.

```ruby
STDOUT.sync = true
@n = gets.to_i
inputs = gets.split(' ')

values = []
(0..@n - 1).each { |i| values << inputs[i].to_i }

def accumulated_losses(losses, value, index, values)
  return losses if index == values.length - 1 ||
                   values[index + 1] >= value

  losses += values[index + 1] - values[index]
  accumulated_losses(losses, value, index + 1, values)
end

lost = values.each_index.map do |index|
  accumulated_losses(0, values[index], index, values)
end.min

puts lost
```
