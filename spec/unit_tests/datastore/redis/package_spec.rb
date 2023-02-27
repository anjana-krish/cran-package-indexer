require 'rails_helper'

describe ::Datastore::Redis::Package::Create do
  describe '.call' do
    context 'when redis is not available' do
      it 'returns false and logs error' do
        allow(::CacheRedis).to receive(:pool) { raise Redis::TimeoutError }

        expect(Rails.logger).to receive(:error)

        status = described_class.call(name: 'CommonJavaJars', version: '1.0.0', r_version: '1.0', dependencies: ['R (>= 2.8.0)'], date: '12-12-2022',
                                      authors: ['david'], maintainers: ['John'], license: 'GPL-2', title: 'Java Jars',
                                      url: 'http://cran.r-project.org/src/contrib/CommonJavaJars_1.0-6.tar.gz')

        expect(status).to eq false
      end
    end

    context 'when all good' do
      it 'should return true' do
        status = described_class.call(name: 'CommonJavaJars', version: '1.0.0', r_version: '1.0', dependencies: ['R (>= 2.8.0)'], date: '12-12-2022',
                                      authors: ['david'], maintainers: ['John'], license: 'GPL-2', title: 'Java Jars',
                                      url: 'http://cran.r-project.org/src/contrib/CommonJavaJars_1.0-6.tar.gz')

        expect(status).to eq true

        packages = ::CacheRedis.pool.with { |redis| redis.keys('*') }
        expect(packages.count).to eq 1
      end
    end
  end
end
