class UploadController < ApplicationController
skip_before_filter  :verify_authenticity_token


def index

end

def upload
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end 	 
  render 'complete'
end

def processruql()
  question_open = false
  #p = Problem.new
  File.open('/upload/'+ params['myfile'][:filename], 'r') do |f1|
  	  while line = f1.gets
		if question_open
		  if line =~ /\s*end.*/
		  	puts line 
		  	#p.save!
		  	#p = Problem.new
		  	question_open = false
			
		  else
		  	#p.text << line
			#puts line
		  end
		else
		  if line =~ /\s*truefalse.*/
		  	#p.text = line
		  	#p.save!
		  	#p = Problem.new
		  	#puts line
		  	question_open = false
		  elsif line =~ /\s*fill_in.* | \s*choice_answer.* | \s*select_multiple.*/
		    question_open = true
		    #p.text = line
		    puts line
		  end
		end
	  end
     end
end

end
