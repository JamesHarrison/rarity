class Spike::Optimiser
  def initialize(tracker, options)
    @tracker = tracker
    @options = options
  end
  # Optimises a single image
  def optimise_image(path)
    # Tweak commands here if you want to. Defaults are needlessly overzealous and will take ages, especially PNG.
    png_cmd = "optipng -i0 -fix -o#{@options[:png_o_level]} -preserve"
    gif_cmd = "gifsicle -O3"
    jpg_cmd = "jpegoptim --max=95 -p"
    start = Time.now
    start_size = File.size(path)
    if @tracker.is_done?(path, @options)
      puts "Skipping image at #{path}, already done"
    else
      puts "Optimising image at #{path}, start filesize #{Spike::to_human start_size}"
      # let's figure out what we've got
      ext = File.extname(path).downcase
      type = :unknown
      if ext == ".png"
        `#{png_cmd} "#{path}"`
        type = :png
        @tracker.mark_done(path, @options)
      elsif ext == ".gif"
        type = :gif
        # ooh, okay, so if we're a gif, are we animated?
        eto = `exiftool "#{path}"`
        et = eto.split("\n")
        fc = et.detect{|l|l.include?("Frame Count")}
        if fc
          if (fc.split(":")[1].to_i rescue 1) > 0
            # We have more than one frame! We're animated or strange. gifsicle.
            `#{gif_cmd} "#{path}"`
            @tracker.mark_done(path, @options)
          else
            # We're single frame, PNG probably does better
            opo = `#{png_cmd} "#{path}"`
            pngpath = path.gsub(File.extname(path),".png")
            if File.size(path) > File.size(pngpath)
              # We're done! Nuke the old file
              File.delete(path)
              # Changed format, so update path
              path = pngpath
              @tracker.mark_done(path, @options)
            else
              # Clean up the PNG we tried and gifsicle it.
              File.delete(path.gsub(File.extname(path),".png"))
              `#{gif_cmd} "#{path}"`
              @tracker.mark_done(path, @options)
            end
          end
        else
          # If we have no frame count data, assume not animated
          opo = `#{png_cmd} "#{path}"`
          pngpath = path.gsub(File.extname(path),".png")
          if File.size(path) > File.size(pngpath)
            # We're done! Nuke the old file
            File.delete(path)
            # Changed format, so update path
            path = pngpath
            @tracker.mark_done(path, @options)
          else
            # Clean up the PNG we tried and gifsicle it.
            File.delete(path.gsub(File.extname(path),".png"))
            `#{gif_cmd} "#{path}"`
            @tracker.mark_done(path, @options)
          end
        end
      elsif ext == ".jpg" or ext == ".jpeg"
        type = :jpg
        `#{jpg_cmd} "#{path}"`
        @tracker.mark_done(path, @options)
      else
        puts "Skipped file, not a recognised file type"
      end
    end
    return {:before=>start_size, :after=>File.size(path), :type=>type, :time=>(Time.now-start)}
  end
end