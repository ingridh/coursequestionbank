class Problem < ActiveRecord::Base
  attr_accessible :created_date, :is_public, :last_used, :rendered_text, :text, :json, :problem_type
  has_and_belongs_to_many :tags
  belongs_to :instructor
  has_and_belongs_to_many :collections
  

  scope :is_public, -> { where(is_public:  true) }
  scope :last_used, ->(t) { where(last_used: t) }
  scope :instructor_id, ->(id) { where(instructor_id: id) }
  

  searchable do
    integer   :id
    text      :text
    text      :json
    integer   :instructor_id
    boolean   :is_public
    time      :last_used
    # integer :collection_id
    
    string    :tag_names, :multiple => true do
      tags.map(&:name)
    end
    # integer :collection_ids, :multiple => true do
    #   collections.map(&:id)
    # end
  end

  def html5
    if rendered_text
      return rendered_text 
    end

    if json and !json.empty?
      question = Question.from_JSON(self.json)
      quiz = Quiz.new("", :questions => [question])
      quiz.render_with("Html5", {'template' => 'preview.html.erb'})
      self.update_attributes(:rendered_text => quiz.output)
      quiz.output
    else
      'This question could not be displayed (no JSON found)' 
    end
  end

  def self.filter(user, filters = {})
    filters['tags'] = filters['tags'].strip.split(',')

    if !filters['last_exported_begin'] or filters['last_exported_end'].empty?
      filters['last_exported_begin'] = nil
    end
    if !filters['last_exported_end'] or filters['last_exported_end'].empty?
      filters['last_exported_end'] = nil
    end


    problems = Problem.search do 
      any_of do
        with(:instructor_id, user.id)
        with(:is_public, true)
      end
      with(:tag_names, filters[:tags]) if filters[:tags].present? #I THOUGHT SUNSPOT SAID THE PRESENCE CHECK WAS UNNECESARY
      # with(:collection_ids, filters[:collections].keys)
      if filters['last_exported_begin']
        with(:last_used).greater_than_or_equal_to(filters['last_exported_begin'])
      end
      if filters['last_exported_end']
        with(:last_used).less_than_or_equal_to(filters['last_exported_end'])
      end
      fulltext filters['search']
      paginate :page => filters['page'], :per_page => filters['per_page']
    end
    problems
  end
end
