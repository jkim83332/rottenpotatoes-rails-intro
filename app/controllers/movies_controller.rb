class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @rating = params[:ratings]
    
    if params[:ratings].nil?
      @rating = session[:ratings]
    else
      @rating = params[:ratings]
    end
    
    if params[:sorting].nil?
      sort = session[:sorting]
    else
      sort = params[:sorting]
    end
    
    if @rating.nil?
      @ratings_to_show = []
    else
      @ratings_to_show = @rating.keys  
    end
    
    @movies = Movie.with_ratings(@ratings_to_show)
    if sort=="title"
      @tclass = "hilite p-3 mb-5 bg-warning"
      @movies = @movies.order("title")
      session[:sorting] = "title"
    elsif sort=="release_date"
      @rclass = "hilite p-3 mb-2 bg-warning"
      @movies = @movies.order("release_date")
      session[:sorting] = "release_date"
    end
    
    session[:ratings] = @rating
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
