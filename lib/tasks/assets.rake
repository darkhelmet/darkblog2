begin
  require 'aws/s3'
  require 'find'
  require 'mime/types'
  BUCKET = 'static.verboselogging.com'

  desc 'Upload images and swf to S3'
  task :upload_assets => :environment do
    path = File.expand_path(File.join('~', '.s3', 'auth.yml'))
    if File.exists?(path)
      AWS::S3::Base.establish_connection!(YAML.load_file(path))
      public_dir = Rails.root.join('public').to_s
      Find.find(public_dir) do |path|
        if path.match(/\.(swf|png|gif|jpg|xap)$/)
          key = path.gsub("#{public_dir}/", '')
          print "Uploading #{path}..."
          File.open(path, 'rb') do |f|
            AWS::S3::S3Object.store(key, f, BUCKET,
                                    :content_type => MIME::Types.type_for(path).first.to_s,
                                    :access => :public_read,
                                    'Cache-control' => "public, must-revalidate, max-age=#{6.months}")
          end
          print "done\n"
        end
      end
    else
      print "No S3 auth file!\n"
    end
  end
rescue LoadError
  print "You need the aws/s3 gem to upload assets\n"
end