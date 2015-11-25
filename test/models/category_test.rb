require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def test_create_category
    category = FactoryGirl.create :category
    assert category.persisted?
  end

  def test_create_children
    parent = FactoryGirl.create :category
    parent.children = FactoryGirl.create_list( :category, 10, parent_id: parent.id)
    assert_equal 10, parent.children.count
  end

  def test_with_children
    parent = FactoryGirl.create :category
    parent.children = FactoryGirl.create_list( :category, 10, parent_id: parent.id)
    assert_equal 1, Category.with_children.count
  end

  def test_siblings
    parent = FactoryGirl.create :category
    parent.children = FactoryGirl.create_list( :category, 10, parent_id: parent.id)
    child = parent.children.first
    siblings = child.siblings
    assert_equal 9, siblings.count
    refute siblings.pluck(:id).include? child.id
  end

  def test_no_siblings
    category = FactoryGirl.create :category
    assert_empty category.siblings
  end


  def test_has_parent_eh
    parent = FactoryGirl.create( :category )
    child = parent.children.create FactoryGirl.attributes_for(:category)
    refute parent.has_parent?
    assert child.has_parent?
  end
end
