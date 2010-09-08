File.expand_path('~/.s3/auth.yml').tap do |path|
  if File.exists?(path)
    YAML.load_file(path).each do |k,v|
      ENV[k.to_s.upcase] = v
    end
  end
end

CarrierWave.configure do |config|
  config.s3_access_key_id = ENV['ACCESS_KEY_ID']
  config.s3_secret_access_key = ENV['SECRET_ACCESS_KEY']
  config.s3_bucket = 'static.verboselogging.com'
  config.s3_cnamed = true
end