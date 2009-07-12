Spec::Matchers.define :smart_match do |expected|
  match do |actual|
    case expected
    when /^\/.*\/?$/
      actual =~ eval(expected)
    when /^".*"$/
      actual.index(eval(expected))
    else
      false
    end
  end
  
  failure_message_for_should do |actual|
    "expected #{expected} to smart match the actual:\n\n#{actual}\n"
  end
  
end
