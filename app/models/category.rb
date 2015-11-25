class Category < ActiveRecord::Base
  belongs_to :parent, class_name: "Category"
  has_many :children, class_name: "Category", foreign_key: :parent_id

  scope :with_children, ->() { joins(:children).distinct }

  def siblings
    parent.children.where.not(id: self.id)
  end
end
