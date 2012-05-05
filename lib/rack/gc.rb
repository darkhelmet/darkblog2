module Rack
  class GC
    def initialize(app)
      @app = app
    end

    def call(env)
      ::GC.disable
      @app.call(env)
    ensure
      ::GC.enable
      ::GC.start
    end
  end
end
