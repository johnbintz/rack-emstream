require 'eventmachine'

module Rack
  class EMStream
    include EventMachine::Deferrable

    def initialize(app)
      @app = app
    end

    def each(&b)
      @callback = b
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      result = @app.call(env)

      result[2].close if result[2].respond_to?(:close)

      EM.next_tick {
        env['async.callback'].call [ result[0], result[1], self ]

        result[2].each { |data| EM.next_tick { @callback.call(data) } }
        EM.next_tick { succeed }
      }

      throw :async
    end
  end
end

