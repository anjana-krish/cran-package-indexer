require 'rails_helper'
include Helpers::PackageHelpers

RSpec.describe ::Package do
  describe '.create' do
    context 'redis is not available' do
      before do
        allow(CacheRedis).to receive(:pool) { raise Redis::TimeoutError }
      end

      it 'returns false' do
        status = Package.create(name: 'CommonJavaJars', version: '1.0.0', r_version: '1.0', dependencies: ['R (>= 2.8.0)'], date: '12-12-2022',
                                authors: ['david'], maintainers: ['John'], license: 'GPL-2', title: 'Java Jars',
                                url: 'http://cran.r-project.org/src/contrib/CommonJavaJars_1.0-6.tar.gz')
        expect(status).to eq false
      end
    end

    context 'when all good' do
      it 'should create the package in redis' do
        Package.create(name: 'CommonJavaJars', version: '1.0.0', r_version: '1.0', dependencies: ['R (>= 2.8.0)'], date: '12-12-2022',
                       authors: ['david'], maintainers: ['John'], license: 'GPL-2', title: 'Java Jars',
                       url: 'http://cran.r-project.org/src/contrib/CommonJavaJars_1.0-6.tar.gz')
        package = ::CacheRedis.pool.with { |redis| redis.get('packages:CommonJavaJars-1.0.0') }

        expect(package).not_to be_empty
      end
    end
  end
end
