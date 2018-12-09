class Circle
  class Node
    def initialize(value)
      @value = value
    end

    attr_accessor :prev, :next, :value
  end

  attr_reader :current

  def push(value)
    node = Node.new(value)

    unless current
      node.next = node
      node.prev = node
      @current = node
      return self
    end

    node.prev = @current
    node.next = @current.next
    @current.next.prev = node
    @current.next = node

    self
  end

  def pop
    return unless current

    popped = current.value
    current.prev.next = current.next
    current.next.prev = current.prev
    @current = current.prev

    popped
  end

  def rotate(n)
    meth = n < 0 ? :rotate_left : :rotate_right
    n.abs.times { public_send(meth) }

    self
  end

  def rotate_left
    @current = current.prev
    self
  end

  def rotate_right
    @current = current.next
    self
  end

  def to_list
    return [] unless current

    list = [current.value]

    node = current.next
    while node != current do
      list << node.value
      node = node.next
    end

    list
  end

  def inspect
    "Circle" + to_list.inspect
  end
end

def play(number_of_players, marbles)
  circle = Circle.new.push(0)
  scores = Hash.new(0)

  (1..marbles).each do |marble|
    if marble % 23 == 0
      value = circle.rotate(-7).pop()
      circle.rotate(1)
      scores[marble % number_of_players] += marble + value
    else
      circle.rotate(1).push(marble).rotate(1)
    end
    p circle if ENV['DEBUG']
  end

  p scores.values.max
rescue => e
  puts e.inspect
  puts *e.backtrace
  raise
end

number_of_players, marbles = ARGV
play(number_of_players.to_i, marbles.to_i)