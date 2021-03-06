class MoviesController < ApplicationController
  before_action :restrict_access, only: [:new]
  
  def index
    @movies = Movie.all
    if params[:q]
      @movies = @movies.where("lower(title) like ?", "%#{params[:q].downcase}%")
    end
    if params[:p]
      @movies = @movies.where("lower(director) like ?", "%#{params[:p].downcase}%")
    end
    render :index
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)
    puts @movie

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description
    )
  end
end
