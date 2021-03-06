class TheatersController < ApplicationController

  respond_to :html
  before_filter :require_login, :except => [:index, :show]

  def index
    @theaters = Theater.all
    respond_with @theaters
  end

  def show
    @theater = Theater.find(params[:id])
    @venues = @theater.venues

    respond_with [@theater, @venues]
  end

  def new
    @theater = Theater.new
    @theater.venues.build
    respond_with @theater
  end

  def edit
    @theater = Theater.find(params[:id])
  end

  def create
    @theater = Theater.new(theater_params)
    if @theater.save
      flash[:success] = t(:theater_created)
      redirect_to @theater
    else
      flash[:error] = t(:theater_not_created)
      render :new
    end
  end

  def update
    @theater = Theater.find(params[:id])
    if @theater.update_attributes(theater_params)
      redirect_to @theater, notice: 'El teatro fue modificado exitosamente'
    else
      flash[:alert] = "No se pudo modificar el teatro"
      render :edit
    end
  end

  def destroy
    @theater = Theater.find(params[:id])
    @theater.destroy
    redirect_to theaters_path, notice: "El teatro fue borrado exitosamente"
  end

  private

  def theater_params
    params.require(:theater).permit(:name, :description, :website, :email)
  end
end
