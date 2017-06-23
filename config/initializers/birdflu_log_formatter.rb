class ActiveSupport::Logger::SimpleFormatter
  SEVERITY_TO_COLOR_MAP   = {'DEBUG'=>'0;37', 'INFO'=>'32', 'WARN'=>'33', 'ERROR'=>'31', 'FATAL'=>'31', 'UNKNOWN'=>'37'}

  def call(severity, time, progname, msg)
    msg_text = "#{String === msg ? msg : msg.inspect}"
    return nil if msg_text.end_with?("[cache hit]")

    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
    pid = "\033[0;34m#{$$}\033[0m"
    colored_severity = "\033[#{SEVERITY_TO_COLOR_MAP[severity]}m#{sprintf("%-5s", severity)}\033[0m"

    "#{formatted_time} #{pid} #{colored_severity}  #{msg}\n"
  end
end
