class AssetHost
  DefaultImageHost = 'http://cdn.verboselogging.com'
  DefaultLocalHost = nil

  attr_accessor :images, :local

  def initialize(local = DefaultLocalHost, images = DefaultImageHost)
    @images = images
    @local = local
  end

  def call(source)
    return images if source.starts_with?('/transloadit')
    local
  end
end
