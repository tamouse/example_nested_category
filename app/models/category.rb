class Category < ActiveRecord::Base
  belongs_to :parent, class_name: "Category"
  has_many :children, class_name: "Category", foreign_key: :parent_id

  scope :with_children, ->() { joins(:children).distinct }
  scope :top_level, ->() { where(parent_id: nil) }

  def siblings
    if parent
      parent.children.where.not(id: self.id)
    else
      Category.top_level.where.not(id: self.id)
    end
  end

  def has_parent?
    self.parent.present?
  end

end
