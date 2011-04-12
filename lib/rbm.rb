require "optparse"
require "rbm/benchmarker"
require "rbm/version"

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

      Benchmarker.new(fragments, options).run
    end

    private
      def parse_options(args)
        fragments, options = [], { :requires => [], :load_paths => [] }
        current_name, current_prerun, current_postrun = nil, nil, nil

        op = OptionParser.new do |op|
          op.banner << " [--name name] [--pre code] code [[--name name] [--pre code] code...]"

          op.separator ""
          op.separator "Ruby Options:"

          op.on("-r", "--require file[,file]", Array, "Files to require before benchmarking") { |a| options[:requires].concat(a) }
          op.on("-I", "--load-path path[,path]", Array, "Paths to append to $LOAD_PATH") { |a| options[:load_paths].concat(a) }

          # op.separator ""
          # op.separator "Benchmark Options:"

          op.separator ""
          op.separator "Code Fragment Options:"

          op.on("-n", "--times n", Integer, "Number of times to run each code fragment") { |i| options[:times] = i }
          op.on("-i", "--init code", String, "Code to run before every code fragment") { |s| options[:init] = s }
          op.on("-c", "--cleanup code", String, "Code to run after each code fragment") { |s| options[:cleanup] = s }
          op.on("-N", "--name name", String, "Names the following code fragment") { |s| current_name = s }
          op.on("-p", "--pre code", String, "Code to run before the follow code fragment") { |s| current_prerun = s }
          op.on("-P", "--post code", String, "Code to run after the follow code fragment") { |s| current_postrun = s }

          op.separator ""
          op.separator "General Options:"

          op.on("-v", "--version", "Print the version and exit") do
            puts "RBM #{RBM::VERSION}"
            exit
          end
          op.on("-h", "--help", "Print this message and exit") do
            puts op
            exit
          end
        end
        op.order!(args) do |fragment|
          # block gets run for each non-option argument
          fragments << { :name => current_name, :prerun => current_prerun, :postrun => current_postrun, :fragment => fragment }
          current_name, current_prerun, current_postrun = nil, nil, nil
        end

        if fragments.empty?
          puts op
          exit
        end

        [fragments, options]
      end
  end
end
