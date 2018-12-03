

## War

> [Link to challenge](https://www.codingame.com/ide/puzzle/winamax-battle)

---

**Rules**

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

---

**Code**

```ruby
decks = [] # decks of players

decks[0] = [] # deck for player 1
@n = gets.to_i # the number of cards for player 1
@n.times do
  decks[0] << gets.chomp # the n cards of player 1
end

decks[1] = [] # deck for player 2
@m = gets.to_i # the number of cards for player 2
@m.times do
  decks[1] << gets.chomp # the m cards of player 2
end

# dispatch cards between players, depending of the winner
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
    # skip following part and rerun loop
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

result = if pat
           'PAT'
         else
           decks[0].empty? ? "2 #{round}" : "1 #{round}"
         end

puts result
```
