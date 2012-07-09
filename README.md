# Super-simple Rack streaming with Thin and other EventMachine-based servers

This is the absolute simplest way to turn any Rack app into a streaming- and deferrable-capable service using Thin.
It handles the necessary async calls to make Thin start streaming, then delivers your
response body on each next tick until sent. If you're sending something big, make sure it responds to `each`
in chunks:

``` ruby
class FileStreamer
  def initialize(file)
    @file = file
  end

  def each
    while !@file.eof?
      yield @file.read(8192)
    end
  end
end

# then respond with a FileStreamer

def call(env)
  # ... do stuff ...

  [ 200, {}, FileStreamer.new(File.open('big-file.mpg')) ]
end
```

Nothing to configure, just drop it in to your Rack middleware stack and
use Thin as your server:

``` ruby
# for Rails:

config.middleware.insert_before(::Rack::Lock, ::Rack::EMStream)

# for Rack::Builder and derivatives:

use Rack::EMStream
```

