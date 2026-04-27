class Decision < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :selected_option, class_name: 'Option', optional: true

  has_many :decision_emotions, dependent: :destroy
  has_many :emotion_types, through: :decision_emotions
  has_many :options, dependent: :delete_all

  accepts_nested_attributes_for :options,
    allow_destroy: true,
    reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 100 }
  validates :category_id, presence: true
  validates :reason, length: { maximum: 1000 }, allow_blank: true

  validate :selected_option_presence
  validate :selected_option_must_belong_to_decision
  validate :options_content_uniqueness

  before_update :clear_selected_option_if_destroyed
  before_destroy :detach_selected_option

  private

  def clear_selected_option_if_destroyed
    return if selected_option_id.blank?

    destroying_ids = options.select(&:marked_for_destruction?).map(&:id)

    return unless destroying_ids.include?(selected_option_id)

    self.selected_option_id = nil
  end

  def detach_selected_option
    self.selected_option_id = nil
    save(validate: false)
  end

  def selected_option_presence
    return if selected_option_id.present? || new_record?
    errors.add(:selected_option, "を選択してください")
  end

  def selected_option_must_belong_to_decision
    return if selected_option_id.blank?

    return if options.where(id: selected_option_id).exists?

    errors.add(:selected_option, "はこの決断に属する選択肢から選んでください")
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
