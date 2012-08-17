module Renderer
  module Images
    ImageRegex = /\{\{\s*(\w+)\.(\w+)\s*\}\}/
    SizeRegex = /transloadit\/(?<size>:small|medium|large|original)/

    def parse_images(text)
      text.gsub!(ImageRegex) do |match|
        image_hash.fetch($1, {}).fetch($2, nil)
      end
    end
  end
end
