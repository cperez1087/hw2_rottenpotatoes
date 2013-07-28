
class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    set_index_persistence

    @all_ratings = Movie.ratings
    @ratings = (session[:movies_index_persistence][:ratings]) ? session[:movies_index_persistence][:ratings].keys : @all_ratings

    @sort_by = session[:movies_index_persistence][:sort]
    @movies = Movie.order(@sort_by)
    @movies = @movies.where(:rating => @ratings) unless @ratings.empty?

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
  def set_index_persistence
    session[:movies_index_persistence] = {} if session[:movies_index_persistence].nil?

    needs_redirect =  params[:sort] != session[:movies_index_persistence][:sort] ||
                      params[:ratings] != session[:movies_index_persistence][:ratings]

    session[:movies_index_persistence][:sort] = params[:sort] unless params[:sort].nil?
    session[:movies_index_persistence][:ratings] = params[:ratings] unless params[:ratings].nil?

    redirect_to movies_path(session[:movies_index_persistence]) if needs_redirect
  end

end
