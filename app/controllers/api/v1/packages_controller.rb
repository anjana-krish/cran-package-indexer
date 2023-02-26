module Api
  module V1
    class PackagesController < BaseController
      def index
        packages = ::CacheRedis.pool.with { |redis| redis.keys('*') }
        render json: packages
      end

      # parse cran file and store information in redis
      def create
        package_indexer = ::V1::PackageIndexer.new
        if package_indexer.run
          render json: { message: 'Package created successfully' },
                 status: :ok
        else
          render json: { message: 'Error in creating packages' },
                 status: 500
        end
      end
    end
  end
end
