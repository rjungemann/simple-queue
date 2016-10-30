require 'spec_helper'
require 'timeout'

describe Simple::Queue do
  around(:each) do |example|
    Timeout::timeout(0.5) do
      example.run
    end
  end

  it 'has a version number' do
    expect(Simple::Queue::VERSION).not_to be nil
  end

  describe '#clear' do
    it 'clears the queue' do
      queue = Simple::Queue.new
      queue << 'foo'
      expect(queue.length).to eq(1)
      queue << 'foo'
      expect(queue.length).to eq(2)
      queue.clear
      expect(queue.length).to eq(0)
      result = queue.pop
      expect(result).to eq(nil)
    end
  end

  describe '#empty?' do
    it 'returns whether the queue is empty' do
      queue = Simple::Queue.new
      expect(queue.empty?).to eq(true)
      queue << 'foo'
      expect(queue.empty?).to eq(false)
      queue << 'bar'
      expect(queue.empty?).to eq(false)
      queue.pop
      expect(queue.empty?).to eq(false)
      queue.clear
      expect(queue.empty?).to eq(true)
    end
  end

  [:length, :size].each do |name|
    describe "##{name}" do
      it 'returns how many items are in the queue' do
        queue = Simple::Queue.new
        expect(queue.send(name)).to eq(0)
        queue << 'foo'
        expect(queue.send(name)).to eq(1)
        queue << 'bar'
        expect(queue.send(name)).to eq(2)
      end
    end
  end

  [:push, :<<, :enq].each do |name|
    describe "##{name}" do
      it 'puts an item onto the queue' do
        queue = Simple::Queue.new
        expect(queue.length).to eq(0)
        queue.send(name, 'foo')
        expect(queue.length).to eq(1)
        queue.send(name, 'bar')
        expect(queue.length).to eq(2)
      end
    end
  end

  [:pop, :deq, :shift].each do |name|
    describe "##{name}" do
      it 'pulls an item off the queue' do
        queue = Simple::Queue.new
        queue << 'foo'
        queue << 'bar'
        result = queue.pop
        expect(result).to eq('foo')
        expect(queue.length).to eq(1)
        result = queue.pop
        expect(result).to eq('bar')
        expect(queue.length).to eq(0)
        result = queue.pop
        expect(result).to eq(nil)
        expect(queue.length).to eq(0)
      end
    end
  end
end
