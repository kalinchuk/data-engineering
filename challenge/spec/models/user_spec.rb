# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

describe User do
  describe "creation" do
    let(:creation_attributes) {{
      email: Faker::Internet.email,
      password: Devise::friendly_token.first(6)
    }}

    subject { User.create(creation_attributes) }

    describe "validations" do
      it "accepts a user with all attributes" do
        expect(subject).to be_valid
      end
    end
  end
end
