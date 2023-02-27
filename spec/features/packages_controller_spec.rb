# frozen_string_literal: true

require 'rails_helper'
include Helpers::PackageHelpers

RSpec.describe 'Packages Controller ', type: :request do
	context 'Index - List down all the packages' do
    before do
      create_package(name: 'CommonJavaJars', version: "1.0.0", r_version: "1.0", dependencies: ["R (>= 2.8.0)"], date: "12-12-2022",
        authors: ['david'], maintainers: ['John'], license: "GPL-2",
        url: "http://cran.r-project.org/src/contrib/CommonJavaJars_1.0-6.tar.gz")

      get '/api/v1/packages',
        headers: {
          'ContentType' => 'application/json'
        }
    end

    it 'should return success' do
      expect(response).to have_http_status(200)
    end

    it 'should return packages' do
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq 1
      expect(json_response[0]).to eq "packages:CommonJavaJars-1.0.0"
    end
  end

  context 'Create - parse CRAN server and create package in redis' do
    before do
      post '/api/v1/packages',
        headers: {
          'ContentType' => 'application/json'
        }
    end

    it 'should return success' do
      expect(response).to have_http_status(200)
    end

    it 'should return success message' do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Package created successfully"
    end

    it 'should have packages in redis' do
      response = ::CacheRedis.pool.with { |redis| redis.keys('*') }
      expect(response.count).to be > 0
    end
  end

  context 'when CRAN url is not avaialable' do
    before do
      ENV['PACKAGES_URL'] = nil
      post '/api/v1/packages',
        headers: {
          'ContentType' => 'application/json'
        }
    end

    it 'should return error' do
      expect(response).to have_http_status(500)
    end
  end
end
