# Simple::Queue

`Simple::Queue` is a Ruby library that provides a non-blocking queue similar to
the `Queue` library provided in Ruby's standard library. The difference is that
this queue does not require jumping through hoops for non-blocking behavior.

An example:

```ruby
require 'queue'

# Ruby `Queue` blocking example:
queue = Queue.new
queue << 'foo'
queue << 'bar'
queue.pop #=> 'foo'
queue.pop #=> 'bar'
queue.pop # Blocks until an item is pushed onto the queue from another thread.

# Ruby `Queue` non-blocking example:
queue = Queue.new
queue << 'foo'
queue << 'bar'
queue.pop(true) #=> 'foo'
queue.pop(true) #=> 'bar'
queue.pop(true) # Raises a `ThreadError`.

# Alternative approach:
queue = Queue.new
queue << 'foo'
queue << 'bar'
queue.pop(true) rescue nil #=> 'foo'
queue.pop(true) rescue nil #=> 'bar'
queue.pop(true) rescue nil #=> nil
queue.pop(true) rescue nil #=> nil
```

Whereas with `Simple::Queue`:

```ruby
require 'simple/queue'

queue = Simple::Queue.new
queue << 'foo'
queue << 'bar'
queue.pop #=> 'foo'
queue.pop #=> 'bar'
queue.pop #=> nil
queue.pop #=> nil
```

In every other way, `Simple::Queue` acts like the Ruby queue, with the caveat
that it will be minutely slower in the best case (since it is pure Ruby and not
C), and faster in the worst case (since there is no rescuing of exceptions,
which is slow in Ruby).

It is thread-safe, since all operations are wrapped in a Mutex. But since it
does not block, there should be no opportunity for race conditions (every
operation performs exactly one thing and returns).

It follows the API of `Queue` exactly:

```ruby
# Create a new simple-queue.
Queue#initialize

# Clear all items out of the queue.
Queue#clear

# Returns `true` if there is nothing in the queue, and `false` otherwise.
Queue#empty?

# Returns how many items are in the queue.
Queue#length
Queue#size

# Puts an item in the queue.
Queue#push(obj)
Queue#<<(obj)
Queue#enq(obj)

# Removes an item from the queue, or returns `nil` if there are none. This
# method takes an optional argument, which is discarded. This is for
# compatibility with Ruby's `Queue` implementation.
#
Queue#pop
Queue#deq
Queue#shift

# Always returns `0`, since there is no opportunity to wait.
Queue#num_waiting
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple-queue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple-queue

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## TODO

* Document code with RDoc.
* More exhaustively test threading in test suite.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rjungemann/simple-queue.

