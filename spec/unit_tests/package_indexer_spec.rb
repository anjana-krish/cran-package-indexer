require 'rails_helper'

describe ::V1::PackageIndexer do
  describe '.run' do
    context 'package url is not present' do
      before do
        ENV['PACKAGES_URL'] = nil
      end

      it 'should return false' do
        expect(Rails.logger).to receive(:error).with(/Error in parsing CRAN package/)
        response = described_class.new.run
        expect(response).to eq false
      end
    end

    context 'when all good' do
      before do
        ENV['PACKAGES_URL'] = 'http://cran.r-project.org/src/contrib/PACKAGES.gz'
      end

      it 'should return true' do
        response = described_class.new.run
        expect(response).to eq true
      end

      it 'should parse the package and save it in redis' do
        described_class.new.run
        packages = ::CacheRedis.pool.with { |redis| redis.keys('*') }
        expect(packages.count).to be > 0
      end
    end
  end
end
