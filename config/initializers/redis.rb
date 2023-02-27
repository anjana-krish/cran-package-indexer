

# Cache Redis configuration
# -> Contains data which can be evicted

cache_redis_pool_size = (ENV['CACHE_REDIS_POOL_SIZE'] || 15).to_i

$CACHE_REDIS =
  if ENV['RAILS_ENV'] == 'test'
    ConnectionPool.new(size: cache_redis_pool_size, timeout: 5) do
      # Selecting a different database (2) for testing, so that the actual database is not affected
      Redis.new(url: ENV['CACHE_REDIS_URL'], db: 1, timeout: 5, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
    end
  else
    ConnectionPool.new(size: cache_redis_pool_size, timeout: 5) do
      Redis.new(url: ENV['CACHE_REDIS_URL'], timeout: 5, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
    end
  end
class CacheRedis
  def self.pool
    @generic_redis ||= $CACHE_REDIS
  end
end
