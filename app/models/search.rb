class Search < ActiveRecord::Base
  # include PgSearch
  # pg_search_scope :kw_search, against: :keyword,:using => {
  #                   :tsearch => {:dictionary => "simple"}
  #                 }
  
  scope :hot, -> { order('search_count desc') }
  def add_search_count
    self.class.increment_counter(:search_count, self.id)
  end
  
  def self.kw_search(keyword)
    where('keyword like ?', "%#{keyword}%")
  end
end
