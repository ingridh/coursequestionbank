Feature: collections that we can add problems to
  As an instructor
  So that I can group problems together and export 
  I want to be able to add problems to a collection

  Background:
    Given I am signed in with uid "1234" and provider "github"
    And I have uploaded 'micro_quizzes.txt'

    And I am on the dashboard
  
  Scenario: create a new collection
    When I follow "start a new collection"
    And I fill in "collection_name" with "yolo"
    And I press "Create Collection"
    Then I should be on the dashboard
    And I add problem containing 'Raffi' to collection 'yolo'
    And I should see Collection 'yolo' in the database

  Scenario: add a new question to current collection
    When I create a new collection 'yolo' and mark it as current
    And I add problem containing 'Raffi' to the collection 'yolo'
    Then I should see 'Raffi' within the collection 'yolo'

  Scenario: use the dropdown to add a question to non-current collection:
    When I create a new collection 'yolo'
    Then I add the problem containing text 'Raffi' to 'yolo'

  Scenario: upload same file twice
    Given I am on the upload page
    And I attach the file "features/test_files/foo.txt" to "file_upload"
    And I press "upload"
    Given I am on the upload page
    And I attach the file "features/test_files/foo.txt" to "file_upload"
    And I press "upload"
    Then I should see "There is an error in the file: Quiz with that name already exists in your list of collections. You probably didn't mean to upload the same quiz again. Try deleting the old collection and upload again if you really meant to do that"

    