if Rails.env.production?
  Rails.application.middleware.use Hassle
end