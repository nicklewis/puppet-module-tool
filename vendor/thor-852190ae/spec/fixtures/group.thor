class MyCounter < Thor::Group
  include Thor::Actions
  add_runtime_options!

  def self.get_from_super
    from_superclass(:get_from_super, 13)
  end

  def self.source_root
    File.expand_path(File.dirname(__FILE__))
  end
  source_paths << File.expand_path("broken", File.dirname(__FILE__))

  argument :first,     :type => :numeric
  argument :second,    :type => :numeric, :default => 2

  class_option :third,  :type => :numeric, :desc => "The third argument", :default => 3,
                        :banner => "THREE", :aliases => "-t"
  class_option :fourth, :type => :numeric, :desc => "The fourth argument"

  desc <<-FOO
Description:
  This generator run three tasks: one, two and three.
FOO

  def one
    first
  end

  def two
    second
  end

  def three
    options[:third]
  end

  def self.inherited(base)
    super
    base.source_paths.unshift(File.expand_path(File.join(File.dirname(__FILE__), "doc")))
  end
end

class ClearCounter < MyCounter
  remove_argument :first, :second, :undefine => true
  remove_class_option :third

  def self.source_root
    File.expand_path(File.join(File.dirname(__FILE__), "bundle"))
  end
end

class BrokenCounter < MyCounter
  namespace "app:broken:counter"
  class_option :fail, :type => :boolean, :default => false

  class << self
    undef_method :source_root
  end

  def one
    options[:first]
  end

  def four
    respond_to?(:fail)
  end

  def five
    options[:fail] ? this_method_does_not_exist : 5
  end
end

class WhinyGenerator < Thor::Group
  include Thor::Actions

  def self.source_root
    File.expand_path(File.dirname(__FILE__))
  end

  def wrong_arity(required)
  end
end
