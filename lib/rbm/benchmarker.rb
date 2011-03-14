require 'benchmark'

module RBM
  class Benchmarker
    DEFAULT_OPTIONS = {
      :times => 1
    }

    attr_reader :options

    def initialize(fragments, options)
      @options = DEFAULT_OPTIONS.merge(options)

      compile_prerun(options[:prerun])
      @fragments = fragments.map { |name, fragment| [name, compile_fragment(fragment, options[:prerun], name)] }
    end

    def run
      width = @fragments.map { |name, method| name.size }.max
      Benchmark.bm(width) do |bm|
        @fragments.each do |name, method|
          bm.report(name) do
            # TODO: wrap errors from fragment execution
            options[:times].times { send(method) }
          end
        end
      end
    end

    private
      def compile_prerun(prerun)
        # TODO:
        #   another way to check prerun syntax outside of compile_fragment so we can
        #   give meaningful syntax errors (error in prerun not in a fragment itself)
        wrap_syntax_errors do
          instance_eval <<-EVAL, "prerun", -1
            def bm_prerun
              #{prerun}
            end
            undef bm_prerun
          EVAL
        end
      end

      def compile_fragment(fragment, prerun = nil, name = nil)
        name = (@fragment_name ||= "fragment_0").succ! unless name && !name.empty?
        fragment_name = "bm_#{name.gsub(/\s+/, '_')}".to_sym
        defined = instance_method(fragment_name) rescue false
        raise "#{fragment_name} is already defined" if defined

        wrap_syntax_errors do
          # TODO: provide better runtime errors and NameError errors and cleaner stack trace
          instance_eval <<-EVAL, name, -1
            def #{fragment_name}
              #{prerun}
              #{fragment}
            end
          EVAL
        end

        fragment_name
      end

      def wrap_syntax_errors
        yield
      rescue SyntaxError => e
        raise(BenchmarkerSyntaxError.new(e.to_s))
      end
  end

  class BenchmarkerSyntaxError < SyntaxError
  end
end