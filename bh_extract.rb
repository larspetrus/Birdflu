def process_data
  File.open("bh_data.txt", "r") do |f|
    algs = selected_algs = 0
    bh_case = shortest = variant = nil

    f.each_line do |line|
      first_word = line.split(' ').first

      unless first_word.nil?
        if first_word.to_i > 0
          bh_case = "h#{first_word}"
          shortest = nil
          variant = 0
        else
          algs += 1
          clean = clean_alg_line(line)
          alg_length = clean.split(' ').first
          shortest ||= alg_length

          alg = trim_alg(clean.gsub(/^[\d ]+/, '')).strip

          if shortest == alg_length || alg_length.to_i <= 10
            suffix = (variant == 0 ? '' : ' bcdefghijk'[variant])
            puts %Q(root_alg('#{bh_case}#{suffix}', "#{alg}"), # #{alg_length})
            selected_algs += 1
            variant += 1
          end
        end
      end
    end

    puts "Printed #{selected_algs} out of #{algs}"
  end
end

def trim_alg(bh_alg)
  bh_alg.gsub!("²", "2")
  ["<", ">","{",/\(.*?\)/, /as.*?}/, " "].each do |d|
    bh_alg.gsub!(d, "")
  end
  %W(L R B F U D).each { |m| bh_alg.gsub!(m, " "+m) }
  bh_alg
end

def clean_alg_line(line)
  line.gsub!(/^\D+/, '')
  line.gsub!('*', '')
  line.gsub!('-', '')
  line
end

# puts trim_alg("<F'B>L'UB'LU'<FB'>RU'BR'")
# puts trim_alg("(U)L²B'<UD'>R'B²U²B²R<U'D>BL²")
# puts trim_alg("B'R'URUR' {U² as U'RB-B'R'U'} R²UR'BR (U'R'-RU) BU'B'R'")
# puts trim_alg("(U')BLUL'U' (B'-B) LU'L'B' (R'UR-R'U'R) U'R'U²R")
#
# puts clean_alg_line("URB,UBL   11 11 3  * (U')B'U'R'UR {B² as B-B} LUL'U'B'")
# puts clean_alg_line("UR,RBL    16 16 5    (U²)RUR²U'R²U'R²U²R²U² (R'-R) BL'BLB²R'")
# puts clean_alg_line("Slices RL 12 9  5  * (U)RB<R'L>F<RL'>B'<R'L>F'L'")
# puts clean_alg_line("")

process_data