# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end
 
Then /^(?:|I )should see "(.*?)"$/ do |text|
    expect(page).to have_content(text)
end

When(/^I click on the link "(.*?)"$/) do |arg1|
  click_link(arg1)
end

Then /^I should find "(.*?)" before "(.*?)"$/ do |arg1, arg2| 
    regcheck = /#{arg1}.*#{arg2}/m
    #regex checks html body for arg1 and arg2, m option is if on another line
    expect regcheck.match(page.html)!=nil
end



 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  #pending  # Remove this statement when you finish implementing the test step
  @rows=0
  movies_table.hashes.each do |movie|
       @rows+=1
       Movie.create movie
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)

  Movie.all_ratings.each do |rating|
     uncheck("ratings_#{rating.gsub(/\s+/, "")}")
  end
  
  arg1.split(',').each do |rated| # 
    check("ratings_#{rated.gsub(/\s+/, "")}")
  end

  click_button('Refresh')

  #pending  #remove this statement after implementing the test step
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|

  #pending  #remove this statement after implementing the test step
    checklist=Movie.all_ratings
    checklist.each do |rating|
        arg1.split(',').each do |goodrating|
            if(rating.gsub(/\s+/, "") == goodrating.gsub(/\s+/, ""))
                checklist.delete(rating)
            end
        end
    end
    
    movies = Movie.all
    movies.each do |movie|
        checklist.each do |check|
            if check == movie.rating 
                page.should have_no_content(movie.title)
            end
        end
    end
    
    
    
end

Then /^I should see all of the movies$/ do 
    #check("ratings_R")
    #check("ratings_PG-13")
    #check("ratings_PG")
    #check("ratings_G")
    count =-1
    result = false
   all("tr").each do |tr|
     count+=1
   end    
  
   if(count == @rows)
       result = true
   end
       
    expect(result).to be_truthy
  #pending  #remove this statement after implementing the test step
end



