puts "\033[31m" + <<-'EOF' + "\033[0m"
                               ____                             __ _  __    ____             
                              / __ \___  ____ ___  _____  _____/ /| |/ /   / __ \___ _   __ 
                             / /_/ / _ \/ __ `/ / / / _ \/ ___/ __|   /   / / / / _ | | / / 
                            / _, _/  __/ /_/ / /_/ /  __(__  / /_/   |   / /_/ /  __| |/ _  
                           /_/ |_|\___/\__, /\__,_/\___/____/\__/_/|_|  /_____/\___/|___(_) 
                           EOF

if (ARGV.length < 3)
    print("[-] Invalid argument type. Usage: <Path> <Output Directory> [--decrypt, --encrypt] [OPTIONS]")
    exit()
end

if (ARGV[3] == "--task-with-dir")
    if !File.directory?(File.expand_path(ARGV[0]))
        print("[-] Input Directory is not found.")
        exit()
    end    
else
    if !File.exists?(ARGV[0])
        print("[-] File not found.")
        exit()
    end

    if !File.file?(ARGV[0])
        print("[-] File is not valid.")
        exit()
    end
    
    if !File.readable?(ARGV[0])
        print("[-] File is not readable.")
        exit()
    end
end

if !File.directory?(File.expand_path(ARGV[1]))
    print("[-] Output Directory is not found.")
    exit()
end

print("[*] %s process started...\n" % (ARGV[2] == "--decrypt" ? "Decryption" : "Encryption"))

firstTime = Time.now

if (ARGV[3] == "--task-with-dir")
    Dir[File.expand_path(ARGV[0] + "\\*")].each do |path|
        cur_file = path
        cur_file_basename = File.basename(path, File.extname(path))
        cur_file_basename_ext = File.basename(path)
        cur_file_size = File.size(cur_file)

        if !File.file?(cur_file)
            print("\033[30m[-] Task Error\n > %s is not valid file.\n\033[0m" % cur_file_basename)
            next
        end

        output_directory = File.expand_path(ARGV[1]) + "/" + cur_file_basename + (ARGV[2] == "--decrypt" ? ".assets" : ".cy")

        print("[*] Current file: %s (%s Bytes)\n" % [cur_file_basename_ext, cur_file_size])
    
        begin
            output_file = File.open(output_directory, 'wb')
            input_file = File.open(cur_file, 'rb')

            if cur_file_size > 268435456
                input_file.each_line.with_index do |line|
                    output_file.write(line.unpack('C*').map{ |a| a ^ 40.ord }.pack('C*'))
                end
            else
                xor_cache = input_file.read.unpack('C*').map{ |a| a ^ 40.ord }.pack('C*')
                output_file.write(xor_cache)
            end
        rescue => e
            print("\033[30m[-] Task Error\n > %s\n\033[0m" % e.message)
        end
    end
else
    output_directory = File.expand_path(ARGV[1]) + "/" + File.basename(ARGV[0], ".*") + (ARGV[2] == "--decrypt" ? ".assets" : ".cy")
    input_file_size = File.size(ARGV[0])
  
    print("[*] Current file: %s.\n" % ARGV[0])
    print("[*] File size: %s Bytes.\n" % input_file_size)

    begin
        input_file = File.open(ARGV[0], 'rb')
        output_file = File.open(output_directory, 'wb')

        if input_file_size > 268435456
            input_file.each_line.with_index do |line|
                output_file.write(line.unpack('C*').map{ |a| a ^ 40.ord }.pack('C*'))
            end
        else
            xor_cache = input_file.read.unpack('C*').map{ |a| a ^ 40.ord }.pack('C*')
            output_file.write(xor_cache)
        end
    rescue => e
        print("\033[30m[-] Task Error\n > %s\n\033[0m" % e.message)
    end
end

print("\n[*] Task is Finished.\n")
print("[*] Elapsed time: %s(s).\n" % (Time.now - firstTime))
