# == Schema Information
#
# Table name: visits
#
#  id               :bigint           not null, primary key
#  shortened_url_id :integer          not null
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Visit < ApplicationRecord
    # validates :shortened_url_id, presence: true
    # validates :user_id, presence: true

    belongs_to :shortened_url,
        primary_key: :id,
        foreign_key: :shortened_url_id,
        class_name: :ShortenedUrl

    belongs_to :user,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User

    def self.record_visit!(user, shortened_url)
        Visit.create!(user_id: user.id, shortened_url_id: shortened_url.id)
    end
end
