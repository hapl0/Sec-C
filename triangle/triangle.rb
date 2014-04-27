require 'socket'

@answers = ["what a shame ...","come on! you can do better than that!","nop","MeuleMaster is ashamed of you","yeah that's right, continue to type random letters, it will surely match something one day or another","YEAH!\n\nno just kidding"]

def pascal_calc(row_num, comp)
  return [1] if row_num == 0
  previous = pascal_calc(row_num - 1, nil)
  ret = []
  (previous.length - 1).times do |i|
    to_push = previous[i] + previous[i + 1]
    to_push = (@t.delete(@t.first)) if (previous[i] == previous[i + 1]) && (row_num%2 == 0) && (row_num > 3) && @t.first && row_num == comp
    ret.push to_push
  end
  return [1, ret, 1].flatten
end

def pascal(row_num)
  pascal_calc(row_num - 1, row_num - 1)
end

server = TCPServer.open(8080)
loop {
  IO.select([server])
  Thread.start(server.accept) do |client|
    client.puts "hello, it's simpler than it looks :x, so press any key if you dare:"
    begin
      # @t = [80,84,114,105,52,110,103,108,51]
      @t = [83,48,109,117,67,104,71,101,111,109,51,116,82,121]
      s = ""
      @t.each {|t| s += t.chr}
      client.recvfrom(1)[0].chomp
      client.puts "----------------"
      1.upto(30) do |i|
        row = pascal(i)
        output = ""
        row.each { |n| output+= "#{n} " }
        client.puts output
      end
      client.puts "----------------"
      client.puts "flag? :"
      flag_try = client.recvfrom(20)[0].chomp
      unless flag_try.empty?
        log = "#{Time.now.asctime} ------> #{flag_try}"
        File.open("#{Dir.pwd}/triangle.log", 'a') { |file| file.puts(log) }
        puts "--: #{flag_try}"
      end
      if flag_try == s
        client.puts "CONGRATS!!\nNow go type that in da portal =)"
        return
      else
        client.puts @answers.sample
      end
    rescue e
      puts "Error: #{e}"
    end while true
  end
}