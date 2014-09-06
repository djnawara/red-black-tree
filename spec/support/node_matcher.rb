require "rspec/expectations"

RSpec::Matchers.define :be_node do |expected|
  match do |actual|
    actual.equal?(expected)
  end

  failure_message do |actual|
    "expected: #{expected}\nactual:   #{actual}"
  end

  failure_message_when_negated do |actual|
    "expected not: #{expected}\nactual:       #{actual}"
  end
end
