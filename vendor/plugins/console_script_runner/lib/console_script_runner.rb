# ConsoleScriptRunner

class Script
  
  def self.run(input_path, output_path = nil)
    code = File.open(input_path).readlines.join
    results = eval code
    if output_path
      bytes_written = File.open(output_path, "w") { |file| file.write(results) }
      puts "#{bytes_written} bytes written to output file."
      bytes_written > 0
    else
      results
    end
  end
  
end