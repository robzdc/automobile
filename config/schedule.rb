# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 set :output, "log/cron_log.log"
#
 every 1.minute do
   command "echo 'entroee' > texto.txt"
#   runner "Scraping::get_autocompro"
#   rake "some:great:rake:task"
 end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever