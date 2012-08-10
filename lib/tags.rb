module Tags
  extend ActiveSupport::Concern

  def tags
    Array(read_attribute(:tags))
  end

  def tags=(t)
    write_attribute(:tags, t.uniq)
  end

  def tag_string=(tags)
    self.tags = tags.split(',').map(&:strip).reject(&:empty?).map(&:parameterize)
  end

  def tag_string
    Array(tags).join(', ')
  end

  module ClassMethods
    def tags
      connection.select_values(select('DISTINCT(UNNEST(tags)) AS tag').order(:tag).to_sql)
    end
  end
end
