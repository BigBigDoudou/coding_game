## Skynet Revolution

> [Link to challenge](https://www.codingame.com/ide/puzzle/skynet-revolution-episode-1)

---

**Rules**

Your virus has caused a backdoor to open on the Skynet network enabling you to send new instructions in real time.

You decide to take action by stopping Skynet from communicating on its own internal network.

Skynet's network is divided into several smaller networks, in each sub-network is a Skynet agent tasked with transferring information by moving from node to node along links and accessing gateways leading to other sub-networks.

Your mission is to reprogram the virus so it will sever links in such a way that the Skynet Agent is unable to access another sub-network thus preventing information concerning the presence of our virus to reach Skynet's central hub.

For each test you are given:
A map of the network.
The position of the exit gateways.
The starting position of the Skynet agent.
Nodes can only be connected to up to a single gateway.

Each game turn:
First off, you sever one of the given links in the network.
Then the Skynet agent moves from one Node to another accessible Node.

---

**Code**

```ruby
# n: total number of nodes in the level including the gateways
# l: number of links
# e: number of exit gateways
n, l, e = gets.split(' ').collect.map(&:to_i)

links = []
l.times { links << gets.split(' ').collect.map(&:to_i) }

gateways = []
e.times { gateways << gets.to_i }

loop do
  si = gets.to_i # index of the current node
  reachable_links = links.select { |link| link.include? si }
  # if link links to gateway, sever it, else sever first link found
  selected_link = reachable_links.find { |link| gateways.include?((link - [si])[0]) } ||
                  reachable_links.first
  puts selected_link.join(' ')
end
```
