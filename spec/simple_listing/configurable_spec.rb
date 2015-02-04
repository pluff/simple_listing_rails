require 'spec_helper'

class ConfigurableTest
  include SimpleListing::Configurable
end

RSpec.describe SimpleListing::Configurable do
  subject { ConfigurableTest }

  describe ".config" do
    it 'stores passed configuration' do
      test = {a: 1}
      expect {
        subject.config(test)
      }.to change { subject.config }.to test
    end

    it 'merges passed configuration with previous' do
      subject.config(a: 1, b: 1)
      expect {
        subject.config(a: 2, c: 1)
      }.to change { subject.config }.to({a: 2, b: 1, c: 1})
    end
  end
end
