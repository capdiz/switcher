Feature: Switcher
 In order to create a single-mother directory
 for a switcher single-mother application
 I as switcher needs to be able to do the following

 Scenario: Creating a single-mother directory
  When I run 'bundle exec switcher motherdir chozi_shop'
  Then the output should contain "Creating single mother directory chozi_shop"

 Scenario: Creating a new api
  When I run 'switcher create service merchants'
  Then the output should contain "Creating service merchants"
