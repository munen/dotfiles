#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

require 'gpgme'

passwords = GPGME::Crypto.decrypt(File.read("#{Dir.home}/.icloud_credentials.gpg"))

passwords.to_s.each_line do |line|
  if line =~ /^([^ ]+) ([^ ]+)/
    @login = "#{$1}"
    @password = "#{$2}"
  end
end

albums = `docker run -it --rm --name icloud \
    -v /home/munen/Dropbox/_PHOTOS/ALBUMS/:/data \
    -v /home/munen/.icloudpd/cookies:/cookies \
    -e TZ=Europe/Zurich \
    icloudpd/icloudpd:latest \
    icloudpd --directory /data \
    --log-level info \
    --cookie-directory /cookies \
    --username #{@login} \
    --password  #{@password} \
    --size original \
    --list-albums`


status = $?.exitstatus

exit "Quitting due to exit status: '#{status}' and response '#{albums}'" unless status == 0

for album in albums.split
  if album.start_with? "#{Time.new.year}"
    puts ""
    puts "Downloading '#{album}'"

    res = `docker run -it --rm --name icloud \
     -v /home/munen/Dropbox/_PHOTOS/ALBUMS/:/data \
     -v /home/munen/.icloudpd/cookies:/cookies \
     -e TZ=Europe/Zurich \
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
