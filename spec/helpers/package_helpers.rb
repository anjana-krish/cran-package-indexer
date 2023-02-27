module Helpers
  module PackageHelpers
    def create_package(name: , version:, r_version: nil, dependencies: nil, date: nil, title: nil, authors: nil, maintainers: nil, license: nil, url:)
      Package.create(name: name, version: version, r_version: r_version, dependencies: dependencies, date: date,
        title: title, authors: authors, maintainers: maintainers, license: license, url: url)
    end
  end
end
