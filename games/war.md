# War

Your goal is to write a program which finds out which player is the winner for a given card distribution of the "war" game.

War is a card game played between two players. Each player gets a variable number of cards of the beginning of the game: that's the player's deck. Cards are placed face down on top of each deck.
 
Step 1 : the fight
At each game round, in unison, each player reveals the top card of their deck – this is a "battle" – and the player with the higher card takes both the cards played and moves them to the bottom of their stack. The cards are ordered by value as follows, from weakest to strongest:
2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A.
 
Step 2 : war
If the two cards played are of equal value, then there is a "war". First, both players place the three next cards of their pile face down. Then they go back to step 1 to decide who is going to win the war (several "wars" can be chained). As soon as a player wins a "war", the winner adds all the cards from the "war" to their deck.
 
Special cases:
If a player runs out of cards during a "war" (when giving up the three cards or when doing the battle), then the game ends and both players are placed equally first.

Each card is represented by its value followed by its suit: D, H, C, S. For example: 4H, 8C, AS.

When a player wins a battle, they put back the cards at the bottom of their deck in a precise order. First the cards from the first player, then the one from the second player (for a "war", all the cards from the first player then all the cards from the second player).

[Link to challenge](https://www.codingame.com/ide/puzzle/winamax-battle)

---

## ruby

```ruby
decks = [[], []]

@n = gets.to_i # the number of cards for player 1
@n.times { decks[0] << gets.chomp } # player 1 cards

@m = gets.to_i # the number of cards for player 2
@m.times { decks[1] << gets.chomp } # player 2 cards

RANK = [*(2..10).map(&:to_s), 'J', 'Q', 'K', 'A']

# dispatch cards between players depending of the winner
def dispatch(decks, player, index)
  decks[player].push(*decks[0][0..index])
  decks[player].push(*decks[1][0..index])
  decks[0].slice!(0, index + 1)
  decks[1].slice!(0, index + 1)
end

round = 0 # number of round of the game
index = 0 # card to be play (battles increase index by 4)
pat = false # equality during a battle

# define the strength of a card
def card_strength(card)
  [*(2..10).map(&:to_s), 'J', 'Q', 'K', 'A'].find_index(card.chop)
end

# until players have cards and there is not equality after a battle
until decks[0].empty? || decks[1].empty? || pat
  # if cards are the same
  if decks[0][index].chop == decks[1][index].chop
    # increase the index by 4 because 3 cards are put aside
    decks[0].count > 4 && decks[1].count > 4 ? index += 4 : pat = true
    # skip following part and return loop
    next
  end
  # if player 1 card is stronger than player 2 card
  if card_strength(decks[0][index]) > card_strength(decks[1][index])
    dispatch(decks, 0, index)
  # if player 1 card is weaker than player 2 card
  else
    dispatch(decks, 1, index)
  end
  round += 1
  index = 0
end

result =
  if pat
    'PAT'
  else
    decks[0].empty? ? "2 #{round}" : "1 #{round}"
  end

puts result
```

## go

```go
package main

import "fmt"

// A card
type Card string

// Power represents the power of a card as integer
func (card Card) Power() int {
    order := [13]Card{"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
    value := card[:len(card)-1]
    for i, v := range order {
        if v == value {
            return i + 2
        }
    }

    return 0
}

// Beat returns true if card is higher than another
func (card Card) Beat(another Card) bool {
    return card.Power() > another.Power()
}

// A Deck containing cards
type Deck []Card

// Merge concatenate two decks into one
func (deck *Deck) Merge(another Deck) Deck {
    *deck = append(*deck, another...)
    return *deck
}

// Reset empties the deck
func (deck *Deck) Reset() Deck {
    *deck = Deck{}
    return *deck
}

// IsEmpty returns true if the deck has no cards
func (deck Deck) IsEmpty() bool {
    return len(deck) == 0
}

// First returns the dech first card
// ! Can panic
func (deck Deck) First() Card {
    if deck.IsEmpty() {
        panic("deck is empty")
    }

    return deck[0]
}

// Push add a card at the end of the deck
func (deck *Deck) Push(card Card) Deck {
    *deck = append(*deck, card)
    return *deck
}

// Shift removes and returns the first card
// ! Can panic
func (deck *Deck) Shift(x int) Deck {
  if len(*deck) < x {
    panic("not enough cards")
  }

  shift := Deck{}
  shift.Merge((*deck)[0:x])
  *deck = (*deck)[x:]
  return shift
}

func main() {
  // n: the number of cards for player 1
  var n int
  fmt.Scan(&n)
  deck1 := Deck{}
  for i := 0; i < n; i++ {
    // card: the n cards of player 1
    var card Card
    fmt.Scan(&card)
    deck1.Push(card)
  }

  // m: the number of cards for player 2
  var m int
  fmt.Scan(&m)
  deck2 := Deck{}
  for i := 0; i < m; i++ {
    // card: the m cards of player 2
    var card Card
    fmt.Scan(&card)
    deck2.Push(card)
  }

  count := 0
  result := ""

  pot1 := Deck{}
  pot2 := Deck{}

  for {
    if deck1.IsEmpty() { // player 2 wins
      result = fmt.Sprintf("%v %v", 2, count)
      break
    }

    if deck2.IsEmpty() { // player 1 wins
      result = fmt.Sprintf("%v %v", 1, count)
      break
    }

    // each player draw a card
    card1 := deck1.Shift(1)[0]
    card2 := deck2.Shift(1)[0]

    // cards put in player pots
    pot1.Push(card1)
    pot2.Push(card2)

    // cards comparison

    if card1.Beat(card2) { // player 1 card beats player 2 card
      deck1.Merge(pot1)
      deck1.Merge(pot2)
      pot1.Reset()
      pot2.Reset()
      count ++
    } else if card2.Beat(card1){ // player 1 card beats player 2 card
      deck2.Merge(pot1)
      deck2.Merge(pot2)
      pot1.Reset()
      pot2.Reset()
      count ++
    } else { // battle
      // one player has not enough cards to play
      if len(deck1) < 3 || len(deck2) < 3 {
          result = "PAT"
          break
      }
      // for each player, drop 3 cards and add them to pots
      pot1.Merge(deck1.Shift(3))
      pot2.Merge(deck2.Shift(3))
    }
  }

  fmt.Println(result)// Write answer to stdout
}
```
