Rails.root.join('config', 'pusher.yml').tap do |path|
  if File.exists?(path)
    YAML.load_file(path).each do |k,v|
      ENV[k.to_s.upcase] = v
    end
  end
end

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.logger = Rails.logger