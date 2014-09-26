class BooleanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless [true, false].include? value
      record.errors[attribute] << ('is not a valid boolean')
    end
  end
end
