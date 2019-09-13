class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_lastest, ->{order created_at: :desc}
  scope :user_feed, ->(following_ids){where("user_id IN (?)", following_ids)}

  validates :user_id, presence: true
  validates :content, length: {maximum: Settings.max_mipost_content},
            presence: true
  validate  :picture_size

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return if picture.size < Settings.max_size_picture.megabytes
    errors.add(:picture, I18n.t("invalid_file.message_file_max"))
  end
end
