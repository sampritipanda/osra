require 'rails_helper'

describe BooleanValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :boolean_field

      validates :boolean_field, boolean: true
    end
  end

  subject { test_model.new }

  it 'passes when attribute is true' do
    subject.boolean_field = true
    expect(subject).to be_valid
  end

  it 'passes when attribute is false' do
    subject.boolean_field = false
    expect(subject).to be_valid
  end

  it 'fails when attribute is nil' do
    subject.boolean_field = nil
    expect(subject).to_not be_valid
  end

  it 'returns appropriate message when attribute is not a boolean' do
    subject.boolean_field = 'fake_boolean'
    expect(subject).to_not be_valid
    expect(subject.errors[:boolean_field]).to eq ['is not a valid boolean']
  end
end

