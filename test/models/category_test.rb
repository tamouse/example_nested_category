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

  def test_is_root_eh
    root = FactoryGirl.create( :category )
    assert_equal root, Category.root
    assert root.is_root?
  end

  def test_is_leaf_eh
    node = FactoryGirl.create( :category )
    assert node.is_leaf?
  end

  def test_ensure_one_root
    root = FactoryGirl.create( :category )
    other = FactoryGirl.create( :category )
    assert root.is_root?
    refute other.is_root?
    assert_equal root, other.parent
    assert root.children.include?(other)
  end

  def test_ensure_one_root_forced
    root = FactoryGirl.create( :category )
    other = FactoryGirl.create( :category )

    other.update(parent_id: nil)
    other.reload

    assert root.is_root?
    refute other.is_root?
    assert_equal root, other.parent
    assert root.children.include?(other)
  end

  def test_ensure_one_root_removed
    root = FactoryGirl.create( :category )
    other = FactoryGirl.create( :category )

    root.update(parent: other)
    root.reload

    assert root.is_root?
    refute other.is_root?
    assert_equal root, other.parent
    assert root.children.include?(other)
  end

  def test_make_root
    root = FactoryGirl.create( :category )
    other = FactoryGirl.create( :category )

    other.make_root

    root.reload
    other.reload

    refute root.is_root?, "root should not be root anymore: #{root.inspect}"
    assert other.is_root?
    refute_equal root, other.parent
    refute root.children.include?(other)
    assert_equal other, root.parent
    assert other.children.include?(root)
  end
end
