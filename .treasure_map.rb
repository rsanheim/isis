map_for(:isis) do |m|

  m.watch 'lib', 'examples', 'features'

  m.add_mapping %r%examples/(.*)_example\.rb% do |match|
    ["examples/#{match[1]}_example.rb"]
  end

  m.add_mapping %r%examples/example_helper\.rb% do |match|
    Dir["examples/**/*_example.rb"]
  end

  m.add_mapping %r%lib/(.*)\.rb% do |match|
    examples_matching match[1]
  end

  m.add_mapping %r%features/(.*)\.feature%, :command => "cucumber" do |match|
    ["features/#{match[1]}.feature"]
  end
  
  m.add_mapping %r%features/step_definitions/(.*)_steps\.rb%, :command => "cucumber" do |match|
    ["features/#{match[1]}.feature"]
  end
  
  m.add_mapping %r%features/support/(.*)\.rb%, :command => "cucumber" do |match|
    Dir["features/**/*.feature"]
  end
  
  
end
