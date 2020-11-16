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