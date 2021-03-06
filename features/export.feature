Feature: Export a collection
  As an instructor
  So I can publish a quiz
  I want to be export a collection

  Background:
    Given I am signed in with uid "1234" and provider "github"
    And I have uploaded 'micro_quizzes.txt'
    And I am on the dashboard

  Scenario: Export a quiz successfully
    When I follow "1/22/15 (W1 L2)"
    And I follow "Export"
    Then I should see "1/22/15 (W1 L2)"

  Scenario: Export a quiz unsuccessfully
    When I follow "start a new collection"
    And I fill in "collection_name" with "yolo"
    And I press "Create"
    Then I should be on the dashboard
    And I follow "yolo"
    And I follow "Export"
    Then I should see "Cannot export an empty collection! Add some questions to your collection"
