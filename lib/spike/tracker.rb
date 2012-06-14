require 'sequel'
class Spike::Tracker

  def initialize
    @db_path = File.expand_path("~/.spike.sqlite")
    @first_run = !File.exists?(@db_path)
    @db = Sequel.sqlite(@db_path)
    if @first_run
      @db.create_table :images do
        primary_key :id
        String :path
        Integer :png_o_level
      end
    end
  end
  def import_from_old_format
    @path = File.expand_path("~/.optimdone.dat")
    @done = []
    File.open(@path,'r'){|f|@done = f.read.split("\n")} rescue nil
    for r in @done
      @db[:images].insert(:path=>r, :png_o_level=>3)
    end
    puts "Imported #{@done.size} entries that we have already optimised from the old land, you can now delete ~/.optimdone.dat"
  end
  def mark_done(path, options)
    cleanpath = path.gsub("\n","").gsub("\r","").chomp
    if !is_done?(path, options)
      if @db[:images][:path=>cleanpath]
        @db[:images][:path=>cleanpath] = {:png_o_level => options[:png_o_level]}
      else
        @db[:images].insert(:path=>cleanpath, :png_o_level=>options[:png_o_level])
      end
    end
  end
  def is_done?(path, options)
    cleanpath = path.gsub("\n","").gsub("\r","").chomp
    if @db[:images].select(:id, :png_o_level).where(:path=>cleanpath).filter('png_o_level >= ?',options[:png_o_level]).count > 0
      return true
    end
    return false
  end
  def reset
    @db[:images].delete
  end

end