# frozen_string_literal: true

class Util
  def self.duration_to_s(start_time)
    total_seconds = Time.now - start_time
    hours = (total_seconds / 3600).floor
    minutes = ((total_seconds % 3600)/60).floor
    seconds = total_seconds % 60

    decimals = total_seconds < 10 ? '%.4f' : '%.2f'

    [hours > 0 ? "#{hours}h " : '', minutes > 0 ? "#{minutes}m " : '', decimals % seconds, 's'].join
  end
end