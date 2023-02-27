module V1
  class PackageIndexer
    def initialize(); end

    def run
      packages = fetch_packages
      packages.each do |pkg|
        url = format(ENV['PACKAGE_URL_TEMPLATE'], pkg[:package], pkg[:version])
        dependencies = pkg[:depends]&.split(',')&.map(&:strip) || []

        Package.create(name: pkg[:package], version: pkg[:version],
                       r_version: pkg[:suggests]&.match(/R \(>= (\d+\.\d+)\)/)&.captures&.first,
                       dependencies:, date: pkg[:date_publication],
                       title: pkg[:title], authors: pkg[:author], maintainers: pkg[:maintainer],
                       license: pkg[:license], url:)
      end
    rescue StandardError => e
      Rails.logger.error "Error in parsing CRAN package #{e.message}"
      false
    end

    private

    def fetch_packages
      gz_data = URI.open(ENV['PACKAGES_URL']).read
      data = Zlib::GzipReader.new(StringIO.new(gz_data)).read
      data.split("\n\n").map { |pkg| parse_package(pkg) }
    end

    def parse_package(pkg)
      pkg_hash = {}
      pkg.split("\n").each do |line|
        key, value = line.split(': ', 2)
        pkg_hash[key.downcase.to_sym] = value.strip if key && value
      end
      pkg_hash
    end
  end
end
