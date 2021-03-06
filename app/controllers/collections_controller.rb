class CollectionsController < ApplicationController
  load_and_authorize_resource
  after_filter :set_current_collection 

  def set_current_collection
  end

  def new
    @collection = Collection.new
  end

  def edit
    @collection = Collection.find(params[:id])
    @problems = @collection.problems
  end

  # creates a new collection with user specified values and sets as current collection
  def create
    collection_hash = params[:collection]
    if not (collection = @current_user.collections.create(collection_hash)).valid?
      flash[:notice] =  collection.errors.messages.map {|key, value| key.to_s + ' ' + value.to_s}.join ' ,'
      flash.keep
    end
    redirect_to profile_path
  end

  def show
    @collection = Collection.find(params[:id])
    @problems = @collection.problems
  end

  def update
    if not (collection = Collection.update(params[:id], params[:collection])).valid?
      flash[:notice] =  collection.errors.messages.map {|key, value| key.to_s + ' ' + value.to_s}.join ' ,'
      flash.keep
    end
    redirect_to profile_path
  end

  def destroy
    Collection.find(params[:id]).destroy
    flash[:notice] = 'Collection deleted'
    flash.keep
    redirect_to profile_path
  end

  def export
    
    @html_code = Collection.find(params[:id]).export('Html5')
    
    begin
      @edx_code = Collection.find(params[:id]).export('EdXml')
    rescue RuntimeError
      @edx_code = 'EdX not available'
    end
 
    begin
      @autoqcm_code = Collection.find(params[:id]).export('AutoQCM')
    rescue RuntimeError
      @autoqcm_code = 'AutoQCM not available'
    end

    if not @html_code
      flash[:notice] = 'Cannot export an empty collection! Add some questions to your collection first!'
      flash.keep
      redirect_to edit_collection_path( id: params[:id])
    end
  end

  def finalize_upload
    @collections = params[:ids].map{|collection_id| Collection.find(collection_id)}
  end

  def checked_problems
    collection = Collection.find(params[:dropdown])
    collection_size = collection.problems.size
    if params['add_problems'] and params[:problems].present?
      params[:problems].each {|problem_id, value| collection.problems << Problem.find(problem_id)}
      flash[:notice] = "#{collection.problems.size - collection_size} of #{params[:problems].size } problems added to collection: #{collection.name}. If not all were added, you are trying to add a duplicate to the collection"
      flash.keep
    end
    if params[:problems].present? #for delete route
      params[:problems].each {|problem_id, value| Problem.find(problem_id).destroy}
      flash[:notice] = 'Problems successfully deleted'
      flash.keep
    end
    redirect_to problems_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = exception.message
    redirect_to profile_path, :alert => exception.message
  end
end
