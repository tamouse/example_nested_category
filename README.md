# example_nested_category

Showing how to use a model to refer to itself, in a tree, with
parents, children, and siblings.

## Parents, Children

Using the same model to refer to itself is relatively easy, following
the Active Record Associations guide section
[2.10 Self Joins](http://guides.rubyonrails.org/association_basics.html#self-joins)

``` ruby
class Category < ActiveRecord::Base
  belongs_to :parent, class_name: "Category"
  has_many :children, class_name: "Category", foreign_key: :parent_id
end
```

## Siblings

Some additional useful bits include setting scopes and instance
methods to provide some other useful info.

``` ruby
def siblings
  if parent
    parent.children
  else
    Category.top_level.where.not(id: self.id)
  end
end

def has_parent?
  self.parent.present?
end
```

## Scoping

Class scoping is also nice to get all the top-level categories, and
all parent categories:

``` ruby
scope :with_children, ->() { joins(:children).distinct }
scope :top_level, ->() { where(parent_id: nil) }
```

## Collection Partial View

Using a singularly named view that matches the down-cased name of the
model, you can use that view to present each element of a collection
of that model. In our example, the view file would reside at
`app/views/categories/_category.html.erb`.

``` ruby
<!-- Partial for displaying a category -->
<div class="category-item">
  <ul>
    <li>Name: <%= link_to category.name, category_path(category) %></li>
    <li>
        <% if category.parent %> <p>Parent: <%= category.parent.name %></p> <% end %>
    </li>
    <% if category.siblings %>
    <li>
      Siblings:
      <ul>
	<% category.siblings.each do |sibling| %>
	<li><%= link_to sibling.name, category_path(sibling) %></li>
	<% end %>
      </ul>
    </li>
    <% end %>
    <% unless category.children.empty? %>
    <li>
      Children:
      <blockquote>
	<%= render partial: category.children, locals: {shallow: false} %>
      </blockquote>
    </li>
    <% end %>
  </ul>
</div>

```

Instead of calling it for the siblings, it just gives a list of the
siblings. Otherwise we'd end up in infinite recursion.

Calling it with a
collection of categories would look like:

``` ruby
<h1>Full Category Listing</h1>
<%= render @categories %>
```

This can cascade by calling the same partial on a collection inside
the partial itself:

## What it looks like

![screenshot](public/Screenshot.png)


# Setting up the app for your own testing

## Dependencies

* ruby 2.2.x
* rails 4.2.x
* sqlite3

Also you might need to do something special if you're not working in a
fairly bog-standard Linux/Unix/OSX environment.

## Setting it up

### clone it

``` shell
git clone https://github.com/tamouse/example_nested_category.git
```

### bundle it

``` shell
bundle install
```

### create database

``` shell
rake db:create db:migrate db:seed
```

`db:seed` will first destroy all the categories, then set up a set of
nested categories

### run the tests

``` shell
rake test
```

### start the server

``` shell
rails s -b 0.0.0.0
```

### browse to the app, see it work

Point your browser at http://localhost:3000 and you will see the set
of categories. You can drill into the hierarchy by clicking on a name.
