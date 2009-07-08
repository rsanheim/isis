Given %r{^a file named "([^"]+)" with:$} do |file_name, code|
  create_file(file_name, code)
end
