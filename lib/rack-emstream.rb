require 'eventmachine'

module Rack
  class EMStream
    include EventMachine::Deferrable

    def initialize(app, &block)
      @app, @block = app, block
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

      if env['async.callback']
        EM.next_tick {
          env['async.callback'].call [ result[0], result[1], self ]

          begin
            result[2].each { |data|
              EM.next_tick {
                begin
                  @callback.call(data)
                rescue => e
                  @callback.call(@block.call(e, env)) if @block
                end
              }
            }
          rescue => e
            @callback.call(@block.call(e, env)) if @block
          end

          EM.next_tick { succeed }
        }

        throw :async
      else
        result
      end
    end
  end
end

