RSpec.shared_examples_for 'configurable' do
  it 'class has config reader' do
    expect(subject.class).to respond_to :config
  end
end
