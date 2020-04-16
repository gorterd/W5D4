# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  short_url  :string
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShortenedUrl < ApplicationRecord
    validates :long_url, presence: true, uniqueness: true
    validates :short_url, uniqueness: true

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User

    has_many :visits,
        primary_key: :id, 
        foreign_key: :shortened_url_id,
        class_name: :visits

    has_many :visitors,
        through: :visits,
        source: :user_id

    def self.random_code
        code = SecureRandom.urlsafe_base64
        code = SecureRandom.urlsafe_base64 while ShortenedUrl.exists?(short_url: code)
        code
    end

    def self.create_short_url(user, long_url)
        ShortenedUrl.create!(user_id: user.id, long_url: long_url, short_url: ShortenedUrl.random_code)
    end

    def num_clicks
        Visit.where(shortened_url_id: self.id).count
    end

    def num_uniques
        Visit.where(shortened_url_id: self.id).select(:user_id).distinct.count
    end
    
    def num_recent_uniques
        since_time = Time.now - 2.minutes
        Visit.where(shortened_url_id: self.id, created_at: since_time..Time.now).select(:user_id).distinct.count
    end

end
