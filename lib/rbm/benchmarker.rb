require 'benchmark'

module RBM
  class Benchmarker
    DEFAULT_OPTIONS = {
      :times => 1
    }

    attr_reader :fragments, :options

    def initialize(fragments, options)
      @fragments, @options = fragments, DEFAULT_OPTIONS.merge(options)
    end

    def run
      width = fragments.map { |fragment| (fragment[:name] || "").length }.max
      Benchmark.bm(width) do |bm|
        fragments.each do |fragment|
          name = fragment[:name] || ""
          fragment_name = (fragment[:name] || (@unnamed_fragment ||= "fragment_0").succ!).gsub(/\s+/, "_")

          object = Object.new
          binding = object.send(:binding)

          bm.report(name) do
            eval options[:init], binding, "init", 1 if options[:init]
            eval fragment[:prerun], binding, "#{fragment_name}_prerun", 1 if fragment[:prerun]
            eval <<-EVAL, binding, fragment_name, 0
              #{options[:times]}.times do
                #{fragment[:fragment]}
              end
            EVAL
            eval fragment[:postrun], binding, "#{fragment_name}_postrun", 1 if fragment[:postrun]
            eval options[:cleanup], binding, "cleanup", 1 if options[:cleanup]
          end
        end
      end
    end
  end
end