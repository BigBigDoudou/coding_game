# Stock Exchange Losses

A finance company is carrying out a study on the worst stock investments and would like to acquire a program to do so. The program must be able to analyze a chronological series of stock values in order to show the largest loss that it is possible to make by buying a share at a given time t0 and by selling it at a later date t1. The loss will be expressed as the difference in value between t0 and t1. If there is no loss, the loss will be worth 0.

[Link to challenge](https://www.codingame.com/ide/puzzle/stock-exchange-losses)

---

### ruby

```ruby
@n = gets.to_i
@inputs = gets.split(' ').map(&:to_i)

def find_max_lost(inputs, max_lost = 0)
    # index where first value is recover (same or equal)
    recover_index = inputs[1..-1].index { |input| input >= inputs.first }&.+1
    # find the min value in this period and check the delta with studied value
    lost = inputs.first - inputs[1..(recover_index || -1)].min
    # replace max_lost if lost is greater
    max_lost = lost if lost > max_lost
    # return if value is never recovered or if there is only one value left
    return max_lost if !recover_index || (inputs.length - recover_index) == 1

    # find (and eventually replace) max lost for the following period
    find_max_lost(inputs[recover_index..-1], max_lost)
end

# switch the sign
puts find_max_lost(@inputs) * -1
```
