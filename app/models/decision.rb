class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :selected_option, class_name: "Option", optional: true

  has_many :decision_emotions, dependent: :destroy
  has_many :emotion_types, through: :decision_emotions
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options,
    allow_destroy: true,
    reject_if: proc { |attributes|
      attributes["content"].blank?
    }

  validates :title, presence: true, length: { maximum: 100 }
  validates :category_id, presence: true
  validates :reason, length: { maximum: 1000 }, allow_blank: true
  validates :recorded_on, presence: true

  validate :options_presence
  validate :options_content_uniqueness

  before_update :clear_selected_option_if_destroyed
  before_destroy :detach_selected_option

  private

  def options_presence
    if options.reject(&:marked_for_destruction?).all? { |o| o.content.blank? }
      errors.add(:base, "選択肢を入力してください")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "category_id", "recorded_on", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end

  def clear_selected_option_if_destroyed
    return if selected_option_id.blank?

    destroying_ids = options.select(&:marked_for_destruction?).map(&:id)

    if destroying_ids.include?(selected_option_id)
      self.selected_option_id = nil
    end
  end

  def detach_selected_option
    update_columns(selected_option_id: nil)
  end

  def options_content_uniqueness
    contents = options.map(&:content).reject(&:blank?)

    duplicates = contents.group_by(&:itself)
                         .select { |_, v| v.size > 1 }
                         .keys

    duplicates.each do |dup|
      errors.add(:base, "選択肢「#{dup}」が重複しています")
    end
  end
end
