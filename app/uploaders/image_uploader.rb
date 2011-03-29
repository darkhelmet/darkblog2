class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  if Rails.env.development?
    storage :file
  else
    storage :s3
    def url(*args)
      URI(super(*args)).tap do |u|
        u.host = ENV['ASSET_HOST']
      end.to_s
    end
  end

  def cache_dir
    Rails.root.join('tmp', 'carrierwave')
  end

  def s3_headers
    {
      'Cache-Control' => 'public, must-revalidate, max-age=15552000',
      # Bit of a hack to ensure content type gets set
      'Content-Type' => MIME::Types.type_for(model.image_filename).first.to_s
    }
  end

  def store_dir
    "uploads/#{model.post.slug}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :small do
    # Thumbnail, basically
    process resize_to_fit: [100, 100]
  end

  version :medium do
    # Half size
    process resize_to_fit: [320, 320]
  end

  version :large do
    # Full width
    process resize_to_fit: [640, 10_000] # Max 640 pixels wide
  end
end