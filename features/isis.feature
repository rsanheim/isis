Feature: Listing all git repos

  In order to see what Isis is doing
  As an Isis user
  I want to list all the git repos Isis knows about

  Scenario: no config file
    Given a file named "custom_formatter.rb" with:
      """
      require 'spec/runner/formatter/base_formatter'
      class CustomFormatter < Spec::Runner::Formatter::BaseFormatter
        def initialize(options, output)
          @output = output
        end
        def example_started(proxy)
          @output << "example: " << proxy.description
        end
      end
      """
    And a file named "simple_example_spec.rb" with:
    """
      describe "my group" do
        specify "my example" do
        end
      end
    """

    When I run "isis list --project_roots src/janedoe"
    Then the exit code should be 0
    And the stdout should match "3 git repos I know about: foo, bar baz"
