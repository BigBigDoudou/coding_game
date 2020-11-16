# Coders Strike Back

Build a smart bot to fight your opponents!

[Link to challenge](https://www.codingame.com/multiplayer/bot-programming/coders-strike-back)

---

## ruby

```ruby
STDOUT.sync = true

module Trigo
  class << self
    # Returns the result of the sigmoid ([0, 1])
    # @param x [Float] increases the result (increase x -> closer to 1)
    # @param y [Float] moderate the slope strength (increase y -> stronger slope)
    # @param z [Float] move increase forward (increase z -> increase gap before slope start)
    # https://en.wikipedia.org/wiki/Sigmoid_function
    def sigmoid(x, y, z)
      1.0 / (1.0 + z * Math.exp(-x * y))
    end

    # Returns the distance between two coordinates
    # @param ax [Float] x of point a
    # @param ay [Float] y of point a
    # @param bx [Float] x of point b
    # @param by [Float] y of point b
    def distance(ax, ay, bx, by)
      Math.sqrt(
        (ax - bx)**2 + (ay - by)**2
      )
    end

    # Returns an angle from 3 line lentghs
    # @param a [Float] length of line a
    # @param b [Float] length of line b
    # @param c [Float] length of line c
    # @return [Float] angle of C (corner between a and b)
    # https://en.wikipedia.org/wiki/Law_of_cosines#Applications
    def angle_from_sides(a, b, c)
      return if [a, b, c].include? 0.0

      Math.acos(
        (a**2 + b**2 - c**2) / (2 * a * b)
      ) * 180.0 / Math::PI
    end
  end
end

class Checkpoint
  @checkpoints = []
  @complete = nil # has the track been completed once?
  @target = nil # target targeted checkpoint

  class << self
    attr_reader :target
    attr_accessor :checkpoints, :complete

    # Sets target to the checkpoint and eventually updates @@complete
    # @param checkpoint [Checkpoint]
    def target=(checkpoint)
      # if target checkpoint order is greater than current
      # it means that the vessel has passed all the checkpoints
      complete = true if target && target.order > checkpoint.order
      @target = checkpoint
    end

    # Returns the checkpoint that is the farest from its previous
    def farest
      @@farest ||=
        complete &&
        checkpoints.max_by{ |checkpoint| checkpoint.distance_from_previous }
    end

    # Finds or creates a checkpoint from coordinates
    # @param x [Float] x coordinate
    # @param y [Float] y coordinate
    def find_or_create(x, y)
      find(x, y) || new(x, y)
    end

    # Finds a checkpoint from coordinates
    # @param x [Float] x coordinate
    # @param y [Float] y coordinate
    def find(x, y)
      checkpoints.find do |checkpoint|
        checkpoint.x == x && checkpoint.y == y
      end
    end
  end

  attr_reader :order, :x, :y

  # Initializes a checkpoint at coordinates
  # @param x [Float] x coordinate
  # @param y [Float] y coordinate
  def initialize(x, y)
    @x, @y = x, y
    @order = Checkpoint.checkpoints.length
    Checkpoint.checkpoints.push(self)
  end

  def name
    order + 1
  end

  # Returns previous checkpoint
  def previous
    @previous ||=
      (order.positive? || Checkpoint.complete) &&
      Checkpoint.checkpoints[order - 1]
  end

  # Returns following checkpoint
  def following
    @following ||=
      Checkpoint.complete &&
      (self == Checkpoint.checkpoints.last ? Checkpoint.checkpoints.first : Checkpoint.checkpoints[order + 1])
  end

  # Returns distance between checkpoint and its previous
  def distance_from_previous
    @distance_from_previous ||=
      previous &&
      Trigo.distance(x, y, previous.x, previous.y)
  end

  # Returns distance between checkpoint and its following
  def distance_to_following
    @distance_to_following ||=
      following &&
      Trigo.distance(x, y, following.x, following.y)
  end

  # Returns length of the hypotenuse
  def hypotenuse_length
    @hypotenuse_length ||=
      previous && following &&
      Trigo.distance(previous.x, previous.y, following.x, following.y)
  end

  # Returns angle formed by self, previous and following checkpoints
  def angle
    @angle ||=
      hypotenuse_length &&
      Trigo.angle_from_sides(
        distance_from_previous,
        distance_to_following,
        hypotenuse_length
      )
  end

  # Returns true if the distance between self and its previous
  #   is the highest of all checkpoints
  def farest?
    @farest ||= self == Checkpoint.farest
  end
end

class Setting
  @current_power = 100
  @boost = true

  class << self
    attr_accessor :boost, :current_power
  end

  MIN_POWER        = 25      # vessel won't go slower
  ANGLE_SLOPE      = 0.005   # speed reduction when vessel is not facing the checkpoint (increase value -> decrease reduction)
  DISTANCE_SLOPE   = 0.001  # speed reduction when approaching checkpoint (increase value -> decrease reduction)
  ANGLE_TRIGGER    = 5       # value above which speed reduction relative to angle is not applied
  DISTANCE_TRIGGER = 2_500   # value below which speed reduction relative to distance is not applied

  # @angle [Float] angle between the vessel and the checkpoint
  # @distance [Float] distance between the vessel and the checkpoint
  # @checkpoint [Checkpoint] targeted checkpoint
  attr_accessor :angle, :distance, :checkpoint, :opponent

  # Returns the best value to output for power
  def power
    Setting.current_power = boost? ? boost! : [thrust, MIN_POWER].max
  end

  def boost!
    Setting.boost = false
    'BOOST'
  end

  # Returns true if boost should be use
  #   -> if the distance to the targeted checkpoint is the highest in the track
  def boost?
    Setting.boost && angle.abs < 1 && thrust > 98 && (
      distance > 5_000 || checkpoint.farest? || checkpoint.angle&.<(10)
    )
  end

  # Returns the best possible thrust based on known data
  def thrust
    return 100 if strike?

    (100.0 * angle_ratio * distance_ratio).round
  end

  # Returns the ratio to apply to truth to adapt it to @angle
  # @return [float] between 0.0 and 1.0
  def angle_ratio
    return 1.0 if angle.abs < ANGLE_TRIGGER

    x = angle.abs
    y = -ANGLE_SLOPE
    z = Setting.current_power / 100
    Trigo.sigmoid(x, y, z)
  end

  # Returns the ratio to apply to truth to adapt it to @distance
  # @return [float] between 0.5 and 1.0
  def distance_ratio
    return 1.0 if distance > DISTANCE_TRIGGER
    # if angle to next checkpoint is known and is small
    return 1.0 if checkpoint.angle&.abs&.>(180 - ANGLE_TRIGGER)

    x = distance
    y = DISTANCE_SLOPE
    z = 180 / Math.exp((checkpoint.angle || 90.0) * 0.05) * Math.log(Setting.current_power / 100 + 1)
    Trigo.sigmoid(x, y, z)
  end

  def strike?
    angle.abs < 5 &&
      distance.between?(2_000, 4_000) &&
      estimated_distance_from_opponent.between?(0, 1_500)
  end

  def estimated_distance_from_opponent
    opponent && (distance - distance_opponent_checkpoint)
  end

  def distance_opponent_checkpoint
    opponent && Trigo.distance(opponent.x, opponent.y, checkpoint.x, checkpoint.y)
  end
end

class Monitor
  # @checkpoint [Checkpoint] target checkpoint
  # @setting [Setting] current setting
  attr_accessor :checkpoint, :setting

  def print
    print_checkpoints
    print_checkpoint
    print_setting
  end

  def print_checkpoints
    STDERR.puts '- CHECKPOINTS -'
    STDERR.puts Checkpoint.checkpoints.map(&:name).join(', ')
    STDERR.puts "farest checkpoint: #{Checkpoint.farest&.name || '?'}"
  end

  def print_checkpoint
    STDERR.puts '- CHECKPOINT -'
    STDERR.puts "name: #{checkpoint.name}, order: #{checkpoint.order}, x: #{checkpoint.x}, y: #{checkpoint.y}"
    STDERR.puts "previous: #{checkpoint.previous&.name || '?'}, following: #{checkpoint.following&.name || '?'}"
    STDERR.puts "distance from previous: #{checkpoint.distance_from_previous || '?'}"
    STDERR.puts "angle: #{checkpoint.angle || '?'}"
    STDERR.puts "farest?: #{checkpoint.farest?}"
  end

  def print_setting
    STDERR.puts '- SETTING -'
    STDERR.puts "last power: #{Setting.current_power}"
    STDERR.puts "angle: #{setting.angle}, distance: #{setting.distance}"
    STDERR.puts "angle ratio: #{setting.angle_ratio.round(4)}, distance ratio: #{setting.distance_ratio.round(4)}"
    STDERR.puts "strike? #{setting.strike?}"
  end
end

setting = Setting.new
setting.opponent = opponent
monitor = Monitor.new
monitor.setting = setting

# game loop
loop do
  # next_checkpoint_x: x position of the next check point
  # next_checkpoint_y: y position of the next check point
  # next_checkpoint_dist: distance to the next checkpoint
  # next_checkpoint_angle: angle between your pod orientation and the direction of the next checkpoint
  x, y, next_checkpoint_x, next_checkpoint_y, next_checkpoint_dist, next_checkpoint_angle = gets.split(' ').map(&:to_i)
  opponent_x, opponent_y = gets.split(' ').map(&:to_i)

  opponent.x = opponent_x
  opponent.y = opponent_y

  checkpoint = Checkpoint.find_or_create(next_checkpoint_x, next_checkpoint_y)
  Checkpoint.target = checkpoint

  setting.angle = next_checkpoint_angle
  setting.distance = next_checkpoint_dist
  setting.checkpoint = checkpoint

  monitor.checkpoint = checkpoint
  monitor.print

  printf("#{next_checkpoint_x} #{next_checkpoint_y} #{setting.power}\n")
end
```