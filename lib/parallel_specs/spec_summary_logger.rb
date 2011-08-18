require 'parallel_specs'
require File.join(File.dirname(__FILE__), 'spec_logger_base')

class ParallelSpecs::SpecSummaryLogger < ParallelSpecs::SpecLoggerBase
  def initialize(options, output=nil)
    super
    @passed_examples = []
    @pending_examples = []
    @failed_examples = []
  end

  def example_passed(example)
    @passed_examples << example
  end

  def example_pending(example)
    @pending_examples << example
  end

  def example_failed(example)
    @failed_examples << example
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    lock_output do
      @output.puts "#{ @passed_examples.size } examples passed"
    end
    @output.flush
  end

  def dump_failure(*args)
    lock_output do
      @failed_examples.each.with_index do | example, i |
        spec_file = example.location.scan(/^[^:]+/)[0]
        spec_file.gsub!(%r(^.*?/spec/), './spec/')
        @output.puts "#{ParallelSpecs.executable} #{spec_file} -e \"#{example.description}\""
      end
    end
    @output.flush
  end
  
end
