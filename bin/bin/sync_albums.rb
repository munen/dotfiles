#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

# https://github.com/icloud-photos-downloader/icloud_photos_downloader

# BEGIN: Get icloud credentials
require 'gpgme'

passwords = GPGME::Crypto.decrypt(File.read("#{Dir.home}/.icloud_credentials.gpg"))

passwords.to_s.each_line do |line|
  if line =~ /^([^ ]+) ([^ ]+)/
    @login = "#{$1.strip}"
    @password = "#{$2.strip}"
  end
end
# END: Get icloud credentials

# BEGIN: Helper methods
def parse_album_name(str)
  year, month, day, description = str.match(/^(\d{4})?-?(\d{2})?-?(\d{2})?_?(.*)?/).captures

  { year: year, month: month, day: day, description: description, title: str }
end

# END: Helper methods


cmd = "docker run -it --rm --name icloud \
    -v /home/munen/.icloudpd/cookies:/cookies \
    -e TZ=Europe/Zurich \
    icloudpd/icloudpd:latest \
    icloudpd \
    --log-level info \
    --cookie-directory /cookies \
    --username #{@login} \
    --password #{@password} \
    --list-albums"

# Open a pipe to the `docker` command
docker_pipe = IO.popen cmd

albums = []

# Read from the pipe in real time, writing each line to stdout
docker_pipe.each do |line|
  albums << parse_album_name(line.strip)
end

# Close the pipe
docker_pipe.close

status = $?.exitstatus

exit "Quitting due to exit status: '#{status}' and response '#{albums}'" unless status == 0

if ARGV[0] == '-l'
  puts "Listing albums:\n\n-----\n"
  albums.each { |album| puts album[:title] }
  exit 0
end

# Reduce down to relevant albums that should be downloaded
albums.select! { |album| album[:year] and album[:month] }

puts "\nDownloading album:"
for album in albums
  folder_structure = if album[:day]
                      "#{album[:year]}/#{album[:month]}/#{album[:day]}/#{album[:description]}"
                    else
                      "#{album[:year]}/#{album[:month]}/#{album[:description]}"
                    end

  puts "'#{album[:title]}' into folder: '#{folder_structure}'"

  cmd = "docker run -it --rm --name icloud \
     --user $(id -u):$(id -g) \
     -v /home/munen/Dropbox/_PHOTOS/by_date/:/data \
     -v /home/munen/.icloudpd/cookies:/cookies \
     -e TZ=Europe/Zurich \
     icloudpd/icloudpd:latest \
     icloudpd --directory /data \
     --cookie-directory /cookies \
     --folder-structure #{folder_structure} \
     --username #{@login} \
     --password  #{@password} \
     --size original \
     --album #{album[:title]}"

  res = `#{cmd}`
  status = $?.exitstatus

  exit "Quitting due to exit status: '#{status}' and response '#{res}'" unless status == 0

  puts res
end
