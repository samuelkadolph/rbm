# Ruby Benchmark

rbm is a command line tool for doing quick benchmarks of ruby code.

# Installing

## Recommended

    gem install rbm

## Edge

    git clone https://github.com/samuelkadolp/rbm.git
    cd rbm && rake install

# Usage

Using rbm is quite simple. Just pass in each code fragment you want to test as a separate argument.

    rbm "sleep 1" "sleep 5"

You can specify the number of times to loop. You can also provide a code fragment to be run before each time each code fragment is run.

    rbm --times 100 "sleep 0.01"
    rbm --prerun "n = 5" "sleep n"

You may provide a name to each code fragment to be displayed on the benchmark.

    rbm --name "sleep for 5" "sleep 5" --name "sleep for 2" "sleep 2"

You can see the full usage statement at any time with `rbm --help`

    Usage: rbm [options] [--name name] code [[-N name] code...]

    Ruby Options:
        -r, --require file[,file]        Files to require before benchmarking
        -I, --load-path path[,path]      Paths to append to $LOAD_PATH

    Benchmark Options:
        -n, --times N                    Number of times to run each code fragment
        -p, --pre code                   Code to run before each code fragment to be benchmarked
        -N, --name name                  Names the following code fragment

    General Options:
        -h, --help                       Show this message
