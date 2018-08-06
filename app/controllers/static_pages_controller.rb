class StaticPagesController < ApplicationController
  def home
    @categories = Category.order_by_name
    @recipes = Recipe.hot_recipe.desc
    @topusers = User.top_user
  end
end
