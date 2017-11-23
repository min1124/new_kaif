class WelcomesController < ApplicationController
  def home
  end

  def about
    @user=TUser.new
  end

  def help
  	@users=User.all
    @Uses=TUser.all
  end

  def index
  	@tasks=Task.all
  end

  def create
  end
end
