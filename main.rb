puts "\033[31m" + <<-'EOF' + "\033[0m"
                               ____                             __ _  __    ____             
                              / __ \___  ____ ___  _____  _____/ /| |/ /   / __ \___ _   __ 
                             / /_/ / _ \/ __ `/ / / / _ \/ ___/ __|   /   / / / / _ | | / / 
                            / _, _/  __/ /_/ / /_/ /  __(__  / /_/   |   / /_/ /  __| |/ _  
                           /_/ |_|\___/\__, /\__,_/\___/____/\__/_/|_|  /_____/\___/|___(_) 
                           EOF

if (ARGV.length > 3 || ARGV.length < 3)
    print("[-] Invalid argument type. Usage: <File Path> <Output Directory> [--decrypt, --encrypt]")
    exit()
end

if !File.exists?(ARGV[0])
    print("[-] File not found.")
    exit()
end

if !File.readable?(ARGV[0])
    print("[-] File is not readable.")
    exit()
end

if !File.directory?(File.expand_path(ARGV[1]))
    print("[-] Directory not found.")
    exit()
end

outDir = File.expand_path(ARGV[1]) + "/" + File.basename(ARGV[0], ".*") + (ARGV[2] == "--decrypt" ? ".assets" : ".cy")

outFile = nil
cyFile = nil

print("[*] %s process started...\n" % (ARGV[2] == "--decrypt" ? "Decryption" : "Encryption"))
print("[*] Decrypted file: %s.\n" % ARGV[0])
print("[*] File size: %s Bytes.\n" % File.size(ARGV[0]))

t1 = Time.now

begin
    outFile = File.open(outDir, 'wb')
    cyFile = File.open(ARGV[0], 'rb')
    
    cache = cyFile.read
    xor_cache = cache.unpack('C*').map{ |a| a ^ 40.ord }.pack('C*')
    outFile.write(xor_cache)
rescue => e
    print("\n[-] Failed to Decrypted.. Error: %s\n" % e.message)
ensure
    print("\n[+] Succesfully Decrypted..\n" % File.size(ARGV[0]))
end

t2 = Time.now
delta = t2 - t1

print("[*] Elapsed time: %s(s).\n" % delta)

cyFile.close()
outFile.close()