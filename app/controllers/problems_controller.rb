class ProblemsController < ApplicationController

  def home
      redirect_to problems_path
  end

	def index
  		filter_options = params.slice(:tags, :collections, :last_exported)
      @problems = Problem.filter(@current_user, filter_options)
      puts @problems.size
      puts Problem.all.size
      @collections = Collection.collections_for_user(@current_user)
	end

  def add_to_collection
    render json: {:html => "<p>I'm the markup</p>"}
  end
    
end
