module Tags
  extend ActiveSupport::Concern

  included do
    extend pg_supports_unnest? ? Unnest : Pure
  end

  module ClassMethods
    def pg_supports_unnest?
      ActiveRecord::Base.connection.send(:postgresql_version) >= 80400
    end
  end

  module Unnest
    def tags
      connection.select_values(select('DISTINCT(UNNEST(tags)) AS tag').order(:tag).to_sql)
    end
  end

  module Pure
    def tags
      all.reduce(Set.new) do |set, post|
        set.merge(post.tags)
      end.sort
    end
  end
end
