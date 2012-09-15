$: << File.expand_path('../lib', __FILE__)
require 'rack-emstream'

class Sender
  def initialize
    @times = 100
    @data = "data"
  end

  def each
    @times.times { |i|
      yield @data
    }
  end

  def length
    @times * @data.length
  end
end

require 'logger'

use Rack::EMStream
run lambda { |env|
  sender = Sender.new

  [ 200, { 'Content-Length' => sender.length.to_s }, sender ]
}
