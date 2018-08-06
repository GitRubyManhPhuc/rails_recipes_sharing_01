class RecipesController < ApplicationController
  before_action :logged_in_user, except: [:show, :index]
  impressionist actions: [:show]

  def index
    @recipes = Recipe.desc.page(params[:page])
      .per Settings.recipe_per_index
  end

  def new
    @recipe = Recipe.new
    @categories = Category.all
    3.times{@recipe.steps.build}
    3.times{@recipe.recipe_ingredients.build}
  end

  def create
    @recipe = Recipe.new recipe_params
    if @recipe.save
      redirect_to @recipe
    else
      render :new
    end
  end

  def show
    @recipe = Recipe.find_by id: params[:id]
    @user = @recipe.user
    @comments = @recipe.comments.all
    @comment = @recipe.comments.build
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name,
      :description, :purpose, :ready_in, :difficult_level,
      :people_num, steps_attributes: [:content],
      recipe_ingredients_attributes: [:temp]).merge user_id: current_user.id
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

end
