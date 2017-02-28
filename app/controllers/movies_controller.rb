class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @selected_ratings = @all_ratings
    @title_hilight = 'hilite' if params[:sort] == 'title'
    @release_hilight = 'hilite' if params[:sort] == 'release_date'
    redirect = false
    if !params[:sort].nil?
      session[:sort] = params[:sort]
    elsif !session[:sort].nil?
      params[:sort] = session[:sort]
      redirect = true
    end
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    elsif !session[:ratings].nil?
      params[:ratings] = session[:ratings]
      redirect = true
    end
    if redirect == true
      flash.keep
      redirect_to movies_path(:sort=>params[:sort], :ratings=>params[:ratings])
    end
    if params[:sort].nil?&&params[:ratings].nil?
      @movies = Movie.all
    elsif !params[:sort].nil?&&params[:ratings].nil?
      @movies = Movie.order(params[:sort])
    elsif params[:sort].nil?&&!params[:ratings].nil?
      @selected_ratings = params[:ratings].keys
      @movies = Movie.where(:rating=>params[:ratings].keys)
    elsif !params[:sort].nil?&&!params[:ratings].nil?
      @selected_ratings = params[:ratings].keys
      @movies = Movie.order(params[:sort]).where(:rating=>params[:ratings].keys)
    end
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

end
