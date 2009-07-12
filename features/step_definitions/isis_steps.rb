Given /^a directory named "([^\"]*)"$/ do |dir_name|
  create_directory(dir_name)
end

Given /^a git repo at "([^\"]*)"$/ do |path|
  create_git_repo(path)
end

Given %r{^a file named "([^"]+)" with:$} do |file_name, code|
  create_file(file_name, code)
end

When %r{^I run "isis ([^"]+)"$} do |file_and_args|
  isis(file_and_args)
end

Then /^the (.*) should match (.*)$/ do |stream, string_or_regex|
  written = case(stream)
    when 'stdout' then last_stdout
    when 'stderr' then last_stderr
    else raise "Unknown stream: #{stream}"
  end
  written.should smart_match(string_or_regex)
end

Then /^the (.*) should not match (.*)$/ do |stream, string_or_regex|
  written = case(stream)
    when 'stdout' then last_stdout
    when 'stderr' then last_stderr
    else raise "Unknown stream: #{stream}"
  end
  written.should_not smart_match(string_or_regex)
end

Then /^the exit code should be (\d+)$/ do |exit_code|
  if last_exit_code != exit_code.to_i
    raise "Did not exit with #{exit_code}, but with #{last_exit_code}. Standard error:\n#{last_stderr}"
  end
end