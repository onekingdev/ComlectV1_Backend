# frozen_string_literal: true

desc 'convert Reminder done_occurences to hash for storing completion date'
task reminder_done_tohash: :environment do
  puts 'Converting reminder done_occurencies into hash'
  Reminder.all.each do |reminder|
    if reminder.done_occurencies == []
      reminder.done_occurencies = {}
    else
      tgt_hash = {}
      reminder.done_occurencies.each do |num|
        begin
          tgt_hash[num] = [reminder.updated_at.in_time_zone(remindable.time_zone), '']
        rescue
          tgt_hash[num] = [reminder.updated_at, '']
        end
      end
      reminder.done_occurencies = tgt_hash
    end
    reminder.save!
  end
  puts 'Done converting'
end
