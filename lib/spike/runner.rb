class Spike::Runner
  def initialize(options)
    @directory = options[:directory]
    @tracker = Spike::Tracker.new
    @optimiser = Spike::Optimiser.new(@tracker, {:png_o_level => options[:pnglevel]})
  end
  def run
    recursively_optimise(@directory)
  end
  # Recursively optimises a given path
  def recursively_optimise(path,depth=0)
    raise ArgumentError, "Argument must be a directory" unless File.directory?(path)
    puts "Called with #{path}"
    total_before = 0
    total_after = 0
    total_before_types = {}
    total_after_types = {}
    total_time_types = {}
    begin
      # Call ourself on any directories in this path
      Dir.foreach(path) do |entry|
        next if entry == "."
        next if entry == ".."
        fullpath = File.join(path, entry)
        if File.directory?(fullpath)
          res = self.recursively_optimise(fullpath, (depth+1))
          total_before += res[:before]
          total_after += res[:after]
          #if res[:before_types] and res[:after_types]
            res[:before_types].each_pair do |k,v|
              total_before_types[k] = 0 unless total_before_types[k]
              total_before_types[k] += v
            end
            res[:after_types].each_pair do |k,v|
              total_after_types[k] = 0 unless total_after_types[k]
              total_after_types[k] += v
            end
            res[:time_types].each_pair do |k,v|
              total_time_types[k] = 0 unless total_time_types[k]
              total_time_types[k] += v
            end
          #end
        else
          res = @optimiser.optimise_image(fullpath)
          total_before += res[:before]
          total_after += res[:after]
          total_before_types[res[:type]] = 0 unless total_before_types[res[:type]]
          total_before_types[res[:type]] += res[:before]
          total_after_types[res[:type]] = 0 unless total_after_types[res[:type]]
          total_after_types[res[:type]] += res[:after]
          total_time_types[res[:type]] = 0 unless total_time_types[res[:type]]
          total_time_types[res[:type]] += res[:time]
        end
      end
    rescue Exception => e
      puts "Got exception #{e.inspect} while processing!"
      puts e.backtrace
    end
    if depth == 0
      puts "\n\nDone optimising everything!"
      puts "I started with a total size of #{Spike::to_human total_before}"
      puts "I finished with a total size of #{Spike::to_human total_after}, a reduction of #{Spike::to_human (total_before-total_after).abs}"

      puts"\nType breakdowns:"
      total_before_types.each_pair do |k,v|
        a = total_after_types[k]
        t =  total_time_types[k]
        puts "#{k.to_s.upcase}: #{Spike::to_human v} before, #{Spike::to_human a} after, reduction of #{Spike::to_human (v-a).abs} or #{Spike::to_human (((v-a).abs)/t.abs)} per second saved"
      end
    end
    return {:before => total_before, :after => total_after, :before_types => total_before_types, :after_types => total_after_types, :time_types => total_time_types}
  end
  
end