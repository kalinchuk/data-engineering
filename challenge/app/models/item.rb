# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  description :string(255)
#  price       :float
#  created_at  :datetime
#  updated_at  :datetime
#

class Item < ActiveRecord::Base
end
