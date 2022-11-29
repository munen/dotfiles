#!/usr/bin/env ruby
# coding: utf-8
# frozen_string_literal: true

require 'uri'

MAILTO = ARGV.first

unless MAILTO
  puts 'Usage: mailto.rb [mailto]'
  puts 'For example: "mailto.rb mailto:info@200ok.ch?subject=Your quote"'
  exit 1
end

uri_parsed = URI.parse(MAILTO)

to = uri_parsed.to
subject = uri_parsed&.headers&.to_h['subject']
body = uri_parsed&.headers&.to_h['body']

subject = URI.decode(subject) if subject
body = URI.decode(body) if body

`emacsclient -c --eval \"(progn (mu4e~compose-mail  \\\"#{to}\\\" \\\"#{subject}\\\")(message-goto-body)(next-line)(insert \\\"#{body}\\\"))\"`
