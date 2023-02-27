module Datastore
  module Redis
    module Package
      # Creates a cran package in Redis
      class Create
        def initialize; end

        def self.call(name:, version:, r_version:, dependencies:, date:,
                      title:, authors:, maintainers:, license:, url:)
          begin
            ::CacheRedis.pool.with do |redis_conn|
              redis_conn.multi do
                redis_conn.set(
                  "packages:#{name}-#{version}",
                  {
                    name:,
                    version:,
                    r_version:,
                    dependencies:,
                    date:,
                    title:,
                    authors:,
                    maintainers:,
                    license:,
                    url:
                  }.to_json
                )
              end
            end
          rescue StandardError => e
            Rails.logger.error "Redis Error - #{e}"
            return false
          end

          true
        end
      end
    end
  end
end
