
# If you want to use this as a script just copy
# the bash lines and put them as
# system 'cd flags'
# system 'wget ...' and so on

# We start treating the output from the ls
# open the ls output
f = File.new 'file.txt'
# place the file in lines
lines = f.readlines
# map those who have 2 digits codes
lines = lines.select { |line| line.size == 7 }
# get the 2 digits
lines = lines.map { |line| line[0..1] }
f.close

# Then the iso file
# open the iso file
f = File.new 'iso3166_en_code_lists.txt'
# get rid of the notes
f.readline
# place the file in iso
iso = f.readlines
# create a new hash
hashed_iso = {}
# select non empty lines
iso.select { |a| !a.rstrip.empty? }.map do |b|
  # remove the whitespaces and split in ';'
  aux = b.rstrip.split ';'
  # place info in the hash
  hashed_iso[aux[1].downcase] = aux[0].capitalize
end
f.close

# Now we cross information giving more
# importance to what's in the iso.
iso_famfamfam = hashed_iso.select {
  # select those who have flags in famfamfam
  |k,v| lines.member? k
}.sort_by {
  # sort them by the name the user will see
  |pair| pair[1]
}

# Now we create the contents to store in the yaml file
# create the yaml first line
yaml_lines = "hash: \n"
iso_famfamfam.each do |pair|
  # for each pair, create the yaml
  # representation and put in yaml_lines
  yaml_lines << '  ' + pair[0] + ': ' + pair[1] + "\n"
end 

yaml_lines << "array: ---\n"

iso_famfamfam.each do |pair|
  yaml_lines << '- - ' + pair[0] + "\n  - " + pair[1] + "\n"
end 

# put it in a file
f = File.new 'flags.yml', 'w'
f.write yaml_lines
f.close

#sample for loading the yaml into ruby
#f = File.new 'flags.yml'
#fy = YAML.load f