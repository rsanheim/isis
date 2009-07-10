Feature: Listing all git repos

  In order to see what Isis is doing
  As an Isis user
  I want to list all the git repos Isis knows about

  Scenario: no config file
    Given a directory named "src/janedoe"
      And a directory named "src/janedoe/non-git-dir"
      And a git repo at "src/janedoe/foo"
      And a git repo at "src/janedoe/bar"
      And a git repo at "src/janedoe/baz"

    When I run "isis list --project_roots=src/janedoe"
    Then the exit code should be 0
    And the stdout should match "Known git repos: bar, baz, foo"
    And the stdout should not match "non-git-dir"
