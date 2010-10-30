begin
  require 'aws'
  require 'find'
  require 'mime/types'

  desc 'Upload images and swf to S3'
  task :upload_assets => :environment do
    Aws::S3.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']).tap do |s3|
      s3.bucket('static.verboselogging.com').tap do |bucket|
        public_dir = Rails.root.join('public').to_s
        Find.find(public_dir) do |path|
          if path.match(/\.(swf|png|gif|jpg|xap)$/)
            key = path.gsub("#{public_dir}/", '')
            print "Uploading #{path}..."
            mime = MIME::Types.type_for(path).first.to_s.tap do |m|
              m << 'application/octet-stream' if m.blank?
            end
            bucket.put(key, File.read(path), {}, 'public-read', {
              'Cache-control' => "public, must-revalidate, max-age=#{6.months}",
              'Content-Type' => mime
            })
            print "done\n"
          end
        end
      end
    end
  end
rescue LoadError
  print "You need the aws/s3 gem to upload assets\n"
end