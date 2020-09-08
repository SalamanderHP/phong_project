class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_max_lenght}
  validates :image, content_type: {
    in: Settings.micropost.type.split, message: I18n.t("microposts.type_msg")
  }, size: {
    less_than: Settings.micropost.image_size.megabytes,
    message: I18n.t("microposts.size_message")
  }

  scope :orderize, ->{order created_at: :desc}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant resize_to_limit: [Settings.micropost.img_limit,
                                    Settings.micropost.img_limit]
  end
end
