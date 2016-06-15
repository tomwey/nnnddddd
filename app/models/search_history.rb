class SearchHistory < ActiveRecord::Base
  belongs_to :search
  belongs_to :searchable, polymorphic: true
  
  def add_search_count
    self.class.increment_counter(:search_count, self.id)
  end
end
