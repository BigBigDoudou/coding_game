# Skynet Revolution

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

[Link to challenge](https://www.codingame.com/ide/puzzle/skynet-revolution-episode-1)

---

## ruby

```ruby
# n: total number of nodes in the level including the gateways
# l: number of links
# e: number of exit gateways
n, l, e = gets.split(' ').map(&:to_i)

links = l.times.map { gets.split(' ').map(&:to_i) }
gateways = e.times.map { gets.to_i }

loop do
  # position of the current node
  node = gets.to_i
  # links connected to this node
  node_links = links.select { |link| link.include? node }
  # find link connected to a gateway or take the first one
  target = node_links.find { |link| (link & gateways).any? } || node_links.first
  puts target.join(' ')
end
```

## go

```go
package main

import "fmt"

func main() {
	// N: the total number of nodes in the level, including the gateways
	// L: the number of links
	// E: the number of exit gateways
	var N, L, E int
	fmt.Scan(&N, &L, &E)

	links := make([][]int, L)
	for i := 0; i < L; i++ {
		// N1: N1 and N2 defines a link between these nodes
		var N1, N2 int
		fmt.Scan(&N1, &N2)
		links[i] = []int{N1, N2}
	}

	gateways := make([]int, E)
	for i := 0; i < E; i++ {
		// EI: the index of a gateway node
		var EI int
		fmt.Scan(&EI)
		gateways[i] = EI
	}

	for {
		// NODE: The index of the node on which the Skynet agent is positioned this turn
		var NODE int
		fmt.Scan(&NODE)

		// links connected to this node
		nodeLinks := [][]int{}
		for _, link := range links {
			if link[0] == NODE || link[1] == NODE {
				nodeLinks = append(nodeLinks, link)
			}
		}

		// if link links to gateway, sever it, else sever first link found
		target := nodeLinks[0]
		for _, link := range nodeLinks {
			for _, gateway := range gateways {
				if link[0] == gateway || link[1] == gateway {
					target = link
					break
				}
			}
		}

		fmt.Println(target[0], target[1])
	}
}
```