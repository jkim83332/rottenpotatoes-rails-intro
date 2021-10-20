class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)
    if ratings_list.size==0
      return where(rating:self.all_ratings)
    else
      return where(rating:ratings_list)
    end
  end  
end
