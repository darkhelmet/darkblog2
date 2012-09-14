if host = ENV.fetch("CANONICAL_HOST", false)
  Darkblog2::Application.config.middleware.insert_after(ActionDispatch::Static, Rack::CanonicalHost, host)
end
