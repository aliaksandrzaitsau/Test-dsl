require 'stringio'
require "minitest/autorun"
require_relative "test_helper"

loaded = get_solution_file(3)

if loaded
  class TestHW2 < Minitest::Test
    def test_true
      assert_equal true, true
    end

    def test_task_3_1_bench_slow
      slow = proc { sleep(2) }
      Timeout::timeout(5) do
        assert_equal 2.0, task_3_1(slow), "should floor accuratelly"
      end
    end

    def test_task_3_1_bench_fast
      fast = proc { 1 }
      Timeout::timeout(5) do
        assert_equal 0.0, task_3_1(fast), "should floor accuratelly"
      end
    end

    def test_task_3_1_bench_accuracy_asc
      slow = proc { sleep(1.59999) }
      Timeout::timeout(5) do
        assert_equal 1.6, task_3_1(slow), "should floor accuratelly"
      end
    end

    def test_task_3_1_bench_accuracy_desc
      slow = proc { sleep(0.5444444) }
      Timeout::timeout(5) do
        assert_equal 0.5, task_3_1(slow), "should floor accuratelly"
      end
    end

    def test_task_3_2_sum
      assert_equal 10, task_3_2([1, 3, 6]), "should calculate sum"
    end

    def test_task_3_2_sum_with_default
      assert_equal 19, task_3_2([1, 3, 6], 9), "should calculate sum with default"
    end

    def test_task_3_2_sum_with_block
      got = task_3_2([1, 3, 6]) { |e| e % 2 }
      assert_equal 2, got, "should calculate sum with block"
    end

    def test_task_3_2_sum_with_block_float
      got = task_3_2([1, 3, 6]) { |e| e + 0.1 }
      assert_equal 10.3, got, "should calculate sum with block"
    end

    def test_task_3_2_sum_with_block_and_default
      got = task_3_2([1, 3, 6], 8) { |e| e % 2 }
      assert_equal 10, got, "should calculate sum with block"
    end

    def test_task_3_3_middle
      assert_equal 556, task_3_3((555..777)), "should find the required number"
    end

    def test_task_3_3_small
      assert_equal 101, task_3_3((1..777)), "should find the first required number"
    end

    def test_task_3_3_negative
      assert_equal 101, task_3_3((-555..777)), "should find the first required number"
    end

    def test_task_3_3_big
      assert_equal 997, task_3_3((991..10_000)), "should find the required number"
    end

    def test_task_3_3_one
      assert_equal 101, task_3_3((101..101)), "should find the required number"
    end

    def test_task_3_3_one_2
      assert_equal 101, task_3_3((101..102)), "should find the required number"
    end

    def test_task_3_4_no_block
      assert_equal "ERROR", task_3_4(1, 1), "should return an error"
    end

    def test_task_3_4_no_block_many
      assert_equal "ERROR", task_3_4(1, 1, 1, 1, 1, 1, 1), "should return an error"
    end

    def test_task_3_4_with_block
      string_io = StringIO.new
      $stdout = string_io
      task_3_4(5, 5, 1, 2) { |e| puts e }
      $stdout = STDOUT
      assert_equal "1\n2\n", string_io.string, "should call a block"
    end

    def test_task_3_4_with_block_2
      init = %w(a b c d e)
      task_3_4(*init) { |e| e.upcase! }
      assert_equal %w(a b C D E), init, "should call a block"
    end


    def test_task_3_4_with_block
      string_io = StringIO.new
      $stdout = string_io
      task_3_4(5, 5) { |e| puts e }
      $stdout = STDOUT
      assert_equal "", string_io.string, "should call a block"
    end

    def test_task_3_5_empty_even
      assert_equal [], task_3_5([1]) { |e| true }, "should be empty"
    end

    def test_task_3_5_empty_condition
      assert_equal [], task_3_5([1, 2, 3]) { |e| false }, "should be empty"
    end

    def test_task_3_5_not_empty
      assert_equal [6], task_3_5([1, 2, 4, 5, 6, 7, 8, 9 , 10]) { |e| e > 4 && e < 8 }, "should not be empty"
    end

    def test_task_3_6_empty
      assert_equal "", task_3_6(""), "empty for empty"
    end

    def test_task_3_6_not_block
      assert_equal "hello\nworld", task_3_6("hello\nworld"), "empty for missing block"
    end

    def test_task_3_6_with_block_empty
      assert_equal [], task_3_6("") { |l| l.include? 'e' }, "empty for empty"
    end

    def test_task_3_6_with_block_filter
      assert_equal [true, false],  task_3_6("hello\nworld") { |line| line.include? 'e' }, "should classify results"
    end

    def test_task_3_6_with_block_filter_take
      assert_equal %w(h m c w),  task_3_6("hello\nmy\ncruel\nworld") { |line| line[0] }, "should classify results"
    end
  end
end
