namespace :packages do
  desc 'Update all packages from CRAN server in every day'
  task update: :environment do
    ::V1::PackageIndexer.new().run
  end
end