# Telephone numbers

By joining the iDroid smartphone development team, you have been given the responsibility of developing the contact manager. Obviously, what you were not told is that there are strong technical constraints for iDroid: the system doesn’t have much memory and the processor is as fast as a Cyrix from the 90s...

In the specifications, there are two points in particular that catch your attention:

1. Intelligent Assistance for entering numbers
The numbers corresponding to the first digits entered will be displayed to the user almost instantly.

2. Number storage optimization
First digits which are common to the numbers should not be duplicated in the memory.

Your task is to write a program that displays the number of items (which are numbers) required to store a list of telephone numbers with the structure presented above.

[Link to challenge](https://www.codingame.com/ide/puzzle/telephone-numbers)

---

## rules

```ruby
substr = {}

n = gets.to_i # count of telephone numbers
n.times do
  phone = gets.chomp
  # split the number in consecutive subsequences
  # for example 0467123456 is splitted in: 0, 04, 046, ..., 0467123456
  # then set the value for this subsequence to true (use memoization to speed up process)
  phone.size.times { |i| substr[phone[0..i]] ||= true }
end

puts substr.length
```
