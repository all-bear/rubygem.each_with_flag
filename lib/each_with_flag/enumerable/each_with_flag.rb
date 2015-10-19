module Enumerable
  # The version of the each-with-flag library.
  EACH_WITH_FLAG_VERSION = '0.1.0'

  EACH_WITH_FLAG_FLAGS = {
      :first        => [:first, :is_first],
      :has_previous => [:has_previous, :has_prev],
      :surrounded   => [:surrounded, :is_surrounded],
      :has_next     => :has_next,
      :last         => [:last, :is_last]
  }

  def each_with_flag(*params)
    self.each_with_index do |data, index|
      yield data, *flags(index, params)
    end
  end

  def each_with_index_with_flag(*params)
    self.each_with_index do |data, index|
      yield data, index, *flags(index, params)
    end
  end

  def self.all_user_flags
    [EACH_WITH_FLAG_FLAGS.values].flatten
  end

  private_class_method :all_user_flags

  all_user_flags.each do |flag|
    define_method "each_with_#{flag}_flag" do |&b|
      self.each_with_flag(flag) do |*params|
        b.call *params
      end
    end

    define_method "each_with_index_with_#{flag}_flag" do |&b|
      self.each_with_index_with_flag(flag) do |*params|
        b.call *params
      end
    end
  end

  private

  def user_flags_for(name)
    [EACH_WITH_FLAG_FLAGS[name]].flatten
  end

  def slice_hash(hash, keys)
    keys.each_with_object({}) do |k, h|
      h[k] = hash[k] if hash.has_key?(k)
    end
  end

  def define_flag(user_flags, flag_name, value)
    user_flags_for(flag_name).each_with_object(user_flags) do |user_flag, flags|
      flags[user_flag] = value
      flags
    end
  end

  def last_index
    self.size - 1
  end

  def flags(index, params)
    flags = {}

    define_flag(flags, :first, index == 0)
    define_flag(flags, :has_previous, 0 < index)
    define_flag(flags, :surrounded, 0 < index && index < last_index)
    define_flag(flags, :has_next, index < last_index)
    define_flag(flags, :last, index == last_index)
    define_flag(flags, :first, index == 0)

    slice_hash(flags, params).values
  end
end