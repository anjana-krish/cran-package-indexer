class Package
  attr_accessor :name, :version, :r_version, :dependencies,
                :date, :title, :authors, :maintainers, :license, :url

  def initialize(name: , version:, r_version: nil, dependencies: nil, date: nil,
    title: nil, authors: nil, maintainers: nil, license: nil, url:)
    @name = name
    @version = version
    @r_version = r_version
    @dependencies = dependencies
    @date = date
    @title = title
    @authors = authors
    @maintainers = maintainers
    @license = license
    @url = url
  end

  def self.create(name:, version:, r_version: nil, dependencies: nil, date: nil,
    title: nil, authors: nil, maintainers: nil, license: nil, url:)
    
    status = Datastore::Redis::Package::Create.call(name: name, version: version,
      r_version: r_version, dependencies: dependencies, date: date, title: title,
      authors: authors, maintainers: maintainers, license: license, url: url)

    return false if status == false

    Package.new(name: name, version: version,
      r_version: r_version, dependencies: dependencies, date: date, title: title,
      authors: authors, maintainers: maintainers, license: license, url: url)
  end
end
