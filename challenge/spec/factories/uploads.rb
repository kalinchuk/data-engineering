# == Schema Information
#
# Table name: uploads
#
#  id                :integer          not null, primary key
#  creator_id        :integer
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :upload do
    creator factory: :user
    file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.tab'), 'application/octet-stream') }
  end
end
