def run(command, *args)
  unless system(command, *args)
    STDERR.puts("can't run command: #{command} #{args.join(' ')}")
    exit(1)
  end
end
