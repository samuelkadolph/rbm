module RBM
  class Fragment
    @@unnamed_fragment = "fragment_0"

    attr_reader :code, :name, :prerun, :postrun

    def initialize(code, name = nil, prerun = nil, postrun = nil)
      @code, @name, @prerun, @postrun = code, name, prerun, postrun
    end

    def run(bm, times, init = nil, cleanup = nil)
      fragment_name = (name || @@unnamed_fragment.succ!).gsub(/\s+/, "_")
      binding = Object.new.send(:binding)

      bm.report(name) do
        eval(init, binding, "#{fragment_name}_init", 0) if init
        eval(prerun, binding, "#{fragment_name}_prerun", 0) if prerun
        eval("#{times}.times { #{code} }", binding, "#{fragment_name}", 0)
        eval(postrun, binding, "#{fragment_name}_postrun", 0) if postrun
        eval(cleanup, binding, "#{fragment_name}_cleanup", 0) if cleanup
      end
    end
  end
end
