module Api
  class BaseController < ActionController::API
    rescue_from Redis::TimeoutError, with: :render_redis_timeout_error
  end
end
