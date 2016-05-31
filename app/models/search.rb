class Search < ActiveRecord::Base
  include PgSearch
  pg_search_scope :kw_search, against: :keyword,:using => {
                    :tsearch => {:dictionary => "simple"}
                  }
  
  def add_search_count
    self.class.increment_counter(:search_count, self.id)
  end
end
