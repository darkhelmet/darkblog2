namespace :compress do
  script_names = %w(jquery rails jquery.darkblog facebox jquery.embedly jquery.boastful darkblog CFInstall)
  out = "public/javascripts/all.js"

  yui = `which yuicompressor`.strip
  yui = `which yui-compressor`.strip if yui.blank?

  unless yui.blank?
    desc 'Compress Javascript with the YUI Compressor'
    task :yui do
      scripts = script_names.map { |file| "public/javascripts/#{file}.js" }.join(' ')
      system("cat #{scripts} | #{yui} --type js -o #{out}")
    end
  end

  closure = `which closure`.strip

  unless closure.blank?
    desc 'Compress Javascript with the Google Closure Compiler'
    task :closure do
      scripts = script_names.map { |file| "--js public/javascripts/#{file}.js" }.join(' ')
      system("#{closure} #{scripts} --compilation_level SIMPLE_OPTIMIZATIONS --js_output_file #{out}")
    end
  end
end
