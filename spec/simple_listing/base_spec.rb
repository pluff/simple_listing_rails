require 'spec_helper'

require 'support/shared_examples/configurable'

RSpec.describe SimpleListing::Base do
  subject { SimpleListing::Base.new(scope, {}) }
  let(:scope) { double() }

  it_behaves_like "configurable"

  describe "#perform" do
    it 'yields control' do
      expect { |b|
        subject.perform &b
      }.to yield_with_args(subject)
    end

    it 'returns scope' do
      expect(subject.perform).to eql scope
    end
  end

  [:scope, :params].each do |method|
    it "defines public '#{method}' reader" do
      expect(subject).to respond_to method
    end

    it "does not define public '#{method}' writer" do
      expect(subject).not_to respond_to "#{method}="
    end
  end
end
