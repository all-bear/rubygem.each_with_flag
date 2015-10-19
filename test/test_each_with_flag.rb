########################################################################
# test_each_with_flag.rb
#
# Test case for the enumerable-extra library. You should run this
# test via the 'rake test' task.
########################################################################
require 'test-unit'
require 'enumerable/each_with_flag'

class Test_Enumerable_EachWithFlag < Test::Unit::TestCase
  TEST_ITEM_SIZE = 3

  def setup
    @array = %w/foo bar baz/
    @hash  = {:a => 'foo', :b => 'bar', :c => 'baz'}

    @expected_flags = {
        :first        => [true, false, false],
        :has_previous => [false, true, true],
        :surrounded   => [false, true, false],
        :has_next     => [true, true, false],
        :last         => [false, false, true]
    }

    @expected_flag_mask = (0..(TEST_ITEM_SIZE - 1)).each_with_object([]) do |index, mask|
      mask[index] = @expected_flags.each_with_object([]) do |data, mask|
        mask << data[1][index]
      end
    end

    @flag_params = [:first, :has_previous, :surrounded, :has_next, :last]

    @real_flag_masks = []
    @yielded_flags   = []
    @yielded_items   = []
    @yielded_keys    = []
    @yielded_indexes = []
    @yield_counter   = 0
  end

  test 'version number is set properly' do
    assert_equal('0.1.0', Enumerable::EACH_WITH_FLAG_VERSION)
  end

  def test_each_with_flag
    check_respond_to :each_with_flag
  end

  def test_each_with_flag_for_hash
    @hash.send(:each_with_flag, *@flag_params) do |data, is_first, has_previous, surrounded, has_next, is_last|
      add_key data[0]
      add_item data[1]
      add_flag_mask [is_first, has_previous, surrounded, has_next, is_last]
      increase_yield_counter
    end

    check_flag_result_data @hash
  end

  def test_each_with_flag_for_hash_reversed_params
    @hash.send(:each_with_flag, *@flag_params.reverse) do |data, is_last, has_next, surrounded, has_previous, is_first|
      add_key data[0]
      add_item data[1]
      add_flag_mask [is_first, has_previous, surrounded, has_next, is_last]
      increase_yield_counter
    end

    check_flag_result_data @hash
  end

  def test_each_with_flag_for_array
    @array.send(:each_with_flag, *@flag_params) do |item, is_first, has_previous, surrounded, has_next, is_last|
      add_item item
      add_flag_mask [is_first, has_previous, surrounded, has_next, is_last]
      increase_yield_counter
    end

    check_flag_result_data @array
  end

  def test_each_with_flag_for_array_reversed_params
    @array.send(:each_with_flag, *@flag_params.reverse) do |item, is_last, has_next, surrounded, has_previous, is_first|
      add_item item
      add_flag_mask [is_first, has_previous, surrounded, has_next, is_last]
      increase_yield_counter
    end

    check_flag_result_data @array
  end

  def test_each_with_first_flag
    check_respond_to :each_with_first_flag
  end

  test 'each with special flags' do
    @flag_params.each { |flag| check_each_with_special flag }
  end

  test 'each with index with special flags' do
    @flag_params.each { |flag| check_each_with_index_with_special flag }
  end

  def teardown
    @array = nil
    @hash  = nil

    @real_flag_masks = nil
    @yielded_flags   = nil
    @yielded_items   = nil
    @yielded_keys    = nil
    @yield_counter   = nil
    @yielded_indexes = nil
  end

  private
  def restart
    teardown
    setup
  end

  def check_respond_to(method)
    [@array, @hash].each do |item|
      assert_respond_to(item, method)
    end
  end

  def add_flag_mask(mask)
    @real_flag_masks << mask
  end

  def increase_yield_counter
    @yield_counter = @yield_counter + 1
  end

  def add_item(item)
    @yielded_items << item
  end

  def add_key(key)
    @yielded_keys << key
  end

  def add_index(index)
    @yielded_indexes << index
  end

  def add_flag(flag)
    @yielded_flags << flag
  end

  def check_general_result_data(subject, params)
    assert_equal TEST_ITEM_SIZE, @yield_counter, 'Invalid count of block calls'

    if subject.is_a? Hash
      assert_equal @yielded_items, subject.values, 'Invalid items was passed to block'
    elsif subject.is_a? Array
      assert_equal @yielded_items, subject, 'Invalid items was passed to block'
    end

    assert_equal @yielded_keys, subject.keys, 'Invalid keys was passed to block' if subject.is_a? Hash

    assert_equal @yielded_indexes, [0, 1, 2], 'Invalid indexes was passed to block' if params[:with_index]
  end

  def check_special_flag_result_data(subject, flag, params = {})
    check_general_result_data(subject, params)

    assert_equal @expected_flags[flag], @yielded_flags, 'Invalid flags'
  end

  def check_flag_result_data(subject, params = {})
    check_general_result_data(subject, params)

    assert_equal @expected_flag_mask, @real_flag_masks, 'Invalid flags'
  end

  def check_each_with_special(special)
    method_name = "each_with_#{special}_flag"

    @array.send(method_name) do |item, is_first|
      add_item item
      add_flag is_first
      increase_yield_counter
    end

    check_special_flag_result_data @array, special

    restart

    @hash.send(method_name) do |data, is_first|
      add_key data[0]
      add_item data[1]
      add_flag is_first
      increase_yield_counter
    end

    check_special_flag_result_data @hash, special

    restart
  end

  def check_each_with_index_with_special(special)
    method_name = "each_with_index_with_#{special}_flag"

    @array.send(method_name) do |item, index, is_first|
      add_item item
      add_index index
      add_flag is_first
      increase_yield_counter
    end

    check_special_flag_result_data @array, special, :with_index => true

    restart

    @hash.send(method_name) do |data, index, is_first|
      add_key data[0]
      add_item data[1]
      add_index index
      add_flag is_first
      increase_yield_counter
    end

    check_special_flag_result_data @hash, special, :with_index => true

    restart
  end
end