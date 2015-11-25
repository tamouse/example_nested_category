require "factory_girl_rails"

Category.destroy_all

parents = FactoryGirl.create_list :category, 10

# 3 levels deep
parents.each do |parent|
  (0).upto(rand(3)) do |index|
    parent.children.create FactoryGirl.attributes_for(:category)
  end
  parent.children.each do |child|
    (0).upto(rand(2)) do |child_index|
      child.children.create FactoryGirl.attributes_for(:category)
    end
  end
end
