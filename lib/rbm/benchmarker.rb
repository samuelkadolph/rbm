require "benchmark"

module RBM
  class Benchmarker
    DEFAULT_OPTIONS = {
      :times => 1
    }

    attr_reader :fragments, :options

    def initialize(fragments, options = {})
      @fragments = fragments
      @options = self.class::DEFAULT_OPTIONS.merge(options)
    end

    def run
      Benchmark.bmbm do |bm|
        fragments.each do |fragment|
          fragment.run(bm, options[:times], options[:init], options[:cleanup])
        end
      end
    end
  end
end