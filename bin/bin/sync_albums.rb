#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

# https://github.com/icloud-photos-downloader/icloud_photos_downloader

require 'gpgme'

passwords = GPGME::Crypto.decrypt(File.read("#{Dir.home}/.icloud_credentials.gpg"))

passwords.to_s.each_line do |line|
  if line =~ /^([^ ]+) ([^ ]+)/
    @login = "#{$1.strip}"
    @password = "#{$2.strip}"
  end
end

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
  puts line
  albums << line.strip
end

# Close the pipe
docker_pipe.close

status = $?.exitstatus

exit "Quitting due to exit status: '#{status}' and response '#{albums}'" unless status == 0

for album in albums
  if album.start_with? "#{Time.new.year}"
    puts ""
    puts "Downloading '#{album}'"

    res = `docker run -it --rm --name icloud \
     -v /home/munen/Dropbox/_PHOTOS/ALBUMS/:/data \
     -v /home/munen/.icloudpd/cookies:/cookies \
     -e TZ=Europe/Zurich \
     -e USER_ID=$(echo "$UID") \
     icloudpd/icloudpd:latest \
     icloudpd --directory /data \
     --cookie-directory /cookies \
     --folder-structure {:%Y/%m}/#{album} \
     --username #{@login} \
     --password  #{@password} \
     --size original \
     --album #{album}`

    puts res
  end
end
