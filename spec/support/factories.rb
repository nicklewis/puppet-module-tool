require 'factory_girl'

#---[ Factory definitions ]---------------------------------------------

Factory.define :user do |f|
  f.sequence(:username) { |n| "user#{n}" }
  f.sequence(:email) { |n| "user#{n}@example.com" }
  f.password 'mypassword'
  f.display_name { |record| record.username.capitalize }
  f.admin false
  # TODO Figure out why these two lines aren't enough to confirm a user
  ### f.confirmed_at Time.now
  ### f.confirmation_token nil
  f.after_build do |record|
    # NOTE: Confirm user record so that #sign_in test helper works
    # TODO Figure out why `record.confirm!` must be called twice
    record.confirm!
    record.confirm!
  end
end

Factory.define :admin, :parent => :user do |f|
  f.admin true
end

Factory.define :mod do |f|
  f.sequence(:name) { |n| "name#{n}" }
  f.sequence(:project_url) { |n| "http://example.com/mod#{n}" }
  f.association :owner, :factory => :user
  f.description "Description for this module."
end

Factory.define :release do |f|
  f.sequence(:version) { |n| "0.#{n}" }
  f.notes { |record| "This is version #{record.version}" }
  f.file "mymodule-0.0.1.tar.gz"
  f.association :mod
end

Factory.define :tag do |f|
  f.sequence(:name) { |n| "tag_#{n}" }
end

Factory.define :tagging do |f|
  f.association :tag
  f.association :mod
end

#---[ Factory methods ]-------------------------------------------------

# Return a Mod and its User.
def populated_mod_and_user
  user = Factory :user
  mod = Factory :mod, :owner => user
  return [mod, user]
end

# Return a Release, Mod and User.
def populated_release_and_mod_and_user
  mod, user = populated_mod_and_user
  release = Factory(:release, :mod => mod)
  return [release, mod, user]
end
