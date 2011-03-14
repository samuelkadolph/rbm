require 'optparse'
require 'rbm/benchmarker'

module RBM
  class << self
    def start
      fragments, options = parse_options(ARGV)

      if load_paths = options.delete(:load_paths)
        $LOAD_PATH.concat(load_paths)
      end

      begin
        if requires = options.delete(:requires)
          requires.each { |r| require(r) }
        end
      rescue LoadError => e
        puts e
        exit
      end

      begin
        Benchmarker.new(fragments, options).run
      rescue BenchmarkerSyntaxError => e
        puts e
        exit
      end
    end

    private
      def parse_options(args)
        fragments, options = [], {}
        current_name = nil

        op = OptionParser.new do |op|
          op.banner = "Usage: #{op.program_name} [options] [--name name] code [[-N name] code...]"

          op.separator ''
          op.separator 'Ruby Options:'

          op.on('-r', '--require file[,file]', Array, 'Files to require before benchmarking') do |list|
            (options[:requires] ||= []).concat(list)
          end

          op.on('-I', '--load-path path[,path]', Array, 'Paths to append to $LOAD_PATH') do |list|
            (options[:load_paths] ||= []).concat(list)
          end

          op.separator ''
          op.separator 'Benchmark Options:'

          op.on('-n', '--times N', Integer, 'Number of times to run each code fragment') { |n| options[:times] = n }
          op.on('-p', '--pre code', String, 'Code to run before each code fragment to be benchmarked') { |p| options[:prerun] = p }
          op.on('-N', '--name name', String, 'Names the following code fragment') { |n| current_name = n }

          op.separator ''
          op.separator 'General Options:'

          op.on('-h', '--help', 'Show this message') do
            puts op
            exit
          end
        end
        op.order!(args) do |fragment|
          # block gets run for each non-option argument
          fragments << [current_name || '', fragment]
          current_name = nil
        end

        if fragments.empty?
          puts op
          exit
        end

        [fragments, options]
      end
  end
end
