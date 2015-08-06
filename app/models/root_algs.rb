class RootAlgs

  def self.unique_variants(moves)
    reverse_alg = BaseAlg.reverse(moves)
    variants = {
         a: Cube.new(moves).standard_ll_code,
        Ma: Cube.new(BaseAlg.mirror(moves)).standard_ll_code,
        Aa: Cube.new(reverse_alg).standard_ll_code,
        AMa:Cube.new(BaseAlg.mirror(reverse_alg)).standard_ll_code,
    }
    unique_variants = []
    seen = Set.new
    variants.each do |variant, ll_code|
      unique_variants << variant if seen.add? ll_code
    end

    unique_variants
  end

  def self.root_alg(name, moves)
    OpenStruct.new(name: name, moves: moves, variants: unique_variants(moves))
  end


  def self.all
    [
        root_alg('h435', "B' U' R' U R B"), # 6

        root_alg('Niklas', "L' U R U' L U R'"), # 7 #h556
        root_alg('h181', "L' B' R B' R' B2 L"), # 7
        root_alg('Sune', "R' U' R U' R' U2 R"), # 7 #h213

        root_alg('h918', "R B2 L' B2 R' B L B'"), # 8
        root_alg('h304', "B' R' U R B L U' L'"), # 8
        root_alg('h518b', "B L B' R B L' B' R'"), # 8
        root_alg('Clix', "L' B' R B L B' R' B"), # 8 #h518
        root_alg('h1161', "R' U' R U R B' R' B"), # 8
        root_alg('h347', "B' U' B' R B R' U B"), # 8
        root_alg('h17', "B U B2 R B R2 U R"), # 8

        root_alg('h304c', "B U B' R' U2 R B U' B'"), # 9
        root_alg('h117', "B' R' B2 D2 F2 L' F2 D2 B'"), # 9
        root_alg('h117b', "B' L' D2 F2 U2 R' F2 D2 B'"), # 9
        root_alg('h468', "B U2 B' R B' R' B2 U2 B'"), # 9
        root_alg('h187', "B' R B2 L' B2 R' B2 L B'"), # 9
        root_alg('Czeslaw', "B' R2 B' L2 B R2 B' L2 B2"), # 9 #h568
        root_alg('Arneb', "F2 R2 L2 B2 D' F2 R2 L2 B2"), # 9 #h31b
        root_alg('Arne', "B2 R2 L2 F2 D' F2 R2 L2 B2"), # 9 #h31
        root_alg('h787', "R U2 R D L' B2 L D' R2"), # 9
        root_alg('h534', "R U2 R D R' U2 R D' R2"), # 9
        root_alg('Allan', "R2 U F B' R2 F' B U R2"), # 9 #h113
        root_alg('h806', "B' U' R U B U' B' R' B"), # 9
        root_alg('h484', "B2 L2 B R B' L2 B R' B"), # 9
        root_alg('h347b', "B' R' U' R B U' B' U2 B"), # 9
        root_alg('h304b', "B' R' U R U2 R' U' R B"), # 9
        root_alg('h886', "L2 B2 R B R' B2 L B' L"), # 9
        root_alg('h806b', "R L' U B U' B' R' U' L"), # 9
        root_alg('h442', "L' B2 R D' R D R2 B2 L"), # 9
        root_alg('h347c', "L' B2 R B R' U' B U L"), # 9
        root_alg('Bruno', "R U2 R2 U' R2 U' R2 U2 R"), # 9 #h183

        root_alg('h1004', "R U B U' L B' R' B L' B'"), # 10
        root_alg('h846', "R' B U L U' B' R B L' B'"), # 10
        root_alg('h32', "R' U2 R U B L U2 L' U' B'"), # 10
        root_alg('h519', "B U2 B2 U' R' U R B2 U' B'"), # 10
        root_alg('h933', "R D L' B L D' R' B U' B'"), # 10
        root_alg('h1134', "R L' B' R' B L U2 B U2 B'"), # 10
        root_alg('h942b', "B R' U2 R B2 L' B2 L U2 B'"), # 10
        root_alg('h942c', "B R' U2 L U2 L' U2 R U2 B'"), # 10
        root_alg('h942d', "B L' B2 L B2 R' U2 R U2 B'"), # 10
        root_alg('h1126', "L2 B2 R B R' B L2 F U2 F'"), # 10
        root_alg('h655', "L2 D' B D' R2 B' D2 L2 U F'"), # 10
        root_alg('h942', "R U2 L B L' U2 L B' R' L'"), # 10
        root_alg('h442d', "B' R' U' R B2 L' B' L2 U' L'"), # 10
        root_alg('h116', "R B L' B' R' L U L U' L'"), # 10
        root_alg('h1112', "B L2 B2 R B' R' B2 L' U2 L'"), # 10
        root_alg('h371', "B' R B' R' B' L' B' L2 U2 L'"), # 10
        root_alg('Buffy', "L U2 L' U2 R' U L U' R L'"), # 10 #h1125
        root_alg('h116b', "B L' B' R' L U L U' R L'"), # 10
        root_alg('h832', "B U L U' B' R B L' B' R'"), # 10
        root_alg('h179', "R B R' L U L' U' R B' R'"), # 10
        root_alg('h48', "R U B U' L U' L' U B' R'"), # 10
        root_alg('h971', "R U B U2 B' U B U B' R'"), # 10
        root_alg('h275', "R B L' B L B' U B' U' R'"), # 10
        root_alg('h208', "R B U B' U' B U B' U' R'"), # 10
        root_alg('h904', "R B2 D B' U B D' B2 U' R'"), # 10
        root_alg('h50', "R B U B' R B' R' B U' R'"), # 10
        root_alg('h569', "R B' U' B2 U' B2 U2 B U' R'"), # 10
        root_alg('h442c', "L' U2 R U' R' U2 R L U' R'"), # 10
        root_alg('h275b', "R B U B' U R' U' R U' R'"), # 10
        root_alg('h1076', "B' R B U B' R' B R U' R'"), # 10
        root_alg('h1153b', "B' R' U' R2 U R' B R U' R'"), # 10
        root_alg('h615', "B' R B' D2 F L' F' D2 B2 R'"), # 10
        root_alg('h464', "R B2 R2 L U L' U' R2 B2 R'"), # 10
        root_alg('h604', "B' R U2 R' B R B' U2 B R'"), # 10
        root_alg('h610', "R2 D' F2 D R2 B2 D L2 D' B2"), # 10
        root_alg('h405', "B2 R2 B' L U L' U' B R2 B2"), # 10
        root_alg('h370', "R L' B L' B' D' B D R' L2"), # 10
        root_alg('h610b', "B2 D' R2 U R2 B2 D L2 U' L2"), # 10
        root_alg('h341', "L2 B2 R B' D' B D R' B2 L2"), # 10
        root_alg('h1206', "B L' B L B2 U2 R B' R' B"), # 10
        root_alg('h942f', "R' U2 R2 B2 L' B' L B2 R' B"), # 10
        root_alg('h942e', "L U2 L2 B2 R B' L B2 R' B"), # 10
        root_alg('h434', "R U2 R' B' U R U R' U' B"), # 10
        root_alg('h1153', "B' U' R' U2 R U R' U' R B"), # 10
        root_alg('h644', "L' B L B' U' B' R' U R B"), # 10
        root_alg('h833', "B' R B U B' U' R2 U R B"), # 10
        root_alg('h1125b', "R U2 R' U' B' R U' R' U B"), # 10
        root_alg('h167', "L' U R' U' R2 D B2 D' R' L"), # 10
        root_alg('h931', "L' U R B2 U B2 U' B2 R' L"), # 10
        root_alg('h932', "B U B' U' L' B' R B R' L"), # 10
        root_alg('h976', "R L' U' B' U B U R' U' L"), # 10
        root_alg('h894', "B' R' B L' B' R2 B' R' B2 L"), # 10
        root_alg('h442b', "L' U2 R L U' L' U R' U2 L"), # 10
        root_alg('h1113', "R U' L' U R' U2 B' U B L"), # 10
        root_alg('h775', "L' U R' U' R L U2 R' U' R"), # 10
        root_alg('h769', "R' L' U2 R U R' U2 L U' R"), # 10

        root_alg('h794', "R B' R' B U2 B U' L U' L' B'"), # 11
        root_alg('h487', "B2 U B R B R2 U R2 B R' B'"), # 11
        root_alg('h283', "R' U2 R U B U2 L U2 L' U' B'"), # 11
        root_alg('h268', "R' U2 R B2 L' B' L2 U L' U' B'"), # 11
        root_alg('h1045', "R B L' B' R' B L2 U L' U' B'"), # 11
        root_alg('h564b', "R B2 L' B2 R' B L2 U L' U' B'"), # 11
        root_alg('h221', "B' U' R' U R B2 L U L' U' B'"), # 11
        root_alg('h64', "B' R' U' R U B2 L U L' U' B'"), # 11
        root_alg('h570', "R' U2 R2 U B U' B2 R' B2 U' B'"), # 11
        root_alg('h247', "R D L' B' L D' R' U2 B U' B'"), # 11
        root_alg('h138', "R' F' U F R B2 L' B' L U' B'"), # 11
        root_alg('h145', "B L2 F2 D2 R' D' R D' F2 L2 B'"), # 11
        root_alg('h161', "B U2 B2 R2 D' R' D R' B2 U2 B'"), # 11
        root_alg('h49', "B' U' R2 D' R' D R' U B2 U2 B'"), # 11
        root_alg('h274c', "B U2 B' U' R' U2 R U B U2 B'"), # 11
        root_alg('h571', "B U2 B' U' R' U R U B U2 B'"), # 11
        root_alg('h607', "B D' B2 U R' U' R U' B2 D B'"), # 11
        root_alg('h290', "B D' B2 U R' U2 R U' B2 D B'"), # 11
        root_alg('h381', "B D' B2 U2 R' U R U B2 D B'"), # 11
        root_alg('h53', "B R' D2 R B' U' B R' D2 R B'"), # 11
        root_alg('h11', "B R' D2 R B' U2 B R' D2 R B'"), # 11
        root_alg('h80', "B R' U2 L F' U2 F L' U2 R B'"), # 11
        root_alg('h612', "B2 L' B' L B' R' U' R B U B'"), # 11
        root_alg('h1178', "L' U R B L' B' R' L2 F U' F'"), # 11
        root_alg('h294', "L2 D' R B' R' D L2 U F U F'"), # 11
        root_alg('h1038', "L F2 R2 B' R F' R' B R2 F' L'"), # 11
        root_alg('h438', "L F R2 L' B' R' B R' L F' L'"), # 11
        root_alg('h441', "B' U2 B L F R U R' U F' L'"), # 11
        root_alg('h720b', "R U B' U' B R' L F U F' L'"), # 11
        root_alg('h929', "L U' B' R2 D' F D R2 B U' L'"), # 11
        root_alg('h216', "B' R' F' U2 F R B U' L U' L'"), # 11
        root_alg('h609b', "R' F2 L2 D2 R' B' L' D2 R2 F2 L'"), # 11
        root_alg('h609c', "L F2 R2 D2 L B' L' D2 R2 F2 L'"), # 11
        root_alg('h345', "L' B2 D' R2 D' R2 D2 B2 L2 U2 L'"), # 11
        root_alg('h308b', "L U2 L' B' R' U2 R B L U2 L'"), # 11
        root_alg('h1150', "L2 F2 R2 B' D2 B R2 F L' F L'"), # 11
        root_alg('h1028', "L' B' R B R' L2 U' R' U R L'"), # 11
        root_alg('h1212', "L U' L2 D' R B R' D L2 U L'"), # 11
        root_alg('h308', "R B L U2 L' U2 L U2 L' B' R'"), # 11
        root_alg('h573', "B' U2 B U R B' U B2 U' B' R'"), # 11
        root_alg('h251', "R B2 L' B' L B' U B U' B' R'"), # 11
        root_alg('h351', "R B L' B L B2 U B U' B' R'"), # 11
        root_alg('h1164', "R U2 B' R' U' R U B2 U2 B' R'"), # 11
        root_alg('h203', "R B2 L' B' L B L' B' L B' R'"), # 11
        root_alg('h106', "R B R' U2 L U2 L' U2 R B' R'"), # 11
        root_alg('h106b', "R B L' B2 L B2 R' U2 R B' R'"), # 11
        root_alg('h720', "R B L U' L' B' U' B U B' R'"), # 11
        root_alg('h533', "R B2 U L' U' B' U L B' U' R'"), # 11
        root_alg('h504', "B L' B' R B2 L B' U B' U' R'"), # 11
        root_alg('h1154', "B U B' U' B' R B2 U B' U' R'"), # 11
        root_alg('h564', "B U2 B' U2 B' R B2 U B' U' R'"), # 11
        root_alg('h253', "R U2 R' U' R U' B U B' U' R'"), # 11
        root_alg('h274', "R U2 R' U' R B' R B R' U' R'"), # 11
        root_alg('h175', "R U2 R2 U2 R2 U R2 U R2 U' R'"), # 11
        root_alg('h1029', "R U' B' U2 L' B L U2 B U' R'"), # 11
        root_alg('h1137', "R L' D' B' D L B' U B U' R'"), # 11
        root_alg('h274b', "B U2 B' U2 B' U' R U B U' R'"), # 11
        root_alg('h180', "R B' D' B' D2 F L2 F' D' B2 R'"), # 11
        root_alg('h1032', "B' R2 D' F2 R' D2 B' L' D' B2 R'"), # 11
        root_alg('h163', "R B2 R2 U2 B' U' B U' R2 B2 R'"), # 11
        root_alg('h555', "R B2 R2 U2 R B' R' U2 R2 B2 R'"), # 11
        root_alg('h288', "R B2 R2 U2 R B2 R' U2 R2 B2 R'"), # 11
        root_alg('h770', "R' F' R' F R' D2 L B' L' D2 R'"), # 11
        root_alg('h921', "R' U' R2 B U B' R2 U R2 U2 R'"), # 11
        root_alg('h106c', "R U2 L' B L U2 L' B' L U2 R'"), # 11
        root_alg('h624', "F' L' U2 B L' B' L2 F R U2 R'"), # 11
        root_alg('h762', "B U L' B L B2 U' B' R B R'"), # 11
        root_alg('h762b', "B U2 B2 R B R' U2 B' R B R'"), # 11
        root_alg('h992', "L' U B U B' U' L B' R B R'"), # 11
        root_alg('h225', "L' B L U2 B' U2 B' U2 R B R'"), # 11
        root_alg('h788', "B U2 B2 U2 L' B' L U2 R B R'"), # 11
        root_alg('h908', "B' U2 B U R B' R' U R B R'"), # 11
        root_alg('h364', "R F' L2 B' D' B' D B2 L2 F R'"), # 11
        root_alg('h607b', "R U' B2 D B' U' B D' B2 U R'"), # 11
        root_alg('h290b', "R U' B2 D B' U2 B D' B2 U R'"), # 11
        root_alg('h795', "R L' B2 U B2 U' B2 U' L U R'"), # 11
        root_alg('h739', "R2 L' D B' D' B' R' B L U R'"), # 11
        root_alg('h574', "R U B U B' U' R' U2 R U R'"), # 11
        root_alg('h277', "B2 L D2 L' B2 U2 B2 R F2 R' B2"), # 11
        root_alg('h1031', "B' R F R2 F B' L D2 L' F2 B2"), # 11
        root_alg('h122', "B' R B' R2 U R U R' U' R B2"), # 11
        root_alg('h948', "R U R' U F2 L' B L' B' L2 F2"), # 11
        root_alg('h835', "F U2 F L2 D B' R2 B D' L2 F2"), # 11
        root_alg('h219', "L2 B2 R B' L B' L' B2 R' B2 L2"), # 11
        root_alg('h141', "L2 B2 L' F2 R' F' R F' L B2 L2"), # 11
        root_alg('h633', "L' U' L U' L2 D' R B2 R' D L2"), # 11
        root_alg('h811', "R U2 R' U' R2 D R' U' R D' R2"), # 11
        root_alg('h1043', "R' U' R U' R2 D' R U2 R' D R2"), # 11
        root_alg('h342b', "B2 U' B R B' U B2 U' B' R' B"), # 11
        root_alg('h1060', "R' U2 R2 U R' U R U2 B' R' B"), # 11
        root_alg('h522', "R U2 R2 U' R U R U2 B' R' B"), # 11
        root_alg('h1016b', "L' B2 R2 D' R' D B2 L B' R' B"), # 11
        root_alg('h1016', "L' B' U R' U' R2 B L B' R' B"), # 11
        root_alg('h1008', "R B' U2 D L B' L' U2 D' R' B"), # 11
        root_alg('h1159', "R B2 D2 F L' F' D' B D' R' B"), # 11
        root_alg('h982b', "L' B2 R2 D2 R' D2 B' L B2 R' B"), # 11
        root_alg('h982', "R B2 L2 D2 L D2 B' L B2 R' B"), # 11
        root_alg('h723b', "R' L2 D F D' R L2 U' B' U' B"), # 11
        root_alg('h968', "B' U' R' U2 L U' R U L' U' B"), # 11
        root_alg('h812', "L' D' R B' R' D L U' B' U2 B"), # 11
        root_alg('h346', "L' D' R B R' D L U B' U2 B"), # 11
        root_alg('h1129', "B L U' L' B2 D' F R F' D B"), # 11
        root_alg('h642', "B2 U' R B R' L' D' B D L B"), # 11
        root_alg('h311', "B' R B' R' B2 U' B' R' U' R B"), # 11
        root_alg('h139', "L U2 L' U' B' R' F' U' F R B"), # 11
        root_alg('h915', "B' R U R2 U R2 U2 R2 U R B"), # 11
        root_alg('h19', "B' U2 B U B2 R B R2 U R B"), # 11
        root_alg('h420', "L F2 R' F' R U' F' L' B' U B"), # 11
        root_alg('h383', "B' U' R' U R U2 B U B' U B"), # 11
        root_alg('h311b', "B' R' U R B L' B L B2 U B"), # 11
        root_alg('h309', "F2 L F' D2 B R' B' D2 F2 L' F"), # 11
        root_alg('h328', "F' R B2 L B' L2 B L' B2 R' F"), # 11
        root_alg('h936', "F' U2 R B2 D L2 D' B2 R' U' F"), # 11
        root_alg('h211', "R' L' U2 R B2 L2 F' L B2 L2 F"), # 11
        root_alg('h219b', "F' L2 F2 B2 R B R' F2 B L2 F"), # 11
        root_alg('h1185', "R2 D L' B' L D' R2 U' F' U2 F"), # 11
        root_alg('h726', "R U2 R' F' L' U B' U2 B L F"), # 11
        root_alg('h439', "F D2 B2 R B2 D2 F2 U' L U F"), # 11
        root_alg('h214', "R2 L' B2 R' B' R B' R' B' R' L"), # 11
        root_alg('h306', "R B L' D' R' B' R D B' R' L"), # 11
        root_alg('h168', "R L2 B' L B' L' B2 L B' R' L"), # 11
        root_alg('h52', "R L2 B' L B' R' U2 R B' R' L"), # 11
        root_alg('h214b', "B U2 B' U' R L' D B' D' R' L"), # 11
        root_alg('h992c', "L' U R D' B U B' U' D R' L"), # 11
        root_alg('h642b', "L2 D' R B R' D B L B' U' L"), # 11
        root_alg('h571b', "R L' U R' B' R U' R' B U' L"), # 11
        root_alg('h1011', "R' U2 R L' U B2 U B2 U' B2 L"), # 11
        root_alg('h137', "R U R' U L' B' R2 B' R2 B2 L"), # 11
        root_alg('h723', "R U' B' R B L' D B D' R2 L"), # 11
        root_alg('h448', "L' U' L U' R U' L' U R' U2 L"), # 11
        root_alg('h865b', "L2 B2 R B' R' B2 L2 U2 L' B L"), # 11
        root_alg('h1158', "L U2 L' B2 R B2 L' B' R' B L"), # 11
        root_alg('h1077', "L2 D' R B R' D L B' U' B L"), # 11
        root_alg('h19b', "R L' B2 D B D2 R D R2 B L"), # 11
        root_alg('h199', "L B' U' R' U B L2 B' R B L"), # 11
        root_alg('h666', "L2 B2 R B2 L B' R2 U2 R B L"), # 11
        root_alg('h865', "L2 B2 R B' L B2 R2 U2 R B L"), # 11
        root_alg('h796', "R' B L2 F L' F' L F' L2 B' R"), # 11
        root_alg('h172', "R' U2 B' D' R2 D B2 U' B' U' R"), # 11
        root_alg('h992b', "B2 L' B' L2 U2 L' U B' R' U' R"), # 11
        root_alg('h342', "B' R B R' B U2 B' U' R' U' R"), # 11
        root_alg('h297', "R' U R2 D L' B2 L D' R2 U' R"), # 11
        root_alg('h1035', "R2 D L B2 L D2 R D' L2 D2 R"), # 11
        root_alg('h609', "L F2 R2 D2 L B' R D2 L2 F2 R"), # 11
        root_alg('h595', "R' U R U B U2 B' U2 R' U2 R"), # 11
        root_alg('h209', "R D B' U B' U' B D' R2 U2 R"), # 11
        root_alg('h19c', "R' L U L2 B L B2 U B U2 R"), # 11
        root_alg('h656', "R' U2 B L2 D F D' L2 B' U R"), # 11
        root_alg('h47', "R U2 R2 U' R2 U' R' U R' U R"), # 11
        root_alg('h197', "R' U2 R U R' U' R U R' U R"), # 11
        root_alg('h1019', "L U' R' U L' U R U R' U R"), # 11

        root_alg('h1078', "R' U2 B L B' R F B U2 F' L' B'"), # 12
        root_alg('h809', "L' D2 R2 B' R2 D2 L B L F' L' B'"), # 12
        root_alg('h808', "R B L B' R' B U' F U F' L' B'"), # 12
        root_alg('h93', "R' F' U' F R2 B' R' B2 L U' L' B'"), # 12
        root_alg('h800', "B U2 B' U' R' U R B L U' L' B'"), # 12
        root_alg('h92b', "B U R' L U L' U' R L U' L' B'"), # 12
        root_alg('h512', "B L U2 B' R2 D' F D R2 B L' B'"), # 12
        root_alg('h269', "B L2 D' B2 U' R' U' R B2 D L' B'"), # 12
        root_alg('h465', "B' U' R' U R B2 L2 F' L' F L' B'"), # 12
        root_alg('h536', "B U L2 D R' F2 R D' L' U L' B'"), # 12
        root_alg('h307b', "B U2 R D B D' R' B U' B' U' B'"), # 12
        root_alg('h527', "R' U' R2 B2 L2 B R' B' L2 B' U' B'"), # 12
        root_alg('h252c', "B' R B2 L' B2 R' B2 L2 U L' U' B'"), # 12
        root_alg('h471b', "R' U' R2 B' R' B2 U' L U L' U' B'"), # 12
        root_alg('h741', "B R U B R B R' B' U' R' U' B'"), # 12
        root_alg('h1105b', "R' U' R B U B' R B' R' B2 U' B'"), # 12
        root_alg('h949', "B U L' B2 R B' L B R' B2 U' B'"), # 12
        root_alg('h2b', "B U2 B2 U' D' R' U R D B2 U' B'"), # 12
        root_alg('h585', "B' U' R2 D' R' D R2 U R B2 U' B'"), # 12
        root_alg('h446', "B' R' U' R U B2 U2 B' U' B U' B'"), # 12
        root_alg('h155', "R' U' R2 B' R' B2 U B' U' B U' B'"), # 12
        root_alg('h276', "R' F' U L' U L F R U' B U' B'"), # 12
        root_alg('h242', "R' F' L' U2 L F U R U2 B U' B'"), # 12
        root_alg('h597d', "R D L' B L D' R2 U' R B U' B'"), # 12
        root_alg('h621b', "R D L' B L D' R2 U R B U' B'"), # 12
        root_alg('h773', "L2 B L D2 R L F' L' F2 R' D2 B'"), # 12
        root_alg('h957', "B2 R2 B' U L U' L B R2 B' L2 B'"), # 12
        root_alg('h133', "R' U2 R B2 L' B' L2 F' L F L2 B'"), # 12
        root_alg('h307', "L B U B' L' B U R B' R' U2 B'"), # 12
        root_alg('h969', "B U' R U' B2 U' B2 U B2 R' U2 B'"), # 12
        root_alg('h632', "R2 F2 L F L' F R' B' R' B2 U2 B'"), # 12
        root_alg('h143', "B L U L' U B' R B' R' B2 U2 B'"), # 12
        root_alg('h354', "B' R' U' R' D' R' D R' U B2 U2 B'"), # 12
        root_alg('h793', "B' R2 D' R U' R2 D R' U B2 U2 B'"), # 12
        root_alg('h252', "B' R' U' R U' B2 U B2 U B2 U2 B'"), # 12
        root_alg('h523b', "B' U' B R B' R' U B U2 B U2 B'"), # 12
        root_alg('h142', "R D L' B' L D' R2 U' R B U2 B'"), # 12
        root_alg('h979', "B2 D' B2 U2 B' R2 U R2 U B2 D B'"), # 12
        root_alg('h394b', "B D' R2 U D L U' L' D' R2 D B'"), # 12
        root_alg('h1147', "B L2 F R B' U2 B R' F2 L F B'"), # 12
        root_alg('h36', "R U2 R2 U' R2 U' R' B2 L' B' L B'"), # 12
        root_alg('h191', "R' U' R U2 B2 U L U' L2 B' L B'"), # 12
        root_alg('h940', "R B U B' U' B L' B' R' B L B'"), # 12
        root_alg('h977', "B' L' B' L2 U2 L' U B' R' U' R B'"), # 12
        root_alg('h358', "B R' D2 R L U L' U' R' D2 R B'"), # 12
        root_alg('h470', "B R' U' B2 R U' R' U B2 U R B'"), # 12
        root_alg('h295', "B L U2 L' U B' R B' R' B2 U B'"), # 12
        root_alg('h599b', "R' U' R2 B R' U2 B2 L' B2 L U B'"), # 12
        root_alg('h617', "B' R' B2 U B L' B R B2 L U B'"), # 12
        root_alg('h387', "B U L' B2 L B2 U R' U R U B'"), # 12
        root_alg('h597e', "L2 D' R B R' D L2 F R U' R' F'"), # 12
        root_alg('h261b', "L' B' R' U R B L F R U' R' F'"), # 12
        root_alg('h603', "L2 U F' D' B2 D' L' B' D2 F2 R' F'"), # 12
        root_alg('h266', "R L B R' F R F' B' L' F R' F'"), # 12
        root_alg('h1007', "L F' L' F2 R' U2 B' R' B U2 R F'"), # 12
        root_alg('h261', "R B R' L F R L' B' R' L F' L'"), # 12
        root_alg('h562', "B L2 F' L2 B' L F' R' F' R F' L'"), # 12
        root_alg('h1094', "R U2 L D2 B L' U2 L B' D2 R' L'"), # 12
        root_alg('h94', "B' U' R' U R B L F U F' U' L'"), # 12
        root_alg('h84', "L F' L2 B2 R D' R' B2 L2 F U' L'"), # 12
        root_alg('h506', "B L2 B2 R B' R' B2 L2 U' L U' L'"), # 12
        root_alg('h636', "R' F' R B' R' F U R B L U' L'"), # 12
        root_alg('h363b', "R2 L D' F' D R2 U' B U' B' U2 L'"), # 12
        root_alg('h719', "L U2 R' U' R B2 D L D' B2 U2 L'"), # 12
        root_alg('h244', "B' R' F' U2 F R B2 L' B' L2 U2 L'"), # 12
        root_alg('h5b', "B L' B2 R B2 L B R' B2 L U2 L'"), # 12
        root_alg('h5', "B R' U2 R U2 R B R' B2 L U2 L'"), # 12
        root_alg('h348', "B' U' R' U F' U2 F R B L U2 L'"), # 12
        root_alg('h1105', "R' L U L U' R U L2 U L U2 L'"), # 12
        root_alg('h105', "L B' R' U L' U2 R U' L U2 B L'"), # 12
        root_alg('h718', "L' B' R' U2 R B L U2 F' L F L'"), # 12
        root_alg('h1177', "F' B U' F U B' L F R' F' R L'"), # 12
        root_alg('h590b', "B' R B' R' B2 U2 R' U L U' R L'"), # 12
        root_alg('h307c', "R2 L' D B' D' R L2 D' F D R L'"), # 12
        root_alg('h16', "L' U R U' D' B2 D L2 U2 R' U L'"), # 12
        root_alg('h963', "R L U2 L2 D' B2 D L2 U R' U L'"), # 12
        root_alg('h386', "L B' D2 F D F2 D B U' R2 U L'"), # 12
        root_alg('h550b', "R' L' D2 L U L' D2 L2 U' R U L'"), # 12
        root_alg('h1091', "R' L' U2 R U R' U2 L2 U' R U L'"), # 12
        root_alg('h698', "B L U' L' B' R' U2 L U' R U L'"), # 12
        root_alg('h1156', "R B U' L U' L' U L U2 L' B' R'"), # 12
        root_alg('h1186', "R2 U R' B' R U' R' U B2 U' B' R'"), # 12
        root_alg('h92', "B U B' U' B' U' R U B2 U' B' R'"), # 12
        root_alg('h800b', "R L' U' B' U B L U2 B U' B' R'"), # 12
        root_alg('h34', "F2 B D' L D F2 B' R B U' B' R'"), # 12
        root_alg('h136', "B L U L' U' B' R U B U' B' R'"), # 12
        root_alg('h21', "F' L' U' L U F R U B U' B' R'"), # 12
        root_alg('h359b', "R B U' L U R' U L' U' R B' R'"), # 12
        root_alg('h477', "R U B U' R' L U L' U' R B' R'"), # 12
        root_alg('h640', "B L' B' R B' L B2 R' U2 R B' R'"), # 12
        root_alg('h790', "R U B2 D B' U2 B D' B' U B' R'"), # 12
        root_alg('h90', "R U B' U' B2 U' B2 U2 B2 U B' R'"), # 12
        root_alg('h362', "R2 D B2 L2 D' R' D L' U2 L' D' R'"), # 12
        root_alg('h2', "R U D B2 U2 B' U B U B2 D' R'"), # 12
        root_alg('h1053', "B U B' R D B' U B' U' B D' R'"), # 12
        root_alg('h1055', "R D L' B L B2 L' B L B D' R'"), # 12
        root_alg('h1030', "R F D L' U' B2 U L D' R2 F' R'"), # 12
        root_alg('h815', "R B L' U R U' L U R' B' U' R'"), # 12
        root_alg('h1090', "R2 D L' B' L D' R' B U2 B' U' R'"), # 12
        root_alg('h372', "R2 L' D B' D' R' L B U2 B' U' R'"), # 12
        root_alg('h169b', "R L' B U' B' U L B U2 B' U' R'"), # 12
        root_alg('h471', "B' R2 D' R' D2 B' D' B' U B' U' R'"), # 12
        root_alg('h901', "R2 B2 L' B' L B2 R' B2 U B' U' R'"), # 12
        root_alg('h252b', "R' B U2 B' U2 B' R2 B2 U B' U' R'"), # 12
        root_alg('h437', "R' U2 R U R' U R2 B U B' U' R'"), # 12
        root_alg('h182', "B U L U' L' B' R B U B' U' R'"), # 12
        root_alg('h169', "B' R' U' R U B R B U B' U' R'"), # 12
        root_alg('h867', "R' U2 R2 B' U R2 U R2 U' B U' R'"), # 12
        root_alg('h1188', "F' L' U2 B L' B' L2 F U' R U' R'"), # 12
        root_alg('h108', "R U2 L' B' R B R2 L U' R U' R'"), # 12
        root_alg('h194', "B2 U' R2 B R' B' R' U B2 R U' R'"), # 12
        root_alg('h86', "B' D R2 U' R' U R2 D' B R U' R'"), # 12
        root_alg('h171', "R B2 U D L B L' B' U' D' B2 R'"), # 12
        root_alg('h599', "B' R B' D B2 R' U' R B2 D' B2 R'"), # 12
        root_alg('h990b', "R B2 U L' B' L B L U' L' B2 R'"), # 12
        root_alg('h709', "B' R B' D2 L D' L' D L' D2 B2 R'"), # 12
        root_alg('h580', "B L' B' R B2 D' B D B' L B2 R'"), # 12
        root_alg('h1014', "B L' B L B' L' B2 R B' L B2 R'"), # 12
        root_alg('h523', "R B U' B' U' B U L' B L B2 R'"), # 12
        root_alg('h61', "R B R' U L U' R L2 B L B2 R'"), # 12
        root_alg('h819', "L U L' U R U' B2 U' B2 U B2 R'"), # 12
        root_alg('h990', "R B2 L' U' B' U L U' B U B2 R'"), # 12
        root_alg('h357b', "R B D B2 D F U' L2 U F' D2 R'"), # 12
        root_alg('h445b', "L B2 L2 B2 L' B' R B D2 L2 D2 R'"), # 12
        root_alg('h445c', "R D2 L2 D2 B' R' B R D2 L2 D2 R'"), # 12
        root_alg('h267', "F' U' F R2 D L' B' L D' R' U2 R'"), # 12
        root_alg('h970', "R U' B U' B' U' B' R B R' U2 R'"), # 12
        root_alg('h363', "R L' B R B2 L' B R' B' L2 U2 R'"), # 12
        root_alg('h1024', "B U B2 R B2 U B' R2 U R2 U2 R'"), # 12
        root_alg('h295b', "R B U2 B2 R2 D' R' D R' B U2 R'"), # 12
        root_alg('h645', "R U B U B2 U' R' U R B U2 R'"), # 12
        root_alg('h750', "R L U2 L' B L U2 L2 B' L U2 R'"), # 12
        root_alg('h1101', "F' U' L' U' B L' B' L2 F R U2 R'"), # 12
        root_alg('h950', "R B U2 L' B' R B2 L B R' B R'"), # 12
        root_alg('h1209', "B' R2 U' R2 B R' B' R' U R' B R'"), # 12
        root_alg('h550', "B' R U' R' U' B R U' B' U' B R'"), # 12
        root_alg('h357', "R L B2 L F R' U2 R F' L2 B R'"), # 12
        root_alg('h540', "B' U2 B2 U B R B R2 U R2 B R'"), # 12
        root_alg('h946', "B U L U' L' U B' U' B' R B R'"), # 12
        root_alg('h920', "B2 D B' U B D' B2 U' B' R B R'"), # 12
        root_alg('h1021', "B L U L2 B L B2 U' B' R B R'"), # 12
        root_alg('h515', "R U2 R' U' R B' U' R' U R B R'"), # 12
        root_alg('h1209b', "R U' R' U R2 B' R2 U' R U B R'"), # 12
        root_alg('h991b', "B' R B U' R U D' R U' R' D R'"), # 12
        root_alg('h97', "L2 U' B L B' L2 U2 R D' B2 D R'"), # 12
        root_alg('h189', "R F' L2 B2 D L' D' L B2 L2 F R'"), # 12
        root_alg('h951', "R U' B2 L U L' U' B' U' B' U R'"), # 12
        root_alg('h218b', "R B' U' B2 R B' R' B2 U B U R'"), # 12
        root_alg('h990e', "L' U' R U' D B' U2 B D' L U R'"), # 12
        root_alg('h1067', "R' U R U2 R' L' U R2 U' L U R'"), # 12
        root_alg('h843', "L' U F2 D2 B2 L' D2 F2 U L U R'"), # 12
        root_alg('h884', "R' L' F' U2 F R L B2 D L2 D' B2"), # 12
        root_alg('h524', "R' U' R U2 B2 U L' B L B' U' B2"), # 12
        root_alg('h399', "B R U B2 U' B R' B U B' U' B2"), # 12
        root_alg('h816', "B2 U B R' U' R U B U' B2 U' B2"), # 12
        root_alg('h991', "B U' B U' R B R' B' U2 B U' B2"), # 12
        root_alg('h511', "L U L' U B2 R L2 B R' B' L2 B2"), # 12
        root_alg('h71', "B' R B' L2 D R D R' D' R' L2 B2"), # 12
        root_alg('h883e', "B2 L2 U' B2 D B2 D' R2 U R2 L2 B2"), # 12
        root_alg('h883c', "B2 L2 D' R2 D R2 U' R2 U R2 L2 B2"), # 12
        root_alg('h944', "B2 R2 U B' L B U' B' L' B R2 B2"), # 12
        root_alg('h427c', "B2 R2 B' U L' B L B' U' B R2 B2"), # 12
        root_alg('h896b', "B L' B R2 B' L2 U L' U' B R2 B2"), # 12
        root_alg('h35', "R B L' B' R' B2 R2 B' L B R2 B2"), # 12
        root_alg('h173', "R B2 L' B2 R' B2 R2 B' L B R2 B2"), # 12
        root_alg('h67d', "R L' B2 D2 B' R2 L2 F' R L' U2 B2"), # 12
        root_alg('h764', "B U2 B U B2 U B2 R B' R' U2 B2"), # 12
        root_alg('h1162', "B2 U2 B R B' R' U R' U' R U2 B2"), # 12
        root_alg('h984', "B' U' B2 D' B R B R' U B' D B2"), # 12
        root_alg('h672', "B2 R2 F' L F' D2 F2 R2 F' L' F B2"), # 12
        root_alg('h67c', "B2 R' L U2 F' R2 L2 B' D2 R' L B2"), # 12
        root_alg('h1135', "B2 U' B2 R B' R' U' B' U B' U B2"), # 12
        root_alg('h1187', "R D2 L2 B L B' D' L2 D' R' U B2"), # 12
        root_alg('h1157b', "B2 U' R' D2 L U2 L' D2 R B2 U B2"), # 12
        root_alg('h676', "L' B L' B' L2 F2 D B' R2 B D' F2"), # 12
        root_alg('h549b', "L' U' L F U F D B' R B D' F2"), # 12
        root_alg('h486', "F' U R L2 D' B' D R' L' F' L' F2"), # 12
        root_alg('h67b', "B2 R L' D2 B R2 L2 F' D2 R L' F2"), # 12
        root_alg('h149', "R' F' L F R F2 L2 B L' B' L2 F2"), # 12
        root_alg('h883d', "F2 R2 D' L2 U B2 U' B2 D R2 L2 F2"), # 12
        root_alg('h1100', "F2 R2 L2 B' R' B R2 F' R F L2 F2"), # 12
        root_alg('h300', "F2 U L' U' B' R' U R B L U2 F2"), # 12
        root_alg('h888', "F2 D' L2 B' R' F U2 F' R B D F2"), # 12
        root_alg('h67', "B2 R' L U2 F R2 L2 B' U2 R' L F2"), # 12
        root_alg('h888b', "F2 U' F2 L' B' R U2 R' B L U F2"), # 12
        root_alg('h830', "R' U' R U L' B R L' B R' B' L2"), # 12
        root_alg('h641', "L' B' R B R' B R L' B R' B' L2"), # 12
        root_alg('h445', "R L2 D2 R' L2 B' R B L2 D2 R' L2"), # 12
        root_alg('h1054', "L2 B2 L B' R' U2 R2 B2 L' B R' L2"), # 12
        root_alg('h1054b', "L2 B2 L B' L U2 L2 B2 R B R' L2"), # 12
        root_alg('h594', "L' U R B' R2 U' R U' B' L' B2 L2"), # 12
        root_alg('h38', "B' U' B U B L2 B2 R B' R' B2 L2"), # 12
        root_alg('h427', "L2 B2 R B' L' D L D' B R' B2 L2"), # 12
        root_alg('h427b', "L2 B2 R D' B R' B' R D R' B2 L2"), # 12
        root_alg('h1086', "L F R' F R L B2 L' F2 L B2 L2"), # 12
        root_alg('h857b', "B' U2 B L F R' F' L F2 R F2 L2"), # 12
        root_alg('h63', "R2 L2 D L2 F2 R2 L2 B2 R2 D' R2 L2"), # 12
        root_alg('h63b', "R2 L2 D L2 B2 R2 L2 F2 R2 D' R2 L2"), # 12
        root_alg('h1109', "L2 B' R B' R' B2 U2 F' L' F U2 L2"), # 12
        root_alg('h803', "L' U' L' D' L U' R L' B2 R' D L2"), # 12
        root_alg('h928', "R L' B L' B' R' D' R B R' D L2"), # 12
        root_alg('h926', "F U2 F' L2 D' B' R B' R' B2 D L2"), # 12
        root_alg('h1157', "L2 D' R' D2 L U2 L' D2 R B2 D L2"), # 12
        root_alg('h1174', "R B' R B2 R2 L' B L B' R2 B' R2"), # 12
        root_alg('h1190', "R B' R B D B L' B L B2 D' R2"), # 12
        root_alg('h549', "R B U' B' U' R D L' B L D' R2"), # 12
        root_alg('h919', "R2 U R2 B' R B R B' R B U' R2"), # 12
        root_alg('h1145', "R B2 L' B' R L U R' B' R U' R2"), # 12
        root_alg('h264', "R2 U B' R' B R' U R U' R U' R2"), # 12
        root_alg('h426', "R U' B R U2 R' U2 B' U R U' R2"), # 12
        root_alg('h1182', "R' F2 R' B2 R L F L' F R' B2 R2"), # 12
        root_alg('h1027', "B' U R2 D B D' R2 B U' R2 B2 R2"), # 12
        root_alg('h896', "R B' R B2 L' B2 D B' D' L B2 R2"), # 12
        root_alg('h432', "R2 B2 R2 U' R U B U' B' R B2 R2"), # 12
        root_alg('h1095', "R L2 B R B' L2 B2 R' B R B2 R2"), # 12
        root_alg('h576', "R B' R' B U2 R2 F' L F' L' F2 R2"), # 12
        root_alg('h990d', "L' D2 L2 F L2 D2 B L B' R2 B R2"), # 12
        root_alg('h1155', "R B2 L' B2 L B' R L' B' L B R2"), # 12
        root_alg('h359', "R U' B U' B' R' U R B' R B R2"), # 12
        root_alg('h146', "B' R B R' U2 R2 D' L F2 L' D R2"), # 12
        root_alg('h195', "B' R B R' U2 R2 D' R U2 R' D R2"), # 12
        root_alg('h537b', "B2 U B R B D' B' R' B R2 D R2"), # 12
        root_alg('h528', "R' U2 B' D' R' D B2 U2 B' R' U R2"), # 12
        root_alg('h990c', "B' D B' U2 B R' B' U2 B R D' B"), # 12
        root_alg('h889', "L B' R2 D' F' D R' B L' B' R' B"), # 12
        root_alg('h777', "R' U' R U' B U' B' U' R B' R' B"), # 12
        root_alg('h1005', "R U2 R2 U' R2 U' R' U2 R B' R' B"), # 12
        root_alg('h1014b', "L U' R' U L' U R U2 R B' R' B"), # 12
        root_alg('h910', "L U2 L' B L2 B R B' L2 B2 R' B"), # 12
        root_alg('h923d', "L U L' U' L' B' R B2 L B2 R' B"), # 12
        root_alg('h480', "L U2 R' U L' U' R B2 R B R' B"), # 12
        root_alg('h771', "B' U' B' R' U' R U B2 U2 B' U' B"), # 12
        root_alg('h951b', "L U L' B2 U' R' U R2 B R' U' B"), # 12
        root_alg('h597b', "B D F' L F D' B R B R' U' B"), # 12
        root_alg('h317b', "B U L U' L' B2 R' F R' F' R2 B"), # 12
        root_alg('h913', "B' U' R' U2 R' D' R U' R' D R2 B"), # 12
        root_alg('h1089b', "R U B2 D B' U' B2 D2 R D R2 B"), # 12
        root_alg('h551', "B U B2 R2 U' R' D' R U D R2 B"), # 12
        root_alg('h1173', "B' U2 R U R' B R U' R' B' U2 B"), # 12
        root_alg('h1151', "B' R' U' R B2 L U L' U' B2 U2 B"), # 12
        root_alg('h273', "B U2 B' R B' R' U' B2 U' B2 U2 B"), # 12
        root_alg('h857', "B' U2 R' B L' B' R B2 L B2 U2 B"), # 12
        root_alg('h1122', "B' R' U' R2 U' L' U R' U' L U2 B"), # 12
        root_alg('h1173b', "B' U2 B' R' B U B U' B' R U2 B"), # 12
        root_alg('h597c', "B L U' L' U B2 D' F R F' D B"), # 12
        root_alg('h114', "B' U' D' R2 U R' U' R' U R' D B"), # 12
        root_alg('h1114', "B2 R B L' B2 R' U' B' U B2 L B"), # 12
        root_alg('h537', "L' U B2 R' B U B U' L B' R B"), # 12
        root_alg('h206', "L U F U' F' U L' B' R' U' R B"), # 12
        root_alg('h626', "L U L2 B' R B L B' R2 U' R B"), # 12
        root_alg('h218', "B' R' B U2 B' U' B U' B' U2 R B"), # 12
        root_alg('h721', "B' U R' U R B U B' R' U2 R B"), # 12
        root_alg('h1046', "R' F' L F' L' F R B' R' F R B"), # 12
        root_alg('h440', "L U2 L' U B' U' R' F' U2 F R B"), # 12
        root_alg('h923', "B' U2 B U L U L' B' R' U R B"), # 12
        root_alg('h89', "R B U B' U' R' B' U' R' U R B"), # 12
        root_alg('h923b', "L' B2 R B2 L B' R' U' R' U R B"), # 12
        root_alg('h923c', "R' U2 R U2 R B' R' U' R' U R B"), # 12
        root_alg('h317', "B U2 B' U' B U' B2 U' R' U R B"), # 12
        root_alg('h327', "B L F' L F L2 B2 U' R' U R B"), # 12
        root_alg('h218c', "L U L' B' R' U' R U' R' U R B"), # 12
        root_alg('h809b', "R L' D' B2 D B L B' R' B' U B"), # 12
        root_alg('h1201', "R U B' R B R2 B' R U' R' U B"), # 12
        root_alg('h186', "B' U' B' R B R' B' R B R' U B"), # 12
        root_alg('h376', "L U L2 B L B2 R B' R' B U B"), # 12
        root_alg('h627', "L2 D L D2 R B R' D B' L U B"), # 12
        root_alg('h922', "L' U' B' U R' B L B' U' R U B"), # 12
        root_alg('h21b', "R U B U' B' R' B' R' U' R U B"), # 12
        root_alg('h729', "L' B L B' U2 B' U2 R' U' R U B"), # 12
        root_alg('h1138b', "B2 L2 B R2 B' L2 B R U' R U B"), # 12
        root_alg('h177', "F' L B2 R L D L' D' R' B2 L' F"), # 12
        root_alg('h114d', "F B' R B D2 B2 R' F2 U2 B2 L' F"), # 12
        root_alg('h114e', "F B' R B D2 B2 L' U2 B2 D2 R' F"), # 12
        root_alg('h176', "F B2 R' B2 R B2 R F2 L2 B2 L2 F"), # 12
        root_alg('h1039', "R' F2 L' D2 L' F' R2 B' R' F2 L2 F"), # 12
        root_alg('h1123', "F' U R D' B2 D R' U2 L U L2 F"), # 12
        root_alg('h621', "F D B' R B D' F2 U' L' U' L F"), # 12
        root_alg('h961', "L' B' U R' U' R L F' L' B L F"), # 12
        root_alg('h712', "B L U' L' F' B' R' F U F' R F"), # 12
        root_alg('h938', "L' U' B U R B2 R' L U L' B' L"), # 12
        root_alg('h977b', "R L' D B2 D' R' B L U L' B' L"), # 12
        root_alg('h394', "L' D B' R' L2 U R U' L2 B D' L"), # 12
        root_alg('h647', "R B U B' L' U B U' B' U' R' L"), # 12
        root_alg('h861', "R B U B' R U' L' U R' U' R' L"), # 12
        root_alg('h1015b', "R U2 B' U2 B' U2 B U2 L' B2 R' L"), # 12
        root_alg('h1127b', "L' B U B2 U' B2 U' B R B2 R' L"), # 12
        root_alg('h63c', "F2 B2 U R2 L2 D' R' L U2 D2 R' L"), # 12
        root_alg('h114b', "R L F' R2 U2 L2 B' R2 D2 B R' L"), # 12
        root_alg('h114c', "R L B' D2 R2 U2 F' R2 D2 B R' L"), # 12
        root_alg('h935b', "R U' B' U2 B U L' D' B D R' L"), # 12
        root_alg('h967', "L' B' U' B2 U2 R B R' U2 B' U' L"), # 12
        root_alg('h491', "B U B' L' B' R B R2 U R U' L"), # 12
        root_alg('h539', "B' U' R' U B L' B' R2 B' R' B2 L"), # 12
        root_alg('h130', "L' U2 L U L' U B' R B' R' B2 L"), # 12
        root_alg('h707', "L' B' U B U' B' U' R B' R' B2 L"), # 12
        root_alg('h998', "B' R B L' B2 R' B R B' R' B2 L"), # 12
        root_alg('h1083', "L' B2 U' R D' R' U R2 D R2 B2 L"), # 12
        root_alg('h935', "R2 L' B D B2 D' B D B D' R2 L"), # 12
        root_alg('h1015', "R B2 R L' B' D2 B' D2 B D2 R2 L"), # 12
        root_alg('h349', "R L2 B2 R' L B U2 B2 U2 B' U2 L"), # 12
        root_alg('h185', "R F U' B U' B' U F' R' L' U2 L"), # 12
        root_alg('h593', "R L2 B L B U B2 U' B2 R' U2 L"), # 12
        root_alg('h798', "L' U2 B2 R' U' R U B U' B U2 L"), # 12
        root_alg('h1138', "B' R' U' R U R B L' B' R' B L"), # 12
        root_alg('h841', "R U' L' U R' U' B2 R B R' B L"), # 12
        root_alg('h156', "L' U' L U' L' U2 B2 R B R' B L"), # 12
        root_alg('h1018', "L2 B2 R B' L B2 R2 U' R U' B L"), # 12
        root_alg('h1166', "L' B L' B' L B2 R B R' U2 B L"), # 12
        root_alg('h422', "B2 U' B R' B' U B2 L' B' R B L"), # 12
        root_alg('h1065', "B' R' U' R U R' B L' B' R B L"), # 12
        root_alg('h1091b', "B' R B L' B2 R' B2 U' B' U B L"), # 12
        root_alg('h993', "R' U L U' R U L2 U' B' U B L"), # 12
        root_alg('h659', "L2 D' R B2 R' D L U B' U B L"), # 12
        root_alg('h983', "L' B L B' U L' D' R B' R' D L"), # 12
        root_alg('h597', "L' B L B' U' L' D' R B R' D L"), # 12
        root_alg('h715', "B' R' U' R B L' D' R B R' D L"), # 12
        root_alg('h987', "L2 D' B2 R D L D' R2 U2 R D L"), # 12
        root_alg('h883b', "B U' F U2 B' U F' R' L' U2 R L"), # 12
        root_alg('h590', "R' U' R2 B' R' B L' B U' B' U L"), # 12
        root_alg('h188', "F R U' B U B' U' R' F' L' U L"), # 12
        root_alg('h23', "R B U B' U' R' L' B' U' B U L"), # 12
        root_alg('h82', "B' R' U' R U B L' B' U' B U L"), # 12
        root_alg('h101', "R' U' F' U F R L' B' U' B U L"), # 12
        root_alg('h241', "R L2 D' B2 D R' L B' U B U L"), # 12
        root_alg('h808b', "R L' U' L' B' U' B U R' L U L"), # 12
        root_alg('h923e', "B U B' U' B' R' B U2 B U2 B' R"), # 12
        root_alg('h358b', "R' B U' R' L2 F R F' L2 U B' R"), # 12
        root_alg('h784', "L' U' B' U B L2 U' R' U L' U' R"), # 12
        root_alg('h215', "R' U R2 U D B U' B' D' R2 U' R"), # 12
        root_alg('h724', "R' U2 R U' R B U B' U' R2 U' R"), # 12
        root_alg('h1192', "R' U' R U2 R B U B' U' R2 U' R"), # 12
        root_alg('h88', "R B2 L' B' R2 L D2 L2 F L2 D2 R"), # 12
        root_alg('h1127', "R' U' R U' B L U' L' B' R' U2 R"), # 12
        root_alg('h791', "R' U2 R2 U B U' B' R' U' R' U2 R"), # 12
        root_alg('h744', "B' R B R' U2 R' U R U' R' U2 R"), # 12
        root_alg('h1013', "B' R B R' U2 B U' B' U R' U2 R"), # 12
        root_alg('h1165', "R U B2 U R2 U' R2 U' B2 R2 U2 R"), # 12
        root_alg('h600', "R U B2 D B2 U' B' D' B R2 U2 R"), # 12
        root_alg('h18', "R' U' R U2 B U B2 R B R2 U2 R"), # 12
        root_alg('h1127c', "L' B U B2 U' B2 U' B' R' L U2 R"), # 12
        root_alg('h1003', "R' B' R U' R' U2 R U' R' U' B R"), # 12
        root_alg('h862', "R' B' R2 U R2 U' R' U2 R' U' B R"), # 12
        root_alg('h239', "R' B' R2 B U B' R2 U' R2 U B R"), # 12
        root_alg('h1059', "R' B' R2 U R2 U R2 U2 R2 U B R"), # 12
        root_alg('h883', "R2 D' L2 D' B2 L' D' R D2 L' D R"), # 12
        root_alg('h993b', "R' F' B U' L' U L U B' U' F R"), # 12
        root_alg('h1047', "R B2 D2 L2 B D2 R' B R' U2 F R"), # 12
        root_alg('h1046b', "L' U' B' U2 B R' L F U' F' U R"), # 12
        root_alg('h135', "R' U' R B2 L U L' U' B2 R' U R"), # 12
        root_alg('h995b', "L U2 L' U2 L' B2 L B2 U R' U R"), # 12
        root_alg('h494', "R B L' B' R' B2 L B2 U R' U R"), # 12
        root_alg('h995c', "R B2 L' B2 R' B2 L B2 U R' U R"), # 12
        root_alg('h995', "R B2 R' U2 R' U2 R B2 U R' U R"), # 12
        root_alg('h473', "B L U' L' B' R' U' R U R' U R"), # 12
        root_alg('h326', "R U B U' B' R2 U2 R U R' U R"), # 12
        root_alg('h822', "R' U' R U' R U B U' B' R2 U R"), # 12
        root_alg('h1012', "B U B' R B2 L' B' L B' R2 U R"), # 12
        root_alg('h551b', "R B2 D B2 U2 B' D' B U2 R2 U R"), # 12
        root_alg('h1089', "R U B2 D B' U' B2 D' B R2 U R"), # 12
        root_alg('h217', "B L U L' U' B' R' F' U' F U R"), # 12

        root_alg('h190', "B2 L2 U2 B R B R' B2 U2 L2 B' L' B'"), # 13
        root_alg('h131', "B U' R' U' R U' B2 L' B2 L2 U' L' B'"), # 13
        root_alg('h828', "B' U2 B2 U B2 R' U R B2 L U' L' B'"), # 13
        root_alg('h658', "R' U L F R' F' R2 L' B L U' L' B'"), # 13
        root_alg('h973', "B2 R2 B' L2 B R2 B' L2 U L U' L' B'"), # 13
        root_alg('h325', "R U2 R' U' R U' R' B U L U' L' B'"), # 13
        root_alg('h703', "B2 L U2 R B' R' U2 B2 U2 B U2 L' B'"), # 13
        root_alg('h1194', "F' U2 F U R B U L B' R' B L' B'"), # 13
        root_alg('h583', "R B2 U2 B' U' L B U' B2 R' B L' B'"), # 13
        root_alg('h127', "B U' L U' L' U R' U L U' R L' B'"), # 13
        root_alg('h1200', "B U R L D2 R' U2 R D2 R' U L' B'"), # 13
        root_alg('h638b', "B L' B2 D' R2 D' R2 D2 B2 L2 U L' B'"), # 13
        root_alg('h1000', "L U' R' U L' U R U B L U L' B'"), # 13
        root_alg('h667', "B R B L' B' L B' L' B' L B R' B'"), # 13
        root_alg('h397b', "B R U' B2 U' B U' B' U2 B2 U R' B'"), # 13
        root_alg('h759', "B R U B' U2 B' U2 B' U2 B2 U R' B'"), # 13
        root_alg('h243', "B U L' B R2 L2 U L' U' R2 B' U' B'"), # 13
        root_alg('h104', "B U B R2 U2 R B2 R' U2 R2 B' U' B'"), # 13
        root_alg('h914', "R' U2 R B L U' F U F' U2 L' U' B'"), # 13
        root_alg('h856', "B' D' F R' F' D B2 U' L U2 L' U' B'"), # 13
        root_alg('h398b', "B U2 B' U' B R' U L U' R L' U' B'"), # 13
        root_alg('h869b', "B U' R' U L2 U' R U L' U L' U' B'"), # 13
        root_alg('h81b', "B' U' R B' R' B U B2 L U L' U' B'"), # 13
        root_alg('h462', "F R2 B' R' B R' F' B L U L' U' B'"), # 13
        root_alg('h284', "R B2 L' B' L B' R' B L U L' U' B'"), # 13
        root_alg('h352c', "R U2 R' U' R U' R' B L U L' U' B'"), # 13
        root_alg('h476', "R B U B' U' R2 U' R2 B' R' B2 U' B'"), # 13
        root_alg('h384b', "F' B2 D L' D' F B2 R B' R' B2 U' B'"), # 13
        root_alg('h683', "B L U' L2 B' R B L B2 R' B2 U' B'"), # 13
        root_alg('h927', "B U2 B2 U' L' B2 R' L U' R B2 U' B'"), # 13
        root_alg('h151', "B L2 U2 R' U L2 U' R L2 U2 L2 U' B'"), # 13
        root_alg('h699', "R2 D' L F L' D' L2 F' L2 D2 R2 U' B'"), # 13
        root_alg('h454', "B U B' R2 U' R U' R' U2 R2 B U' B'"), # 13
        root_alg('h497', "R2 D' R U2 R' L F' L' D R2 B U' B'"), # 13
        root_alg('h850b', "L' B L U' R L' B2 R' B' L B U' B'"), # 13
        root_alg('h66', "B' R' U' R B2 U B L' B2 L B U' B'"), # 13
        root_alg('h850', "L' B L U R' U2 R L' B L B U' B'"), # 13
        root_alg('h824c', "B2 D B' U B D' B2 R' U R B U' B'"), # 13
        root_alg('h725', "B' U2 B U R B' R' U B U B U' B'"), # 13
        root_alg('h797', "B U2 B' U' R' U' R B2 L' B' L U' B'"), # 13
        root_alg('h212b', "R' U' F' U2 F U2 R B2 L' B' L U' B'"), # 13
        root_alg('h638c', "B U' F2 R' D2 R' D2 R2 F2 U2 L U' B'"), # 13
        root_alg('h428b', "B2 R2 B' L' B R2 B2 U' B U L U' B'"), # 13
        root_alg('h70c', "B L U R' L' U2 B' U' B U' R U' B'"), # 13
        root_alg('h776c', "F2 B2 D2 F' R F D2 B2 L B L' F2 B'"), # 13
        root_alg('h360b', "B R L2 U2 L2 B L' B' L' U2 R' L2 B'"), # 13
        root_alg('h743', "B2 R2 F2 D2 F D F R2 B2 U' B L2 B'"), # 13
        root_alg('h263b', "F' B L F2 B' R U R' F' U B L2 B'"), # 13
        root_alg('h76', "B L2 D' B R2 D' F2 D R2 B' D L2 B'"), # 13
        root_alg('h646', "R U B U' L B' R' F' B L F L2 B'"), # 13
        root_alg('h375', "B L2 U' L B' R B' R' B2 L' U L2 B'"), # 13
        root_alg('h765b', "B R U2 R' U' R U' R' L U L' U2 B'"), # 13
        root_alg('h125', "B U' B' R B' R' B2 U2 L U L' U2 B'"), # 13
        root_alg('h679b', "B R2 B' L' B R2 L U2 R B R' U2 B'"), # 13
        root_alg('h81d', "R2 L2 F' D' F R2 L2 U' B U2 B2 U2 B'"), # 13
        root_alg('h681', "R B' R2 U' R U' L' B' L U2 B2 U2 B'"), # 13
        root_alg('h545', "B' U' B2 L U R' U2 R L' U B2 U2 B'"), # 13
        root_alg('h115', "B' U' B R D B2 D' B' R' U B2 U2 B'"), # 13
        root_alg('h799b', "B U' R U' B' R D B2 D' B' R2 U2 B'"), # 13
        root_alg('h751', "B U2 R B' R B2 R' B' R B' R2 U2 B'"), # 13
        root_alg('h39b', "B U2 B2 R B' D B D' B R' B U2 B'"), # 13
        root_alg('h164', "B U L U' L' U2 B2 R B R' B U2 B'"), # 13
        root_alg('h989', "R B' R' B2 U B' R' U' R U' B U2 B'"), # 13
        root_alg('h648b', "R L' B R' L U2 L' B L U2 B U2 B'"), # 13
        root_alg('h1037b', "R' U2 R2 U B U' B2 R' B U B U2 B'"), # 13
        root_alg('h814', "B U' R' U2 B2 D' R2 D B2 U2 R U2 B'"), # 13
        root_alg('h1207', "B D' R2 U2 D R B R' U2 D' R2 D B'"), # 13
        root_alg('h887', "B' R F' D2 F R' F B2 U2 F2 L' F B'"), # 13
        root_alg('h1103d', "F B D' L' D F2 U' R U' R' U2 F B'"), # 13
        root_alg('h336b', "F' U B L U2 R U' L' U R' U2 F B'"), # 13
        root_alg('h614', "B' R B R' U B2 U L U' L2 B' L B'"), # 13
        root_alg('h335', "R2 B' L' F' R' F2 L D2 B2 L' F' L B'"), # 13
        root_alg('h335b', "R2 B' L' F' L' U2 L F2 D2 R' F' L B'"), # 13
        root_alg('h685', "F B' R F2 D2 F2 B R' B U2 F' L B'"), # 13
        root_alg('h631d', "B U B' U B R' U2 R B2 L' B2 L B'"), # 13
        root_alg('h1075d', "B R B2 D B2 D' R2 U' R L' B2 L B'"), # 13
        root_alg('h581b', "B' U' R U B U' B L' B2 R' B2 L B'"), # 13
        root_alg('h1210b', "R U2 R2 U' R2 U' B2 L' B R' B2 L B'"), # 13
        root_alg('h407b', "L F' R2 F U2 L' U2 L' B' D2 B2 L B'"), # 13
        root_alg('h679', "B2 L' D' B R2 B R B' R2 D B2 L B'"), # 13
        root_alg('h1195b', "B U2 R B R' U2 R2 B' L' B R2 L B'"), # 13
        root_alg('h824', "R2 U R' B R U' R' L' B' R' B L B'"), # 13
        root_alg('h588', "R U2 R' U' R U' B2 L' B2 R' B L B'"), # 13
        root_alg('h588b', "R L' B2 D' R D' R' D2 B2 R' B L B'"), # 13
        root_alg('h104b', "R L' U' L U B2 L' B2 R' U2 B L B'"), # 13
        root_alg('h503', "R B2 L2 B2 U' L' U R' L U2 B L B'"), # 13
        root_alg('h1141b', "F U R U2 R' F' B L' B' U B L B'"), # 13
        root_alg('h1117b', "B U B' U B R' D2 R U2 R' D2 R B'"), # 13
        root_alg('h631c', "B U B' U B R' U2 L U2 L' U2 R B'"), # 13
        root_alg('h747b', "B L U L' U R' U2 L U2 L' U2 R B'"), # 13
        root_alg('h631b', "B U B' U B L' B2 L B2 R' U2 R B'"), # 13
        root_alg('h747c', "B L U L' U L' B2 L B2 R' U2 R B'"), # 13
        root_alg('h581', "B' U' R U B U' B R' U2 R' U2 R B'"), # 13
        root_alg('h452', "B R' U2 B2 R2 B R' B' R' B2 U2 R B'"), # 13
        root_alg('h296', "B R' U2 B2 R' B R2 B' R B2 U2 R B'"), # 13
        root_alg('h897', "B2 U2 R B' R' U' B2 R B R2 U R B'"), # 13
        root_alg('h789', "R' F2 L F R L' B R' U' F U R B'"), # 13
        root_alg('h1099', "B2 R2 U B U B' U' B' U' R2 B' U B'"), # 13
        root_alg('h1128', "B U' L U' B' R' U' R U B L' U B'"), # 13
        root_alg('h33', "B U' R U' B2 U2 B2 U2 B2 U' R' U B'"), # 13
        root_alg('h33b', "B U' R' B2 U2 R2 U2 B2 R2 U2 R' U B'"), # 13
        root_alg('h41', "R B' D B2 L' B L D' B R' B2 U B'"), # 13
        root_alg('h293', "B U' B2 R2 U' B R2 B' U R2 B2 U B'"), # 13
        root_alg('h272b', "B' D' R2 U' R2 U B U2 B' D B2 U B'"), # 13
        root_alg('h1056', "F' B U' F R' L2 D' F D R L2 U B'"), # 13
        root_alg('h847', "B U2 B U2 R B2 R' U2 B2 U' B U B'"), # 13
        root_alg('h65c', "R' U R B U2 B' U2 R' U2 R B U B'"), # 13
        root_alg('h39c', "R B2 L2 D L B D' B R' B L U B'"), # 13
        root_alg('h423c', "F L2 D2 R' B R D2 L2 F L F' L' F'"), # 13
        root_alg('h817d', "L' U2 R L B' R' F R B2 U2 B' R' F'"), # 13
        root_alg('h678b', "R B R' U2 L U2 L' U2 F R B' R' F'"), # 13
        root_alg('h678', "R B L' B2 L B2 R' U2 F R B' R' F'"), # 13
        root_alg('h305b', "F2 R2 L2 B' D B R2 L2 F' R U' R' F'"), # 13
        root_alg('h66c', "L' B' R' U R B U2 L F R U' R' F'"), # 13
        root_alg('h396', "L' B' R B' R' B2 L F U R U' R' F'"), # 13
        root_alg('h75', "F' L2 B L B' L F2 R2 B' R' B R' F'"), # 13
        root_alg('h708', "F R B' U2 L' B' L U2 B U' R' U' F'"), # 13
        root_alg('h959', "F R U F2 D2 L B2 D L' D F2 U' F'"), # 13
        root_alg('h81c', "R2 L2 F' D' F R2 L2 U' F R2 B2 R2 F'"), # 13
        root_alg('h178b', "F' U' F U F R2 D2 L B' L' D2 R2 F'"), # 13
        root_alg('h657', "L2 D' L' D' B R' B' D2 L' U' F' U2 F'"), # 13
        root_alg('h85', "F2 R2 D2 L B L' D' R D' R F' U2 F'"), # 13
        root_alg('h660', "F U2 L2 D2 B R B' D2 L' F' L' U2 F'"), # 13
        root_alg('h660b', "B L2 D2 R2 F R B' D2 L' F' L' U2 F'"), # 13
        root_alg('h100', "L' B L' B' L2 F2 B' R' F' R B U2 F'"), # 13
        root_alg('h404', "L2 B' D2 B' L B2 L2 F L' U2 R U2 F'"), # 13
        root_alg('h423b', "R2 B' R' F' R' F2 D2 R' B2 L' B' R F'"), # 13
        root_alg('h423', "R2 B' R' F' L' U2 F2 R' D2 R' B' R F'"), # 13
        root_alg('h1103e', "F' B L' F' B' L2 F' R' B D2 B' R F'"), # 13
        root_alg('h33c', "F2 R2 L2 B' R' D B R2 L2 F' U' R F'"), # 13
        root_alg('h1128b', "F U' R L' B' U' B U L U' R' U F'"), # 13
        root_alg('h746', "F R B U2 L U' L2 B L B2 R' U F'"), # 13
        root_alg('h12', "L2 U F2 R2 D' B2 D2 R D' F' R U F'"), # 13
        root_alg('h73', "L' U' L F' R2 B' R' B R2 F2 R U F'"), # 13
        root_alg('h375b', "L B U' L2 B' R B' R' B2 L2 U B' L'"), # 13
        root_alg('h496', "R B L' B' R' B L2 F L' B' L F' L'"), # 13
        root_alg('h1009d', "R B' U' B R' L U F' U2 F2 U F' L'"), # 13
        root_alg('h960', "R U2 R' U' R L B L' U' L B' R' L'"), # 13
        root_alg('h766', "L U2 R B L2 B L2 D L' D' B2 R' L'"), # 13
        root_alg('h565b', "B' U' R' U2 R2 B2 L' B2 R' B L2 U' L'"), # 13
        root_alg('h565', "B' U' L U2 L2 B2 R B2 R' B L2 U' L'"), # 13
        root_alg('h460b', "B' U' R' U R B L U2 L' U' L U' L'"), # 13
        root_alg('h240', "B' R' U' R U B L U2 L' U' L U' L'"), # 13
        root_alg('h620', "L2 B2 D R' F2 R D' B2 L2 U' L U' L'"), # 13
        root_alg('h409', "B' R B' R' B2 U B' U' B U' L U' L'"), # 13
        root_alg('h250b', "L' B2 D' R2 D' R2 D2 B2 L U' L U' L'"), # 13
        root_alg('h388', "R' U2 B' R2 B' R2 B2 U2 R U' L U' L'"), # 13
        root_alg('h962', "F U B' U R U2 B' R' F' B2 L U' L'"), # 13
        root_alg('h985', "B' U' B U' B' U' R B' R' B2 L U' L'"), # 13
        root_alg('h123', "L U L' U2 B2 R B R' B U2 L U' L'"), # 13
        root_alg('h272', "B' U' R U R2 U R2 U2 R' B L U' L'"), # 13
        root_alg('h559b', "R' L U' R2 B U B' U' R2 U2 R U' L'"), # 13
        root_alg('h238c', "L B' R2 F' D2 L2 F R2 B' U2 L2 B2 L'"), # 13
        root_alg('h128b', "L' U2 L U2 L F2 D2 B R' B' D2 F2 L'"), # 13
        root_alg('h128', "R' F2 L F2 R F2 D2 B R' B' D2 F2 L'"), # 13
        root_alg('h738b', "F2 D B' R2 B D' L2 B L B' L2 F2 L'"), # 13
        root_alg('h238b', "L F' U2 F' R2 D2 B L2 B' D2 R2 F2 L'"), # 13
        root_alg('h238', "L F' U2 B' D2 L2 B U2 F' D2 R2 F2 L'"), # 13
        root_alg('h282', "R B' R' F R2 B R F' L F2 R F2 L'"), # 13
        root_alg('h817c', "R L B L U2 L B2 R B' L2 B2 R2 L'"), # 13
        root_alg('h702', "L' D' R2 D' B' R D R D L2 F' U2 L'"), # 13
        root_alg('h689', "L U' B L' B' U' R B L B' R' U2 L'"), # 13
        root_alg('h892c', "B' R B' D2 F2 R' L D' L' D' B2 U2 L'"), # 13
        root_alg('h892b', "B' R B R' L U2 B2 D L' D' B2 U2 L'"), # 13
        root_alg('h860', "L U2 B L2 B' R' U2 R B2 L' B2 U2 L'"), # 13
        root_alg('h1118', "B2 L2 B R B' R' L2 B' L' B' L2 U2 L'"), # 13
        root_alg('h844b', "R B2 R' B L' B L B' L' B2 L2 U2 L'"), # 13
        root_alg('h456b', "L U L' U R' U2 R B2 L' B2 L2 U2 L'"), # 13
        root_alg('h232', "R' U L U' R2 U' L' U R' U' L U2 L'"), # 13
        root_alg('h989b', "B' R' U2 F R' F' R2 U B U' L U2 L'"), # 13
        root_alg('h779', "B' R' U' R2 U B U' B2 R' B2 L U2 L'"), # 13
        root_alg('h671', "L U L' U2 B' U' R' U' R B L U2 L'"), # 13
        root_alg('h1051', "R' U L' U R U' L2 U2 R' U R U2 L'"), # 13
        root_alg('h965', "R L B' D' R2 F R' F2 R' D R' B L'"), # 13
        root_alg('h230', "L B' D2 L' U R' U2 R U' L D2 B L'"), # 13
        root_alg('h356', "L D' B2 R2 D2 L D' L' D' R2 B2 D L'"), # 13
        root_alg('h99', "L D' L2 B2 D' F R2 F' D B2 L2 D L'"), # 13
        root_alg('h838', "B' U' R' U R B2 L2 F' L2 B' L F L'"), # 13
        root_alg('h152', "R2 B2 L2 D2 B' L2 B' R2 F2 U2 L F L'"), # 13
        root_alg('h530', "B' U' B2 L' B' L' U' R' U L' U' R L'"), # 13
        root_alg('h754d', "B' R' U R B L2 U' R' U L' U' R L'"), # 13
        root_alg('h975', "B L2 U L U' B' R' L U L2 U' R L'"), # 13
        root_alg('h690', "R' L' F' U2 F L2 U2 B L2 B' U2 R L'"), # 13
        root_alg('h87', "R2 L F2 U' F' U F2 R2 B U2 B' U L'"), # 13
        root_alg('h332', "L U' R U2 B L' U2 L B' U2 R' U L'"), # 13
        root_alg('h1079b', "L U F B U B2 D' R2 D F' B U L'"), # 13
        root_alg('h781', "B L' B' L B2 R B R' B U' L U L'"), # 13
        root_alg('h343', "R' L U L' U' R B' U2 B U L U L'"), # 13
        root_alg('h542', "R2 D' R U2 R' D R U' L U' R U L'"), # 13
        root_alg('h1040', "B' R' U' R U B R' U L U' R U L'"), # 13
        root_alg('h592', "B2 L2 B2 U' R' U L U L2 U2 R U L'"), # 13
        root_alg('h1170', "R2 U R' B U' L U R U' R' L' B' R'"), # 13
        root_alg('h1062b', "R B' R B2 L' B' R' B L2 U2 L' B' R'"), # 13
        root_alg('h490', "R B2 L' B' L2 U2 L' U' L U2 L' B' R'"), # 13
        root_alg('h813', "R U B U' L U2 L' U' L U2 L' B' R'"), # 13
        root_alg('h801', "R B2 L' B2 R' B L2 B' R B L' B' R'"), # 13
        root_alg('h695b', "R B' R D' R D R2 B2 L U L' B' R'"), # 13
        root_alg('h243b', "R2 L' D B' D' R' L B L U L' B' R'"), # 13
        root_alg('h66b', "R L' B U' B' U L B L U L' B' R'"), # 13
        root_alg('h418', "R U2 R2 U' R2 B' D B' D' B' U' B' R'"), # 13
        root_alg('h140', "R B U2 R' U' R2 D B2 D' R' U' B' R'"), # 13
        root_alg('h361', "L' B2 R2 B R2 B R L U' B U' B' R'"), # 13
        root_alg('h879b', "L U' L' U2 R L U' L' U2 B U' B' R'"), # 13
        root_alg('h824e', "R L' D L U' L' D' L U2 B U' B' R'"), # 13
        root_alg('h879', "L U' R U R' L' U2 R U2 B U' B' R'"), # 13
        root_alg('h1170b', "R2 D L' B2 L D' R2 U' R B U' B' R'"), # 13
        root_alg('h449', "L U2 L' U' L U' R L' U B U' B' R'"), # 13
        root_alg('h212', "B L U' L' B' R' U R2 U B U' B' R'"), # 13
        root_alg('h596', "R B L U L2 U' B' U B L U' B' R'"), # 13
        root_alg('h255', "R B2 L D2 R F R' D2 L B' L2 B' R'"), # 13
        root_alg('h365', "R B L2 U2 L2 B L' B' L' U2 L2 B' R'"), # 13
        root_alg('h756', "F R' F' R U2 R U2 B2 L' B' L B' R'"), # 13
        root_alg('h417b', "L' U' B' U B R L B2 L' B' L B' R'"), # 13
        root_alg('h321', "B L U L' U' B' R B2 L' B' L B' R'"), # 13
        root_alg('h127b', "R B2 L2 D2 F' D' F D' L B' L B' R'"), # 13
        root_alg('h1079c', "R2 B' D2 F L' F' D2 L' B2 R' L B' R'"), # 13
        root_alg('h974', "R2 B2 L' B' L B L' B R' B2 L B' R'"), # 13
        root_alg('h941', "R U B U2 L' U' L2 U' L2 U2 L B' R'"), # 13
        root_alg('h1009b', "B L F U' F' U L2 B' R B L B' R'"), # 13
        root_alg('h881b', "B' R B R' U2 B2 L' B2 R B L B' R'"), # 13
        root_alg('h65b', "R B2 U R B2 R' B' U' R' U2 R B' R'"), # 13
        root_alg('h667b', "R B U B' U' B U' B' U' B U B' R'"), # 13
        root_alg('h890', "B U2 B' U' R' U R2 D L' B' L D' R'"), # 13
        root_alg('h804', "B U B' R D B' U' B' U B U D' R'"), # 13
        root_alg('h59b', "R2 D L' D' R2 U R U' D L U D' R'"), # 13
        root_alg('h885b', "R2 B' R' B2 L F U2 F' L' U' B' U' R'"), # 13
        root_alg('h45', "R B R' U L U' R U' L' U2 B' U' R'"), # 13
        root_alg('h631', "R B L U2 L' U' L U L' U2 B' U' R'"), # 13
        root_alg('h892', "R B2 L' B' L U' B' U' B U2 B' U' R'"), # 13
        root_alg('h1210c', "R2 B2 L' B2 R' B L2 U2 L' U B' U' R'"), # 13
        root_alg('h953', "R B L U2 L' U' L U2 L' U B' U' R'"), # 13
        root_alg('h447', "F' U2 F U R B L U L' U B' U' R'"), # 13
        root_alg('h1037', "B' R U2 R' B R B' U2 B2 U B' U' R'"), # 13
        root_alg('h831', "R U2 B' D' B U2 B' D B2 U B' U' R'"), # 13
        root_alg('h695', "B2 U' R U2 B' R' B' R B U' B2 U' R'"), # 13
        root_alg('h123b', "R U R' U2 R U2 B L' B L B2 U' R'"), # 13
        root_alg('h262b', "F' L' B' U B L F R2 B' R' B U' R'"), # 13
        root_alg('h1042', "R U' R' U2 R2 U B U' B2 R' B U' R'"), # 13
        root_alg('h436', "B L U L' U' B' R U2 R' U' R U' R'"), # 13
        root_alg('h81', "R2 U R U R2 U' R' U' R2 U' R U' R'"), # 13
        root_alg('h421', "B2 U' B2 U' B2 U R U R' B2 R U' R'"), # 13
        root_alg('h501', "B' U' R' U R2 B U B' R' B R U' R'"), # 13
        root_alg('h577b', "B' R' U' R B' R B U R' B R U' R'"), # 13
        root_alg('h457', "R B2 U D B2 D' B' D B' U' D' B2 R'"), # 13
        root_alg('h150', "B U L' B L2 B2 U' B' R B' L' B2 R'"), # 13
        root_alg('h716', "R U B2 L' B' U' B U L2 U' L' B2 R'"), # 13
        root_alg('h765', "R D B2 D' B' D B' U D' B U' B2 R'"), # 13
        root_alg('h965c', "R' F2 U' F U' R2 B' D2 B' L2 D2 B2 R'"), # 13
        root_alg('h456d', "L U L' U L' B2 R D2 L' D2 L2 B2 R'"), # 13
        root_alg('h994b', "R B2 L' D L' D R F' R' D2 L2 B2 R'"), # 13
        root_alg('h452b', "R B2 R2 U2 B2 R B R' B U2 R2 B2 R'"), # 13
        root_alg('h881', "R' U R B' R B' R2 B' U' B R2 B2 R'"), # 13
        root_alg('h109', "R U D' B R2 B R2 B' R2 U' D B2 R'"), # 13
        root_alg('h124', "R' U' R U' R' U2 R2 B L' B L B2 R'"), # 13
        root_alg('h1204', "R U B U2 B' U' B U L' B L B2 R'"), # 13
        root_alg('h352b', "R L' B R' B' R L B2 R' B' R B2 R'"), # 13
        root_alg('h352', "R L' B L B2 R' L' B L B' R B2 R'"), # 13
        root_alg('h249', "R L' B R' L2 U2 L2 B L B' R B2 R'"), # 13
        root_alg('h397', "R B2 U' B U' B U' B' U2 B' U B2 R'"), # 13
        root_alg('h238d', "R D' R2 U' F2 L2 U R2 D' B2 L2 D2 R'"), # 13
        root_alg('h1203', "B2 D2 F2 L D2 B' U2 R2 B' D2 F D2 R'"), # 13
        root_alg('h369', "R F2 R L2 D R' D' B' D B L2 F2 R'"), # 13
        root_alg('h1099c', "B' R' U R2 U2 R' B L U' R L' U2 R'"), # 13
        root_alg('h1099d', "R2 B2 R' B2 U' R' U2 L U R L' U2 R'"), # 13
        root_alg('h586', "R2 D L2 B' L B' L' B2 L2 D' R' U2 R'"), # 13
        root_alg('h1051c', "R D L2 D' R D L B2 L D' R' U2 R'"), # 13
        root_alg('h1193', "R U B' R B D R' U R D' R' U2 R'"), # 13
        root_alg('h238e', "R U' B2 U' R2 F2 D L2 D' F2 R2 U2 R'"), # 13
        root_alg('h238f', "R U' B2 D' F2 L2 D B2 U' F2 R2 U2 R'"), # 13
        root_alg('h459', "R U2 R' U2 R' U2 B' R B U2 R2 U2 R'"), # 13
        root_alg('h107', "R' U2 R2 U2 R U2 R' U2 R U2 R2 U2 R'"), # 13
        root_alg('h476b', "R' U2 R2 B' R' B R U R2 U R2 U2 R'"), # 13
        root_alg('h425', "R B U2 B2 L2 U' R' U R L2 B U2 R'"), # 13
        root_alg('h939', "B' U R U' R' U2 B R B' U B U2 R'"), # 13
        root_alg('h13', "R U2 B' U' B2 R B' R' B2 U B U2 R'"), # 13
        root_alg('h26', "R U2 B' U' B2 R B2 R' B2 U B U2 R'"), # 13
        root_alg('h917', "R L U2 L' B U' L U' L2 B' L U2 R'"), # 13
        root_alg('h70', "R B U B' U L' U R' U' R L U2 R'"), # 13
        root_alg('h1099b', "R2 B' R' U' R' U R B R' U2 R U2 R'"), # 13
        root_alg('h578', "R U R' B' U' R' U R B U2 R U2 R'"), # 13
        root_alg('h905', "L' U B' R U R' B U' L U2 R U2 R'"), # 13
        root_alg('h934', "R B' U' B2 U' B2 U2 B R' U R U2 R'"), # 13
        root_alg('h466', "B' R' U' R U B R U R' U R U2 R'"), # 13
        root_alg('h37', "B2 U' R2 B R' B' R' U B2 U R U2 R'"), # 13
        root_alg('h384', "R2 L' D B' D' R2 L U' R2 B' R' B R'"), # 13
        root_alg('h648', "R' U2 R B' R2 B2 R U2 R' B2 R' B R'"), # 13
        root_alg('h3', "F' B L' U B' L U' F B' R U' B R'"), # 13
        root_alg('h1044', "R U B' U' R2 D2 R U R' D2 R2 B R'"), # 13
        root_alg('h318', "R B' U2 R B D B' D' R' B' U2 B R'"), # 13
        root_alg('h500', "B' R U2 R D' R' D2 B' D' B U2 B R'"), # 13
        root_alg('h639', "R U R' U' R B' U2 L' B' L U2 B R'"), # 13
        root_alg('h1063', "R U2 R' U2 R B' U2 L' B' L U2 B R'"), # 13
        root_alg('h547', "R' U' R B L U2 L' B' U' B' R B R'"), # 13
        root_alg('h1146', "B' R' U' R U B2 U B' U' B' R B R'"), # 13
        root_alg('h605', "B' R' U' R U B2 U2 B' U2 B' R B R'"), # 13
        root_alg('h849b', "R L' B R' L U2 L' B L B' R B R'"), # 13
        root_alg('h1124', "B U2 B2 R B R2 U R U B' R B R'"), # 13
        root_alg('h878', "B U B' U2 R' U R B U' B2 R B R'"), # 13
        root_alg('h792', "B' U' B U' B U B' U' B' U2 R B R'"), # 13
        root_alg('h758', "B' U' B U B U2 B' U2 B' U2 R B R'"), # 13
        root_alg('h508', "R U B U' B' U B' U' R' U R B R'"), # 13
        root_alg('h546b', "B U2 B2 U' B' U' B2 U B U R B R'"), # 13
        root_alg('h799c', "R' U2 R2 B D' R2 U2 D R2 B2 U B R'"), # 13
        root_alg('h315', "L2 U' L U' L U L U2 R D' B2 D R'"), # 13
        root_alg('h450b', "R D' R2 B' R' U' R U B U' R2 D R'"), # 13
        root_alg('h148b', "R F' L2 D2 F' D B D' F D2 L2 F R'"), # 13
        root_alg('h148', "R' F' L F R2 F' L D' B D L2 F R'"), # 13
        root_alg('h201c', "R2 U R' F' B U B' L' U2 L U F R'"), # 13
        root_alg('h521', "R B2 U2 B' U2 B' U' R B R' B' U R'"), # 13
        root_alg('h531', "R F' U2 B2 D L2 D' B' U' F B' U R'"), # 13
        root_alg('h704', "R U' L2 D' B D L2 U F U2 F' U R'"), # 13
        root_alg('h279', "R U' L D2 B L' U2 L B' D2 L' U R'"), # 13
        root_alg('h799', "R L U2 L' B U2 B' U' L U L' U R'"), # 13
        root_alg('h1210', "R2 U2 R2 B' U' R U B R2 U2 R' U R'"), # 13
        root_alg('h450c', "R U' B2 L' B' U' B U L U' B2 U R'"), # 13
        root_alg('h1097', "B' R B U' B2 D2 F' L' F D2 B2 U R'"), # 13
        root_alg('h391', "R U' R2 U' D' R U' R' U2 D R2 U R'"), # 13
        root_alg('h869', "R U B' U2 B' U B' U' B U2 B U R'"), # 13
        root_alg('h1175', "R' L' D2 L' F' D' L D' R2 B' L U R'"), # 13
        root_alg('h510', "B U L' U' L B' L' U2 R U' L U R'"), # 13
        root_alg('h1143', "B' U' R' U R B L' U R U' L U R'"), # 13
        root_alg('h59', "F' L' B' L F L' B U R U' L U R'"), # 13
        root_alg('h229', "L' U R B2 U' B' U2 B' U' B2 L U R'"), # 13
        root_alg('h962b', "R2 L2 D B' D' L B' R' U2 B L U R'"), # 13
        root_alg('h792b', "L' U' B' U B R U' B' U B L U R'"), # 13
        root_alg('h417d', "B2 D L' F B' R' F R F2 B L D' B2"), # 13
        root_alg('h4b', "B2 R' L U2 R2 L2 B' R2 L2 U2 R L' B2"), # 13
        root_alg('h4c', "R2 L2 B2 R' L U2 B' R2 L2 U2 R L' B2"), # 13
        root_alg('h842', "R L U' L' U R' B' R' U2 R2 B' R' B2"), # 13
        root_alg('h3e', "B2 R U' D B L2 U2 L2 B' U D' R' B2"), # 13
        root_alg('h3d', "B2 R F B' D F2 L2 F2 D' F' B R' B2"), # 13
        root_alg('h526', "R U' R' B2 R' B2 U B2 U' R2 U R' B2"), # 13
        root_alg('h1051b', "B2 R2 U L U' R2 U' R L' B2 R' U' B2"), # 13
        root_alg('h598', "R2 D' R2 D L' B2 D B2 D' L B2 U' B2"), # 13
        root_alg('h417e', "B2 U B' R' L F' L F R L2 B U' B2"), # 13
        root_alg('h909', "B R U' L U L' B' R' B U B U' B2"), # 13
        root_alg('h817', "B R B R' U2 L' U' B U B L U' B2"), # 13
        root_alg('h668', "B R B R' L' B L U R' U' R U' B2"), # 13
        root_alg('h509', "B D F' L D2 B R' D' F' R' F2 D2 B2"), # 13
        root_alg('h521b', "B2 R D' B' D B R' D' R2 D' R2 D2 B2"), # 13
        root_alg('h1131', "B L2 F' L' B D2 F' D2 R' D2 R F2 B2"), # 13
        root_alg('h205b', "R' L U L2 U2 R U L2 U2 L B2 L2 B2"), # 13
        root_alg('h193', "B' R B' L2 B2 R' U' R' U R B2 L2 B2"), # 13
        root_alg('h611', "B' R U R B U2 B' U' R' U' B' R2 B2"), # 13
        root_alg('h859', "B' R2 B U' B2 R2 B2 U' B' U2 B' R2 B2"), # 13
        root_alg('h945', "B2 R2 B2 R' U' R' U R B' R B' R2 B2"), # 13
        root_alg('h817b', "B2 R2 B R' D B U B' D' R B' R2 B2"), # 13
        root_alg('h690b', "F B2 D2 F B' L' F' D2 B R' F' R2 B2"), # 13
        root_alg('h190b', "R B2 D2 F L F' D2 R2 F R' F' R2 B2"), # 13
        root_alg('h685b', "F' B L2 F' D B' L2 F U' F B2 R2 B2"), # 13
        root_alg('h649', "B2 R' B2 U B2 D' R' U' D R' U R2 B2"), # 13
        root_alg('h293b', "B2 R2 U2 R2 U R2 B2 U2 B2 U R2 U2 B2"), # 13
        root_alg('h924', "B' R' U2 R B' U2 B' U B' U' B U2 B2"), # 13
        root_alg('h611b', "B' U2 B L' B L B D' F R2 F' D B2"), # 13
        root_alg('h735', "B2 R' B2 U' B2 R2 U' R' U D' R' D B2"), # 13
        root_alg('h159', "B U2 B D' R2 D B' U2 B D' R2 D B2"), # 13
        root_alg('h148c', "R' U' R B2 L' U2 B D' B' U2 D L B2"), # 13
        root_alg('h658b', "B' U' D L' B' L U' D' R' U2 B' R B2"), # 13
        root_alg('h3b', "B2 R' F B' D' F2 L2 F2 D F' B R B2"), # 13
        root_alg('h1096', "L' B R' L2 U2 L' U' B' U' B U R B2"), # 13
        root_alg('h1167', "B' U B' U' R B2 R' B L U2 L' U B2"), # 13
        root_alg('h406', "B2 U' B U B U' B' U' R B' R' U B2"), # 13
        root_alg('h178', "B2 U' B R B' R' B2 L U2 L' B2 U B2"), # 13
        root_alg('h118b', "R2 B2 U' F B R' F B' D L2 B2 D' F2"), # 13
        root_alg('h118c', "R2 B2 D' R L F' R' L D B2 R2 U' F2"), # 13
        root_alg('h628', "F L F L2 B' R' U R B U' L U' F2"), # 13
        root_alg('h818', "F2 L2 F U' R B L B' R' U F' L2 F2"), # 13
        root_alg('h825', "F' L' B L' B' L' F' R2 F L' F' R2 F2"), # 13
        root_alg('h40', "F R' F R' B2 D2 F L F' D2 B2 R2 F2"), # 13
        root_alg('h965b', "F R' F R' B2 D L' D L D2 B2 R2 F2"), # 13
        root_alg('h930', "R U2 R' U' F' U' F' D' B L' B' D F2"), # 13
        root_alg('h611c', "F' B' U2 R' U2 R U2 F' B D' L2 D F2"), # 13
        root_alg('h782', "F2 R2 D2 L B' L' D2 R2 F' R' F R F2"), # 13
        root_alg('h836', "L' B U2 R B R' U2 B2 U2 B2 L' B' L2"), # 13
        root_alg('h1163b', "L' B' R B R' B U2 R L' B' R' B' L2"), # 13
        root_alg('h939b', "L U2 L D' R' L B2 R' D2 R2 L' D' L2"), # 13
        root_alg('h1117d', "R L' D' B2 D2 L2 U' L' U L2 D' R' L2"), # 13
        root_alg('h1117e', "R L' U B2 U2 L2 D L' U L2 D' R' L2"), # 13
        root_alg('h369b', "L2 B2 L2 U' L2 B2 R D' B' D B R' L2"), # 13
        root_alg('h1103', "R L2 B R' B2 L B' R B R' L' B2 L2"), # 13
        root_alg('h538', "B L' B' L' B2 R2 D L D' R2 L' B2 L2"), # 13
        root_alg('h258b', "R L' B' R2 U2 R B' U' B U L' B2 L2"), # 13
        root_alg('h966', "L2 B2 R2 B' L B R' B2 L' B2 R' B2 L2"), # 13
        root_alg('h1006', "L' B2 R B R2 U2 R2 B L' B2 R' B2 L2"), # 13
        root_alg('h714', "L' U' B' U2 R' U R2 B2 L' B R' B2 L2"), # 13
        root_alg('h686', "R' L' B' U2 B R L' B2 U' B2 U B2 L2"), # 13
        root_alg('h379b', "R2 B2 L F2 L2 D' R' D R' B2 L' F2 L2"), # 13
        root_alg('h517', "R L' B' L U2 L' B2 L' B R B' R2 L2"), # 13
        root_alg('h4', "R2 L2 F2 R L' U2 F' U2 R' L F2 R2 L2"), # 13
        root_alg('h3c', "L2 B' U D' R' B2 U2 B2 R U' D B L2"), # 13
        root_alg('h939c', "L U2 L D R2 L D2 R B2 R L' D L2"), # 13
        root_alg('h1163c', "L' U' B' U2 B U' L' D' R B' R' D L2"), # 13
        root_alg('h763', "L U2 L2 U' L2 U' L D' R B2 R' D L2"), # 13
        root_alg('h1057', "L' B' U' B U D' R2 D L' D' R2 D L2"), # 13
        root_alg('h606', "L' B' R B' R' B L' U' L B L' U L2"), # 13
        root_alg('h943', "R B' L U2 L' B U2 B' U2 B' R B' R2"), # 13
        root_alg('h824d', "R U B U' B' D L2 D' R D L2 D' R2"), # 13
        root_alg('h1075b', "R U2 R' U' R U R D L' B2 L D' R2"), # 13
        root_alg('h1205', "R' U2 R2 U R2 U R' D R' U2 R D' R2"), # 13
        root_alg('h1179', "R D L' B' R' L U B' R B R D' R2"), # 13
        root_alg('h751b', "R F2 B2 D' F L F2 D B2 R F' U' R2"), # 13
        root_alg('h258', "R2 U R' U' B U B' U R' U' R2 U' R2"), # 13
        root_alg('h875', "R2 U R2 B' U' R2 U R2 B U R2 U' R2"), # 13
        root_alg('h1075c', "R2 L' U R U' D B2 D' L U R U' R2"), # 13
        root_alg('h1148', "R2 B2 D B' R' F' L F R B D' B2 R2"), # 13
        root_alg('h978b', "R U L' B' L2 F U F' U R L' B2 R2"), # 13
        root_alg('h1148b', "R2 B2 U R' F' L' B L F R U' B2 R2"), # 13
        root_alg('h592b', "L2 F2 B2 R D L D' R D L F2 B2 R2"), # 13
        root_alg('h302', "R2 B2 R' B D' R' U2 R D B' R B2 R2"), # 13
        root_alg('h431', "R2 B2 R' L' B' L B U B' U' R B2 R2"), # 13
        root_alg('h431b', "R L U2 L2 B L B U B' U' R B2 R2"), # 13
        root_alg('h299', "R2 B2 R2 B' U' B R U B U' R B2 R2"), # 13
        root_alg('h379c', "R2 F2 R' B2 L' D L' D' L2 B2 R F2 R2"), # 13
        root_alg('h340', "R' L2 B R B' R' L B' L U2 R' U2 R2"), # 13
        root_alg('h450', "R2 B' D R' U' R U B U' B' D' B R2"), # 13
        root_alg('h864', "R L U' D2 R' U R D2 L' B' R B R2"), # 13
        root_alg('h716b', "R B U B U2 B2 R2 D' R U' R2 D R2"), # 13
        root_alg('h65', "R2 U B' U' R U R2 B R U' R' U R2"), # 13
        root_alg('h298', "B' D R' B2 U R U2 R' U' B2 R D' B"), # 13
        root_alg('h444b', "F B2 D2 F L' F' D2 B2 R' B' R F' B"), # 13
        root_alg('h1195', "B' L F2 B' R F' R' F B R' F2 L' B"), # 13
        root_alg('h60', "B R' U2 R U B2 U B2 U L U2 L' B"), # 13
        root_alg('h1075e', "B R B2 D B2 D' R2 U L U2 R L' B"), # 13
        root_alg('h591', "B U2 B' R2 U2 B' R B U2 R' B' R' B"), # 13
        root_alg('h563', "R U B' R B R2 B' R B U' B' R' B"), # 13
        root_alg('h880', "L U L2 B L B2 R U B U' B' R' B"), # 13
        root_alg('h760', "L' B2 L2 U' R' U R2 L2 B2 L B' R' B"), # 13
        root_alg('h1139', "B' U' R2 U R2 B R U' R' U B' R' B"), # 13
        root_alg('h1009', "B' U' B' R B2 U' B' U2 B U B' R' B"), # 13
        root_alg('h1050', "R' F' R B' R D2 B' L2 D' B D' R' B"), # 13
        root_alg('h637', "R U2 R' U' B' R2 U R U' R' U' R' B"), # 13
        root_alg('h472', "B' R B2 R U2 B' U' B U' R' B2 R' B"), # 13
        root_alg('h78', "B R L2 D2 R D' F D' R' L2 B2 R' B"), # 13
        root_alg('h849', "B L' B L B R B' L' B' L B2 R' B"), # 13
        root_alg('h579', "B' U' R U B' U R2 U' R2 U' B R' B"), # 13
        root_alg('h39', "R B2 L2 D L B D2 B' D L B R' B"), # 13
        root_alg('h1193b', "B U L U' L2 B' L U2 B2 R B R' B"), # 13
        root_alg('h1202', "B2 R2 B U R2 B U' B2 R' B U R' B"), # 13
        root_alg('h823', "R U R' U2 B2 R' D' R2 D B R' U' B"), # 13
        root_alg('h319', "B2 R B L' D B D' R2 L U' R U' B"), # 13
        root_alg('h974c', "L F L' B L F' B2 D2 F2 R F2 D2 B"), # 13
        root_alg('h103b', "B' D' R2 U' D L B2 L' D2 R U D2 B"), # 13
        root_alg('h1139b', "B' U' R2 U R' U' D R' U R D' R2 B"), # 13
        root_alg('h201b', "L U L2 B L B2 U R' F R' F' R2 B"), # 13
        root_alg('h630', "B' R2 U' R U' R2 B' R' B R2 U2 R2 B"), # 13
        root_alg('h1071', "B' R2 U' R U' R2 U R U' R U2 R2 B"), # 13
        root_alg('h407', "B' R2 U' D' F' U F L F L' D R2 B"), # 13
        root_alg('h546', "B' R' B U B' R' U' B' R2 B U R2 B"), # 13
        root_alg('h507', "B' U2 R U B' R' B2 R U' R' B' U2 B"), # 13
        root_alg('h210', "R B U B' U2 B' U B U R' B' U2 B"), # 13
        root_alg('h1075', "L' U R U' L B' U B U R' B' U2 B"), # 13
        root_alg('h552', "B' U2 R U B' U' R' U B2 U' B' U2 B"), # 13
        root_alg('h1197', "R U2 R' U' B' R U' R' B U' B' U2 B"), # 13
        root_alg('h443b', "L U L' B' R' U' R U' B U' B' U2 B"), # 13
        root_alg('h635', "L U L' B2 R B R' U2 B U' B' U2 B"), # 13
        root_alg('h1036b', "R L2 D' B' D B L2 B' R' U2 B' U2 B"), # 13
        root_alg('h1195c', "L' D' R B R' L U L' D L B' U2 B"), # 13
        root_alg('h827c', "B' R' U2 R U' R' L U' R U L' U2 B"), # 13
        root_alg('h104d', "B' R' B2 D2 F2 L' U' F2 U D2 B2 U2 B"), # 13
        root_alg('h104c', "B' L' D2 F2 U2 R' U' F2 U D2 B2 U2 B"), # 13
        root_alg('h250', "R' U2 B L' B' L U2 R B U2 B2 U2 B"), # 13
        root_alg('h1121', "B' U2 L' U B R B' R' U' B' L U2 B"), # 13
        root_alg('h1121b', "B' U2 L' B' R B D B' D' R' L U2 B"), # 13
        root_alg('h336', "B' R B U B' U2 L' U R' U' L U2 B"), # 13
        root_alg('h458', "B2 R B2 R' B U B2 U L' B L U2 B"), # 13
        root_alg('h450d', "B' U2 R' L' U' L U' L' U2 R L U2 B"), # 13
        root_alg('h637b', "F' B2 D L' D' F B D' F R F' D B"), # 13
        root_alg('h110', "B2 D' B R B2 U B' R' U' B' R' D B"), # 13
        root_alg('h110b', "B2 D' R D B' U B2 D' R' U' R' D B"), # 13
        root_alg('h54', "B' R2 L' U2 R' D B D' R U2 R2 L B"), # 13
        root_alg('h429', "B2 U2 B' U2 B U2 R L' B R' B L B"), # 13
        root_alg('h262', "B' R2 U' B' R' B U R B U2 B' R B"), # 13
        root_alg('h112b', "L2 B2 R B2 L B' R2 U2 B L B' R B"), # 13
        root_alg('h460', "F' L F R' F2 L' F' R B' R' F' R B"), # 13
        root_alg('h911', "L U L2 B' L U L U' R' L' U' R B"), # 13
        root_alg('h1169', "L2 D L' U2 L D' L2 U' B' R' U' R B"), # 13
        root_alg('h577', "B' R' U' R U R' U R U' R' U' R B"), # 13
        root_alg('h1146b', "B' R' U' R U2 R B' R' B R' U' R B"), # 13
        root_alg('h978', "B' R B U B' R2 U R2 U2 R2 U' R B"), # 13
        root_alg('h543', "B' U' B U B' U B U2 B' R' U2 R B"), # 13
        root_alg('h776', "B2 D' R' D B' D B D2 R D B R B"), # 13
        root_alg('h417', "L U2 L' U' L U' L' B' U' R' U R B"), # 13
        root_alg('h402', "R' F2 L F L' F R B' U' R' U R B"), # 13
        root_alg('h747', "B' R B2 R' B2 L U2 L' U R' U R B"), # 13
        root_alg('h638', "F2 R2 B L' D' L B' R2 F2 U2 B' U B"), # 13
        root_alg('h1062', "B' R' U R2 B R' U2 R' U2 R B' U B"), # 13
        root_alg('h821', "R' B' U' R2 U R2 U' R2 B R B' U B"), # 13
        root_alg('h368', "R U B U' B' R' B' U2 B U B' U B"), # 13
        root_alg('h1064', "L' B2 R B2 L B' R' U2 B U B' U B"), # 13
        root_alg('h958', "B' U' R2 U2 R' B R U2 R' B' R' U B"), # 13
        root_alg('h510b', "R2 D R' U R D' R2 B' R U' R' U B"), # 13
        root_alg('h303d', "R L' D' B' D R' L B2 R B R' U B"), # 13
        root_alg('h952b', "B' U2 B2 U L U' L' B R B R' U B"), # 13
        root_alg('h482', "B U B2 R' U' R B2 L U' L' B2 U B"), # 13
        root_alg('h6b', "B' R2 U2 L U' R U R' L' U2 R2 U B"), # 13
        root_alg('h525', "L U' L' B' R2 U2 B' R' B U2 R2 U B"), # 13
        root_alg('h754', "R U R' U2 B' R' U' R' B' R2 B U B"), # 13
        root_alg('h851', "B2 R2 B2 U B' R2 B U' B2 R2 B U B"), # 13
        root_alg('h1116', "B U' B' R B' R2 U R L' B2 L U B"), # 13
        root_alg('h310', "L U2 L' U' L U' L' B' R' U' R U B"), # 13
        root_alg('h474', "R' U2 R U R' U R B' R' U' R U B"), # 13
        root_alg('h1103b', "B D F' L F D' B2 U' R' U2 R U B"), # 13
        root_alg('h725b', "F' B U' D2 R F R' U D2 L' B' L' F"), # 13
        root_alg('h430', "R' F2 R' L B R F2 R' B' R2 F' L' F"), # 13
        root_alg('h727', "F2 L F' B2 D2 B R' B' D2 F2 B2 L' F"), # 13
        root_alg('h160', "R D2 L' U2 B' L D2 R' F' L F2 L' F"), # 13
        root_alg('h774b', "F' U F2 L2 D B' R B D' L2 F2 U' F"), # 13
        root_alg('h1009c', "R B' U' B R' U F' B L' B' L U' F"), # 13
        root_alg('h902b', "L2 F2 B2 R D2 R' F2 L' F' L B2 L2 F"), # 13
        root_alg('h653', "F' R U2 L' U' B U' B' L U2 R' U2 F"), # 13
        root_alg('h79', "F2 D B' R' B D' F D' B L B' D F"), # 13
        root_alg('h824b', "R U B U' B' R2 F' L' F R F' L F"), # 13
        root_alg('h654b', "R' F2 L F' R F2 L2 U2 B' U2 B L F"), # 13
        root_alg('h974d', "F B' D2 B2 L B2 D2 R B R' F2 R F"), # 13
        root_alg('h453', "L' B' R B' R' B2 L F' L' U' L U F"), # 13
        root_alg('h1103c', "F D B' R2 B D' F2 U' L' U L U F"), # 13
        root_alg('h584', "R U2 R' F2 L F L B L2 F L' B' L"), # 13
        root_alg('h54b', "L' B R2 F B2 U R U' F' B2 R2 B' L"), # 13
        root_alg('h485', "L' U' B2 U B' R' U' R U' B' U2 B' L"), # 13
        root_alg('h885', "L2 B R2 F D B D' F' B' R2 L B' L"), # 13
        root_alg('h1172', "L2 D' R B R' D L2 U L2 B L B' L"), # 13
        root_alg('h322', "L F U R' F R' U' L2 D B2 R2 D' L"), # 13
        root_alg('h263', "R2 L' D B D' R' B L U2 L' B' R' L"), # 13
        root_alg('h1132', "B' R' U' R U' B U2 R B L' B' R' L"), # 13
        root_alg('h1034', "B U B' U' L' B' L U2 R L' B' R' L"), # 13
        root_alg('h947', "R' L' U2 L U L' U R2 D B2 D' R' L"), # 13
        root_alg('h804b', "R U R' F U F' R L' B' U' B R' L"), # 13
        root_alg('h489', "R2 L' B' L B2 R' B L U2 L2 B R' L"), # 13
        root_alg('h834b', "B' U2 B U L U' R L2 D' B D R' L"), # 13
        root_alg('h664', "R B U2 L' U2 L U2 B' U' L' U R' L"), # 13
        root_alg('h1181b', "R U' B2 U' L' U2 L U B2 L' U R' L"), # 13
        root_alg('h367', "R2 L' D' R D R U R U2 B2 U R' L"), # 13
        root_alg('h820', "L U2 R L2 B' U' L B' L' B U R' L"), # 13
        root_alg('h1040b', "L' U2 R2 B D B2 D' R' U2 B U R' L"), # 13
        root_alg('h973b', "R L' U' B2 U2 B2 U2 B' U' B' R' U' L"), # 13
        root_alg('h587', "R L' U B2 D' B U' B' D B2 R' U' L"), # 13
        root_alg('h529', "R L' U' B2 U2 B U B U B2 R' U' L"), # 13
        root_alg('h492', "R' U L' U R2 B' R2 U2 R2 B R' U' L"), # 13
        root_alg('h873', "B L' B' R B2 L B2 U' L' U R' U' L"), # 13
        root_alg('h1084', "B L U L' U' B' R U' L' U R' U' L"), # 13
        root_alg('h1001', "B' U' R' U R B R U' L' U R' U' L"), # 13
        root_alg('h406b', "R L' U' B U B R B2 R' U R' U' L"), # 13
        root_alg('h322b', "L F U R' F R' D' B2 D R2 F2 U' L"), # 13
        root_alg('h680', "L' U2 R2 B' D L' B L D' B R2 U' L"), # 13
        root_alg('h1111', "L2 B2 L B2 L U' L' U R' U R U' L"), # 13
        root_alg('h999', "R B' R' U2 B' U2 R B R' U2 L' B2 L"), # 13
        root_alg('h134', "F U F' U L' B' R' U2 R2 B' R' B2 L"), # 13
        root_alg('h452c', "L' B' R' U2 R U2 R' U2 R2 B' R' B2 L"), # 13
        root_alg('h324', "B L U L' U' B' L' B' R B' R' B2 L"), # 13
        root_alg('h102', "L U2 L' U' L U' L2 B' R B' R' B2 L"), # 13
        root_alg('h201', "B L2 D L D2 B D B R B' R' B2 L"), # 13
        root_alg('h162', "L' B' U' B U B2 R2 D' R' D R' B2 L"), # 13
        root_alg('h461', "L' B' R B' R' L2 U' R' U R L2 B2 L"), # 13
        root_alg('h994', "R B2 L' D L' D R F' L D2 R2 B2 L"), # 13
        root_alg('h456c', "L U L' U L' B2 R D2 R D2 R2 B2 L"), # 13
        root_alg('h165', "L2 B2 R B R' B' R2 B' L B R2 B2 L"), # 13
        root_alg('h205', "L' B2 R D' R D R' D' R D R2 B2 L"), # 13
        root_alg('h498', "L' U' B2 D' F R2 F' B U' B' D B2 L"), # 13
        root_alg('h356b', "L2 D L B2 R D' R' B2 D2 B2 D B2 L"), # 13
        root_alg('h778', "B' R B2 L' B R' D2 R2 D R2 D B2 L"), # 13
        root_alg('h911b', "L' D2 R' B R2 B R2 B2 R2 B R' D2 L"), # 13
        root_alg('h1189', "L' B2 D' R' D B2 D2 R U R' U' D2 L"), # 13
        root_alg('h147b', "L' D2 R2 D2 B2 D' B' D B' D2 R2 D2 L"), # 13
        root_alg('h1023', "L' U R2 D B' D' B R2 U' R2 B' R2 L"), # 13
        root_alg('h834', "F' U2 F U R U R L' D B D' R2 L"), # 13
        root_alg('h147', "R2 L' D2 R2 B2 D' B' D B' R2 D2 R2 L"), # 13
        root_alg('h1079', "R2 B2 R2 L' B L B' R2 B2 L' B R2 L"), # 13
        root_alg('h1036', "F2 D B' R' B D' F' U F' U' L' U2 L"), # 13
        root_alg('h868b', "B' L F2 D2 R D2 F2 L' B U2 L' U2 L"), # 13
        root_alg('h868', "B' R U2 F2 R F2 U2 R' B U2 L' U2 L"), # 13
        root_alg('h507b', "R L' U' L U2 B U' B' R' U L' U2 L"), # 13
        root_alg('h899', "R L' U' L2 U2 R' U R U2 R' L2 U2 L"), # 13
        root_alg('h817e', "F R U2 B' R B R2 F2 L F L2 U2 L"), # 13
        root_alg('h380b', "R L' B' R' U2 R2 L' B' L B R2 U2 L"), # 13
        root_alg('h380', "R L' B R' U2 R2 B' L' B R2 L U2 L"), # 13
        root_alg('h118', "B' R2 U' B2 R' B U B U R2 L' B L"), # 13
        root_alg('h710b', "L' B L' B2 R B2 R' B2 L2 U2 L' B L"), # 13
        root_alg('h132', "R B' R' U' L U' L' B2 U B L' B L"), # 13
        root_alg('h754b', "L U L' B' R' U' R2 B L' B' R' B L"), # 13
        root_alg('h121', "L' B' R B2 D2 L' D' L D' B2 R' B L"), # 13
        root_alg('h112', "L' B2 R' L2 F R' F' R' L2 B R' B L"), # 13
        root_alg('h521c', "L2 U' L B' L' U R' L U R U' B L"), # 13
        root_alg('h121b', "L' B' R B2 R' B2 U' L U' L' U2 B L"), # 13
        root_alg('h157b', "L2 B2 R B' R' L B2 L U2 L' U2 B L"), # 13
        root_alg('h878b', "F U F' U2 L' U' B2 R B R' U2 B L"), # 13
        root_alg('h157', "L2 B2 R B' D2 R D2 R' B2 R' L B L"), # 13
        root_alg('h340b', "L2 B R B' D2 B' D2 B D2 R' L B L"), # 13
        root_alg('h848b', "L B' R' U F U' F' B L2 B' R B L"), # 13
        root_alg('h839', "L2 B' L U' R' U L' B L B' R B L"), # 13
        root_alg('h654', "F' L' B L2 F L2 B2 U R' U2 R B L"), # 13
        root_alg('h1066', "R' U L' U2 R U R B' R2 U2 R B L"), # 13
        root_alg('h710', "L' B L' B2 R B2 L B2 R2 U2 R B L"), # 13
        root_alg('h385', "R B2 L' B' L B' R' L' U' B' U B L"), # 13
        root_alg('h417c', "R U R' U R U2 R' L' U' B' U B L"), # 13
        root_alg('h401', "L' D' B R2 B R' B R B2 R2 B' D L"), # 13
        root_alg('h1117c', "L' D2 R' U R U' D R B2 R' B2 D L"), # 13
        root_alg('h403', "L2 D2 R' D2 L B2 U D' R U' R D L"), # 13
        root_alg('h1107', "R' U L' U2 R U2 B' U B R' U2 R L"), # 13
        root_alg('h6', "R' U L' U2 R2 B U B' U' R2 U2 R L"), # 13
        root_alg('h428', "L2 B2 R B R' B2 L2 U L' U' B' U L"), # 13
        root_alg('h70b', "R B U B' U L' U L U2 R' L' U L"), # 13
        root_alg('h674', "R B U2 L' U2 L U2 B' R' U' L' U L"), # 13
        root_alg('h303b', "L' U2 R L U' L' U R' L U L' U L"), # 13
        root_alg('h303', "R U R' L' U2 R U R' L U L' U L"), # 13
        root_alg('h245', "R U B U' B' R' L' U2 L U L' U L"), # 13
        root_alg('h692', "R L' B2 U' B2 U B U2 B U R' U L"), # 13
        root_alg('h395', "R U2 R' U' R U' R' L' B' U' B U L"), # 13
        root_alg('h945b', "L D2 R F R' D2 L B' L U' B U L"), # 13
        root_alg('h119b', "L' B2 R B R' U R' U' R U' B U L"), # 13
        root_alg('h912', "R U' L' U2 R' B' R U' R' U2 B U L"), # 13
        root_alg('h954', "L2 B2 R B2 L B' R2 U' R U2 B U L"), # 13
        root_alg('h661', "L2 F2 R2 D R' B2 R D' R2 F2 L U L"), # 13
        root_alg('h972', "B' U B U R' B R2 U2 B2 U2 R2 B' R"), # 13
        root_alg('h474b', "R' U2 F2 U2 B L F' L F2 L2 F B' R"), # 13
        root_alg('h738', "R' B U L U R U2 L' U' R' U B' R"), # 13
        root_alg('h774', "R' D B2 R2 U L' B L U' R2 B2 D' R"), # 13
        root_alg('h301', "R' D B2 U2 D' B' R2 B U2 D B2 D' R"), # 13
        root_alg('h776b', "R2 D R' B R D B' D' R' B' R2 D' R"), # 13
        root_alg('h848', "R2 D B R' U' R' U2 R B' U2 R2 D' R"), # 13
        root_alg('h827', "R2 U R2 U R2 U' R D R' U' R D' R"), # 13
        root_alg('h827b', "R' D R U' R2 U R2 U R2 U2 R D' R"), # 13
        root_alg('h974b', "B D2 F2 L F2 D2 F B2 R B R' F' R"), # 13
        root_alg('h804c', "R2 L2 D B D B' D2 R2 L2 U R' F' R"), # 13
        root_alg('h360', "R' F L2 F2 B L' F' L F' B' L2 F' R"), # 13
        root_alg('h559', "R' B U2 B2 U' R' U R B2 U' B' U' R"), # 13
        root_alg('h443', "B' R' B U' R' U' R U' B U' B' U' R"), # 13
        root_alg('h514', "R' F' U' F B L2 D F D' L2 B' U' R"), # 13
        root_alg('h870', "R' U' B L2 F L' F L F' L2 B' U' R"), # 13
        root_alg('h854', "B U L U' L' B' L U' R' U L' U' R"), # 13
        root_alg('h1117', "R B' R U' B R B' U R2 B R' U' R"), # 13
        root_alg('h1104', "R' U R2 B2 U R' B R U' B2 R2 U' R"), # 13
        root_alg('h557', "R2 B U' L U R L' U R' B' R U' R"), # 13
        root_alg('h682', "R2 U2 R2 B L U' L' B' R2 U2 R U' R"), # 13
        root_alg('h103', "R' B' U2 F' B D L2 D' B2 U F B2 R"), # 13
        root_alg('h433', "R B R2 D2 L F L' U L U' L' D2 R"), # 13
        root_alg('h350', "R B U' L U R2 L' D2 L2 F L2 D2 R"), # 13
        root_alg('h222', "B L U L' U' L U' L' B' U' R' U2 R"), # 13
        root_alg('h602', "B U' L' B L2 U L' U' B2 U' R' U2 R"), # 13
        root_alg('h1149', "R' U2 R' D' R U R' D R2 U' R' U2 R"), # 13
        root_alg('h246', "B' R' U' R U B R' U' R U' R' U2 R"), # 13
        root_alg('h398', "B L U' L' B' U' R' U R U' R' U2 R"), # 13
        root_alg('h952', "R' U R B U' B' R' U' R U2 R' U2 R"), # 13
        root_alg('h964', "R' U2 R B L U' L' U' B' U R' U2 R"), # 13
        root_alg('h393', "B2 L2 U B' L' B U' L2 B2 U R' U2 R"), # 13
        root_alg('h1130', "R' U2 B' U' B U B' R2 B' R2 B2 U2 R"), # 13
        root_alg('h407c', "B' R B2 D2 L' B L B' D2 B' R2 U2 R"), # 13
        root_alg('h1199', "R' U' R2 B U' B' U2 B U B' R2 U2 R"), # 13
        root_alg('h192', "R U2 R' U2 B U B2 R B U' R2 U2 R"), # 13
        root_alg('h339', "R B2 D B2 R' U' R B2 D' B2 R2 U2 R"), # 13
        root_alg('h844', "R B2 R' B L' B L B' R B2 R2 U2 R"), # 13
        root_alg('h456', "L U L' U R' U2 R B2 R B2 R2 U2 R"), # 13
        root_alg('h1198', "R2 D' R U2 R' D R2 B' R B R2 U2 R"), # 13
        root_alg('h257', "R' U2 R U R' U' R B' R B R2 U2 R"), # 13
        root_alg('h966c', "L U2 L' U2 L' B2 L B R B R2 U2 R"), # 13
        root_alg('h966d', "R B2 L' B2 R' B2 L B R B R2 U2 R"), # 13
        root_alg('h966b', "R B2 R' U2 R' U2 R B R B R2 U2 R"), # 13
        root_alg('h529b', "R' U2 B L U L' B2 D' R2 D B U2 R"), # 13
        root_alg('h625', "R' U2 R B' U2 B U R' B' U B U2 R"), # 13
        root_alg('h736', "B' R B R2 L D F2 D' L2 U L U2 R"), # 13
        root_alg('h1088', "B' R' B U R B U' B' R2 U2 R U2 R"), # 13
        root_alg('h902', "L' B L F' L2 B' L F R' F' L F R"), # 13
        root_alg('h722', "R D L' B L D' R2 F' L' U' L F R"), # 13
        root_alg('h916', "L U2 L' U2 L' B L2 U' L' B' R' U R"), # 13
        root_alg('h916b', "R B2 L' B2 R' B L2 U' L' B' R' U R"), # 13
        root_alg('h170', "B' U' R' U R B2 L U' L' B' R' U R"), # 13
        root_alg('h69', "R' U2 R2 B2 L' B' L B' R' U' R' U R"), # 13
        root_alg('h69b', "L U2 L2 B2 R B' L B' R' U' R' U R"), # 13
        root_alg('h754c', "L U2 L2 B L B R B2 R' U' R' U R"), # 13
        root_alg('h303c', "L' B' U R' U' R2 B R' L U' R' U R"), # 13
        root_alg('h643', "L' U2 L B U' L' U' B L B2 R' U R"), # 13
        root_alg('h713', "B2 L2 B' U L' U' B L2 B2 U2 R' U R"), # 13
        root_alg('h1048b', "L2 B2 L B' U' B L' B2 L2 U2 R' U R"), # 13
        root_alg('h119', "R' U' R2 U R2 U R2 U2 R' U R' U R"), # 13
        root_alg('h1181', "R2 B2 R2 U2 R' U2 R' B2 R2 U R' U R"), # 13
        root_alg('h68', "R U2 R' U' R U' R2 U2 R U R' U R"), # 13
        root_alg('h102b', "R B L' B L B2 R2 U2 R U R' U R"), # 13
        root_alg('h1141', "L' U R U' L U R2 U2 R U R' U R"), # 13
        root_alg('h513', "R U R' U R' U' R2 B U' B' R2 U R"), # 13
        root_alg('h906', "B' R B R' U2 R U B U' B' R2 U R"), # 13
        root_alg('h110c', "R U2 D B' U2 B' U2 B U2 D' R2 U R"), # 13
        root_alg('h1172b', "R2 D' L F L' D R2 B' R B R2 U R"), # 13
        root_alg('h1058', "R B' R' B U2 B U' B2 R B R2 U R"), # 13
        root_alg('h444', "B' U' R' U R B2 U B2 R B R2 U R"), # 13
        root_alg('h305', "B L F' L F L2 B' R' F' U' F U R"), # 13
        root_alg('h368b', "R L' D B2 D' R2 L U' F' U F U R"), # 13
        root_alg('h379', "L U2 R' L' F' U B' U B U F U R"), # 13
        root_alg('h1048', "L2 B2 L B' U' B R B2 R2 U2 L U R"), # 13
        root_alg('h1163', "B' R' B U' R' U2 B' R B U R U R"), # 13

        root_alg('h1208c', "B L' D F2 U2 R U R2 F' R F' U D' B'"), # 14
        root_alg('h845c', "R' U' R U' L F' L' B L F2 U2 F' L' B'"), # 14
        root_alg('h986', "B2 L2 F' L2 B' L F2 R U R' U F' L' B'"), # 14
        root_alg('h202b', "R' U' R B L' U2 L2 U L2 U L2 U' L' B'"), # 14
        root_alg('h1208', "R U2 R' B R B' U2 B R' U L U' L' B'"), # 14
        root_alg('h1010', "B' R2 F R2 B R' F' R B U L U' L' B'"), # 14
        root_alg('h1010b', "F' U2 F U2 F R' F' R B U L U' L' B'"), # 14
        root_alg('h463', "B U B2 R B R2 U R B U L U' L' B'"), # 14
        root_alg('h314', "B' U2 D2 F U2 F' U2 F R' F' D2 B2 L' B'"), # 14
        root_alg('h1052c', "R U R F2 B2 L2 D' B R2 B2 L' F2 L' B'"), # 14
        root_alg('h57', "R B2 U B' U' R' U2 L B U2 B' U2 L' B'"), # 14
        root_alg('h532', "R L' B2 D' B' D2 L' D' L' B' R' B L' B'"), # 14
        root_alg('h752', "R L' B D' R' B R D L2 B' R' B L' B'"), # 14
        root_alg('h344', "B' R B2 L' B D' B D R' B2 L2 U L' B'"), # 14
        root_alg('h220', "B' R' U' R U B R' U' R B L U L' B'"), # 14
        root_alg('h622c', "B L U2 R U' L' D B' U2 B U D' R' B'"), # 14
        root_alg('h329b', "B2 L' B' L B U2 B U2 B' U2 R B2 R' B'"), # 14
        root_alg('h845b', "B R B2 D' B U B' R2 U R2 U2 D R' B'"), # 14
        root_alg('h58', "R B U B' U' R' B U L' B L B' U' B'"), # 14
        root_alg('h520b', "R L' B2 R' L U' R B R' B U B' U' B'"), # 14
        root_alg('h858', "B' R B R' U2 B L F U F' U2 L' U' B'"), # 14
        root_alg('h852', "B U2 B' U B R B' L' B L B R' U' B'"), # 14
        root_alg('h286b', "B L' B' U R' U' R2 B2 L B R' B2 U' B'"), # 14
        root_alg('h55c', "B' D' R U' R U2 R U' R' U' D B2 U' B'"), # 14
        root_alg('h25', "B' U' B2 U R' U' R L U' L' U B2 U' B'"), # 14
        root_alg('h700', "B L2 D L B2 R2 D' R2 B2 L' D' L2 U' B'"), # 14
        root_alg('h389', "B' R' U' R U' B2 U L' D L' D' L2 U' B'"), # 14
        root_alg('h877c', "R' U' R B L' B' L U2 L U2 L' B U' B'"), # 14
        root_alg('h877d', "R' U' R B L' B' R B2 L B2 R' B U' B'"), # 14
        root_alg('h980', "B' U2 B2 U B2 R' U R B' L' B' L U' B'"), # 14
        root_alg('h316', "B L U R' U L' U' L U L' U' R U' B'"), # 14
        root_alg('h91b', "B U2 D2 R B2 U B' U B2 U2 B2 R' D2 B'"), # 14
        root_alg('h30', "R F' U2 F U2 R B D2 F' L U2 F D2 B'"), # 14
        root_alg('h1183b', "R B' R' F2 B2 D' L2 F U2 F' L2 D F2 B'"), # 14
        root_alg('h1106c', "L2 F2 B2 R' F R' B R F2 R F' B2 L2 B'"), # 14
        root_alg('h986c', "F' B L2 D' B D2 F' D R' B' D2 F2 L2 B'"), # 14
        root_alg('h419', "R B' R B R2 B U2 R2 B2 R' B2 R' U2 B'"), # 14
        root_alg('h1017c', "B U R B' L' B R' L U R B R' U2 B'"), # 14
        root_alg('h619', "R B2 R F2 L F L' F R' B R' B2 U2 B'"), # 14
        root_alg('h705', "R' U' R B' R2 B U' R U B' R2 B2 U2 B'"), # 14
        root_alg('h286', "R B' R' U B U R' U R B' U B2 U2 B'"), # 14
        root_alg('h589c', "L U L2 B L2 U R' U2 R L' U B2 U2 B'"), # 14
        root_alg('h1020', "B R2 U B' U' R2 U' R U' R B R2 U2 B'"), # 14
        root_alg('h196b', "B' R' U' R U B2 U2 B2 R B R' B U2 B'"), # 14
        root_alg('h51', "R' U2 R U' B U2 B' R' U2 R U' B U2 B'"), # 14
        root_alg('h91', "R B2 R' U B' U R' U2 R B2 U2 B U2 B'"), # 14
        root_alg('h572d', "R B2 L' D L' D' L2 B R' B U2 B U2 B'"), # 14
        root_alg('h895b', "L' B2 L B' R B R' L' B' L U2 B U2 B'"), # 14
        root_alg('h1052b', "B D' F' L F' R L' D' L D R' F2 D B'"), # 14
        root_alg('h320b', "F2 U' F' U2 F' B' R' F R B2 D' L2 D B'"), # 14
        root_alg('h400c', "B D' R' D2 R' U L U' R L' D2 R D B'"), # 14
        root_alg('h980b', "F' U R' L' F' U F U' R L B U' F B'"), # 14
        root_alg('h980c', "F' U L' U' R B' R' B U L B U' F B'"), # 14
        root_alg('h1033', "B U' L' B2 D L' F2 L D2 R D B2 L B'"), # 14
        root_alg('h235', "L2 D R' F2 R D' L' U' L' U' L' B L B'"), # 14
        root_alg('h535', "R B U B' U' R' L U L' U' L' B L B'"), # 14
        root_alg('h1017b', "L U' R L' U B U' B' R' U L' B L B'"), # 14
        root_alg('h1142', "R2 B2 L' B' L B L' B R' B R' B L B'"), # 14
        root_alg('h260', "B2 L' B' R' L B R2 U2 B' U2 R2 B' R B'"), # 14
        root_alg('h845', "B R' B2 D B U B' D2 R2 D B2 U' R B'"), # 14
        root_alg('h981', "B U R' U' R U' L U' R' U' L' U2 R B'"), # 14
        root_alg('h541', "B U L' B L2 U' L' U' B' U' R' U2 R B'"), # 14
        root_alg('h400b', "B R' D' R2 U D' L U' L' D R2 D R B'"), # 14
        root_alg('h622', "B2 U' B2 R B R' B U' L U2 L' B' U B'"), # 14
        root_alg('h334', "B R B R' U R' U' R2 B' R' U' B' U B'"), # 14
        root_alg('h334b', "B2 U R2 U' R2 B' D B' D' B U' B' U B'"), # 14
        root_alg('h1072', "B2 U2 B U' R' U R B2 U B U2 B' U B'"), # 14
        root_alg('h337', "B R B' L' B' L B' U B' U' B2 R' U B'"), # 14
        root_alg('h29', "R B' R' B2 U2 R B2 U B U' B2 R' U B'"), # 14
        root_alg('h1120b', "B U R' U2 L U R L' U R' U R U B'"), # 14
        root_alg('h898c', "L' F' B L F L2 B' U L2 D R' F R D'"), # 14
        root_alg('h312c', "L2 B2 L' F' L B2 L2 F U F R U' R' F'"), # 14
        root_alg('h737b', "F R F B U F2 D' L2 D F B' U2 R' F'"), # 14
        root_alg('h956', "F' L F' L2 B L' B' L2 F' R U R' U' F'"), # 14
        root_alg('h852c', "F' U2 F' D' B L2 B' D F' R U R' U' F'"), # 14
        root_alg('h872b', "B L' B' L U2 L U2 L' F R U R' U' F'"), # 14
        root_alg('h872', "B L' B' R B2 L B2 R' F R U R' U' F'"), # 14
        root_alg('h223', "R B2 L' B' L B' R' F U2 F' U' F U' F'"), # 14
        root_alg('h56', "L' B' U' B U L F U F R' F' R U' F'"), # 14
        root_alg('h91d', "F' L' F U' B' U F B D2 B2 R' B2 D2 F'"), # 14
        root_alg('h495b', "L' B L F2 L B' L' F' D2 B' R B D2 F'"), # 14
        root_alg('h292', "L' B' L F2 R2 F' U2 L' B2 R B' L U2 F'"), # 14
        root_alg('h424b', "F2 B L B' R2 B L' B2 R' B R2 F' R F'"), # 14
        root_alg('h9', "R U R2 F2 D' R2 B L' B' R2 D F' R F'"), # 14
        root_alg('h1160', "F R' U' B2 L U' F2 U L2 D L B2 U F'"), # 14
        root_alg('h737c', "L B U D L D2 R' B2 R U' D L2 B' L'"), # 14
        root_alg('h207', "B U2 B' U' B U' B' L F2 R' F' R F' L'"), # 14
        root_alg('h378b', "L F2 R L2 B U' B' U R2 L2 F' R F' L'"), # 14
        root_alg('h955b', "R2 B2 R' L' U' B2 U B2 L U L U2 R' L'"), # 14
        root_alg('h280', "R U2 B' U2 B U L U' R' F U2 F' U' L'"), # 14
        root_alg('h711b', "R U L B L' U' L B' R' F U F' U' L'"), # 14
        root_alg('h378', "L' B' R B' R' B2 L2 U F' L F L' U' L'"), # 14
        root_alg('h334c', "B U2 B2 R' U' R B2 L U L2 B' L2 U' L'"), # 14
        root_alg('h233', "R' U L U' R U' L2 U' B' U B L2 U' L'"), # 14
        root_alg('h882', "B' U2 R' U B L' B' R U' B U L2 U' L'"), # 14
        root_alg('h634c', "B' U' R U2 F R F' U2 B' R' B2 L U' L'"), # 14
        root_alg('h684', "B L' B' L U' B' R B' R' B2 U2 L U' L'"), # 14
        root_alg('h1052', "R' U' F' U F R B L' B' L U L U' L'"), # 14
        root_alg('h701', "L2 D' R' B2 R' B D B2 L' D2 R2 F' D2 L'"), # 14
        root_alg('h291', "L' B' U2 L2 D2 L' U' R2 U L F' R2 D2 L'"), # 14
        root_alg('h237', "B' R B L' B R' B' L2 D2 R' F R D2 L'"), # 14
        root_alg('h572c', "F R2 B' D B' D' B2 R F' L F2 R F2 L'"), # 14
        root_alg('h898b', "B' U' B L U L D R' F' R D' L' U2 L'"), # 14
        root_alg('h706b', "R' L U' R U' B2 L B' L' B L' B2 U2 L'"), # 14
        root_alg('h730b', "B L' B' R' L U' R U' B2 L' B2 L2 U2 L'"), # 14
        root_alg('h733b', "B L U L' U' L' B2 R B' R' B2 L2 U2 L'"), # 14
        root_alg('h390', "B' R B' R2 U R U B U' L' B L2 U2 L'"), # 14
        root_alg('h691c', "F2 D R D' F2 U L' D' B2 U D L2 U2 L'"), # 14
        root_alg('h413', "L F R' F R F2 U2 L2 B L B' L U2 L'"), # 14
        root_alg('h516b', "R U B U' B U' B2 U B2 U R' L U2 L'"), # 14
        root_alg('h785', "B' R' B L' B' R2 B L B2 R' B2 L U2 L'"), # 14
        root_alg('h1180', "B' R' U2 F R' F2 U' F U R2 B L U2 L'"), # 14
        root_alg('h1025', "B' R' U R2 B L B' R' B L' U L U2 L'"), # 14
        root_alg('h582b', "B' U D2 F2 R B' R2 F2 B2 U' B' D2 B L'"), # 14
        root_alg('h1115', "R L D' B D R' D' B R B R' B2 D L'"), # 14
        root_alg('h1171b', "F' L2 B2 D2 F' R F B' D2 L B' L2 F L'"), # 14
        root_alg('h1171c', "B L2 F2 D2 B R F B' D2 L B' L2 F L'"), # 14
        root_alg('h62', "L' B L2 F R F2 R' L2 B2 R B L2 F L'"), # 14
        root_alg('h1208b', "R' U2 R U B L F U F2 L' B' L F L'"), # 14
        root_alg('h673', "R U B U' B' R' F U F' U' F' L F L'"), # 14
        root_alg('h677', "R U' B U' B' R' U' L F' R' F2 R F L'"), # 14
        root_alg('h1041', "B L B' R B L2 B' R2 L U L U' R L'"), # 14
        root_alg('h673d', "R B U' L U L2 B' R2 L U L U' R L'"), # 14
        root_alg('h287', "R B U D F' L F D' B' L U2 R' U L'"), # 14
        root_alg('h1098b', "F' B L' B' U L F R U2 L U R' U L'"), # 14
        root_alg('h691e', "B2 D' R' D B2 U' L B2 D2 F2 D2 B2 U L'"), # 14
        root_alg('h691d', "B2 D' R' D B2 U' L F2 U2 F2 U2 F2 U L'"), # 14
        root_alg('h51c', "F B' U R2 U' R' U R2 U' F' B L U L'"), # 14
        root_alg('h925', "R B2 L' B' U2 L2 U L2 U L2 U L' B' R'"), # 14
        root_alg('h1184', "R U B U' B2 D' B U B' D B2 U' B' R'"), # 14
        root_alg('h589', "B U' R B' U R B R2 B2 R B2 U' B' R'"), # 14
        root_alg('h601', "B' R' U' R2 B' R' B2 R B' U B2 U' B' R'"), # 14
        root_alg('h675', "L F2 U' F2 U F2 U L' U' R B U' B' R'"), # 14
        root_alg('h424', "B2 U' R2 B R' B' R' U B2 R B U' B' R'"), # 14
        root_alg('h392', "R B R' L U L' U' R B' U B U' B' R'"), # 14
        root_alg('h98', "R B2 R2 U2 B' U' B U' R2 L' B' L B' R'"), # 14
        root_alg('h1142b', "R B' R' U' R U B2 U' B L' B' L B' R'"), # 14
        root_alg('h1087b', "R2 B' L B D2 B D2 B' L2 D2 R' L B' R'"), # 14
        root_alg('h502', "B2 R2 B' L2 B R2 B' L B' R B L B' R'"), # 14
        root_alg('h1191', "B2 L U' L' U L U L2 B2 R B L B' R'"), # 14
        root_alg('h254', "R B R' L U L' U B' U' B U' R B' R'"), # 14
        root_alg('h903', "R U B U L' B L B' L U L' U B' R'"), # 14
        root_alg('h652', "B L' B' R B L2 U' L' B' U' B U B' R'"), # 14
        root_alg('h691', "R D B L' D2 R F' R' D2 L2 B' L' D' R'"), # 14
        root_alg('h1092', "R B U B' R2 D L' D' R2 D L U' D' R'"), # 14
        root_alg('h55b', "R U' D B2 U' B U' B U2 B U' B D' R'"), # 14
        root_alg('h24', "R B U R L B U B' U' R' L' B' U' R'"), # 14
        root_alg('h553', "L' U R U' R' L U2 R U B U' B' U' R'"), # 14
        root_alg('h42', "R' B U L U' B' R2 B U' L' U2 B' U' R'"), # 14
        root_alg('h874', "R B U' L U' L' U L U L' U2 B' U' R'"), # 14
        root_alg('h96', "R B U' B2 U2 B U B' U B2 U2 B' U' R'"), # 14
        root_alg('h567', "R U' B' R B2 U B' U' R' B U2 B' U' R'"), # 14
        root_alg('h567b', "R B U' L U L' U' B' U B U2 B' U' R'"), # 14
        root_alg('h877b', "R B L2 D' R D L2 D' R' U D B' U' R'"), # 14
        root_alg('h196', "B2 U B' L B U' B2 R B L' U B' U' R'"), # 14
        root_alg('h1092b', "R2 U2 R' B R L U' L' U2 R' U B' U' R'"), # 14
        root_alg('h46', "R2 U R' B' R U' R2 U R B2 U B' U' R'"), # 14
        root_alg('h673c', "R B U' B' U B U2 B' U' B U B' U' R'"), # 14
        root_alg('h753b', "R2 F2 L F L' F2 R F' R2 B U B' U' R'"), # 14
        root_alg('h467', "B U R B2 U B D' R2 D R' B' R' U' R'"), # 14
        root_alg('h691b', "R U B R B2 D2 F L F' D2 B R' U' R'"), # 14
        root_alg('h499b', "B L' B L2 U L2 B2 L U2 R U B2 U' R'"), # 14
        root_alg('h572', "R U2 R2 U2 R' U B U' B' R U R2 U' R'"), # 14
        root_alg('h558b', "R' U R B' R B U' F B' R2 F' B U' R'"), # 14
        root_alg('h373', "R B U B' U' B U B' R B' R' B U' R'"), # 14
        root_alg('h694', "R2 D L' B2 L D' R' U' R B' R' B U' R'"), # 14
        root_alg('h1183', "R B L' B L B U' B2 U' B2 U2 B U' R'"), # 14
        root_alg('h55', "B L' B' R B2 L B R' U' R U B U' R'"), # 14
        root_alg('h757', "R B U B' U2 F' L2 D' B D L2 F U' R'"), # 14
        root_alg('h840', "R B' U' B' U B2 U B' U2 L' B2 L U' R'"), # 14
        root_alg('h520', "R U B U2 B2 R' B U2 B U2 B' R U' R'"), # 14
        root_alg('h753', "R B U' B' U B U B' U2 R' U' R U' R'"), # 14
        root_alg('h95', "L U L' U L U2 R L' U2 R' U' R U' R'"), # 14
        root_alg('h323', "R L' U' L U' L' U' R' U' L U' R U' R'"), # 14
        root_alg('h57b', "R U2 R2 U' R2 B' R' D' R2 D B R U' R'"), # 14
        root_alg('h895c', "B' R B' R2 L2 U2 B L' B' U2 R2 L2 B2 R'"), # 14
        root_alg('h734c', "B L' B R2 L2 F R F' U2 L' U2 R2 B2 R'"), # 14
        root_alg('h1069', "R U B U' B R2 U2 R B R' U2 R2 B2 R'"), # 14
        root_alg('h198', "R B2 U2 B R B2 R' B R B R' U2 B2 R'"), # 14
        root_alg('h475b', "B U B' R' F' U' F R2 B L' B L B2 R'"), # 14
        root_alg('h451c', "R2 L2 B' D' R' B L2 U D2 L' B2 L D2 R'"), # 14
        root_alg('h408b', "R' B2 L' B' L B2 R2 B U B U B' U2 R'"), # 14
        root_alg('h855', "L U F U' F' R B L' U2 L B' L' U2 R'"), # 14
        root_alg('h567c', "R L' B L2 D2 R' F R' F R2 D2 L' U2 R'"), # 14
        root_alg('h469', "R U B U2 B' R D L' B' L D' R' U2 R'"), # 14
        root_alg('h898', "R B U' B' U' R D L' B' L D' R' U2 R'"), # 14
        root_alg('h997', "R B U B' U' R D L' B2 L D' R' U2 R'"), # 14
        root_alg('h377b', "R U' B L' B L U B' U B U2 B2 U2 R'"), # 14
        root_alg('h22b', "R2 B2 R2 U' R L' D L2 U2 L D' L2 U2 R'"), # 14
        root_alg('h696', "F2 D' L2 B L B' L D F' R' F' R2 U2 R'"), # 14
        root_alg('h1133d', "D B D2 R U' R' U D2 B' U2 D' R U2 R'"), # 14
        root_alg('h1133b', "B2 R' U' R' D' R U D R B2 U' R U2 R'"), # 14
        root_alg('h333', "F2 L2 B L B' L F L' U L F R U2 R'"), # 14
        root_alg('h1070', "L' U2 R U' B' U B R' U2 L U R U2 R'"), # 14
        root_alg('h320', "L F' L2 U' L U' R2 B' L D2 R' L' B R'"), # 14
        root_alg('h742', "R L' B L2 U2 L B R B' L2 B2 R' B R'"), # 14
        root_alg('h634d', "L U2 R L' U R D B D' R' B' U' B R'"), # 14
        root_alg('h416b', "B2 U' B L' U' B U D L' D' R L2 B R'"), # 14
        root_alg('h1033b', "R2 B' D' R D2 B' L2 B D2 F D R2 B R'"), # 14
        root_alg('h1087', "R2 B' L' B' R2 B' R2 B' R2 B2 R L B R'"), # 14
        root_alg('h629', "L' U2 L U B L' U L B' U' B' R B R'"), # 14
        root_alg('h665', "B' R B R' U' R B' R' B U' B' R B R'"), # 14
        root_alg('h650b', "B L2 U L2 B D' B D B U' B' R B R'"), # 14
        root_alg('h866', "R B2 R' U' B' R' U' R U2 B U2 R B R'"), # 14
        root_alg('h891c', "B' U' B U' R B' L' B R' L U2 R B R'"), # 14
        root_alg('h558', "R B U' B' U' B U2 B2 U' R' U R B R'"), # 14
        root_alg('h740', "L2 U B L2 B' R L2 D' B2 U B' U' D R'"), # 14
        root_alg('h1070b', "R' D B U2 B' U2 D2 B' D R2 D' B D R'"), # 14
        root_alg('h768', "R F' R L2 B' L B R' B L' B L2 F R'"), # 14
        root_alg('h623', "B L B' R B U L' B' U2 B U B' U R'"), # 14
        root_alg('h227b', "L U' R D2 R' U R L' U' L D2 L' U R'"), # 14
        root_alg('h622b', "R2 U2 B' R D' R D R2 B2 U2 B' R' U R'"), # 14
        root_alg('h728', "R B2 U R2 B U2 B' U2 B' R2 U' B2 U R'"), # 14
        root_alg('h414', "R B U B U2 B' R B2 R' B' U2 B2 U R'"), # 14
        root_alg('h541b', "L' U R U' B U B2 U2 B2 U' B' L U R'"), # 14
        root_alg('h260b', "R' D' L F' L' D R' L' B' R' B L U R'"), # 14
        root_alg('h416', "B' R B2 U2 B' R' U' B U' B' U' R U R'"), # 14
        root_alg('h697', "R2 B2 R' B2 U' L U' L' U R' U' R U R'"), # 14
        root_alg('h469b', "L F U F2 L F L2 F B2 D' R' D F' B2"), # 14
        root_alg('h1133e', "B2 U R B2 R' L U2 D2 L' U' L D2 L' B2"), # 14
        root_alg('h227', "B2 U R2 U2 R2 B2 U R2 U R2 U2 B2 U' B2"), # 14
        root_alg('h805', "B' R' B' U' B R B' R L' B2 R' L U' B2"), # 14
        root_alg('h74', "B L' B' U B2 L2 B2 R' U R U B2 L2 B2"), # 14
        root_alg('h451', "B U' B R2 U' R B R' B' U2 B U' R2 B2"), # 14
        root_alg('h20', "B2 R2 B' U B2 R B R2 U R U2 B2 R2 B2"), # 14
        root_alg('h1102', "R' L U L' U' R L' B2 R2 B' L B R2 B2"), # 14
        root_alg('h1093', "L' U' L B L' B' U B2 R2 B' L B R2 B2"), # 14
        root_alg('h757b', "L U' D R U R' U2 D' L' B2 D' R D B2"), # 14
        root_alg('h981b', "L U' L' B2 D' B U' B' U' D R' U R B2"), # 14
        root_alg('h413c', "F2 L' B L2 F B' L2 U2 F D2 B2 R' B2 D2"), # 14
        root_alg('h413b', "B2 L' B2 D2 F U2 R2 F B' R2 B R' F2 D2"), # 14
        root_alg('h478c', "B2 L' U2 B2 U L2 U' D L2 F2 D R' F2 D2"), # 14
        root_alg('h907e', "F2 R2 L2 B' D2 B U F' R2 F U' R2 L2 F2"), # 14
        root_alg('h488b', "R L' U R' U' R' L F2 R2 B' R B R2 F2"), # 14
        root_alg('h1106', "R2 L' B R' B U2 R B2 R' B' L' B R' L2"), # 14
        root_alg('h618', "L2 B2 R2 F' D' F R2 D R' F R D' B2 L2"), # 14
        root_alg('h1191b', "L' U' B L U R L' B R' U' B L' B2 L2"), # 14
        root_alg('h7', "B L' D' B' R B' R2 U2 B' R D L' B2 L2"), # 14
        root_alg('h684c', "F U2 F2 L F L2 B' R B L' B2 R' B2 L2"), # 14
        root_alg('h634', "L' B' R' U2 R2 U B U' B L' B R' B2 L2"), # 14
        root_alg('h505', "L2 B' U R' U' R B' L2 B U' B' L2 B2 L2"), # 14
        root_alg('h259', "R' L' U2 R' B D B' D' R2 L U' L2 B2 L2"), # 14
        root_alg('h22', "R L' D' R2 U2 R' D R2 U2 L U' L2 B2 L2"), # 14
        root_alg('h907d', "L2 F2 D L' U L D' F2 B2 R' D' R B2 L2"), # 14
        root_alg('h1022b', "R2 L2 B' L B' R' U2 B2 L' B R B' R2 L2"), # 14
        root_alg('h560', "R' L2 U L U' R U B' U' B U L' U2 L2"), # 14
        root_alg('h1022c', "R B2 L2 B' L2 B' R' L2 D' L U2 L' D L2"), # 14
        root_alg('h996', "F2 R2 B' R' B R' F2 L2 D' R B2 R' D L2"), # 14
        root_alg('h670', "L' U D' R D B' L' B' D' B' R' B2 D L2"), # 14
        root_alg('h1133c', "R' L2 D' L D' R' D B2 L' D2 R D' R L2"), # 14
        root_alg('h1025d', "L' B2 R2 B R2 B R2 L D L' B2 L D' R2"), # 14
        root_alg('h502b', "R D L' U D' R D' R' U' R D2 L D' R2"), # 14
        root_alg('h572b', "R2 U2 B' R' B R U' R2 U2 R U2 R U' R2"), # 14
        root_alg('h1033c', "F2 B L' B' U2 R' F2 R' B2 D' L2 D' B2 R2"), # 14
        root_alg('h198c', "R2 U2 B' R B U2 F2 B2 L F L' F B2 R2"), # 14
        root_alg('h988', "R B2 L' B R D2 R D R' D B' L B2 R2"), # 14
        root_alg('h1142c', "R2 L2 B R' B' L B' L2 U2 L' B' R B2 R2"), # 14
        root_alg('h77', "B R B2 R' B' R2 F2 R D' L2 D R' F2 R2"), # 14
        root_alg('h1119b', "R2 F2 R' L B L' U L B' L' U' R F2 R2"), # 14
        root_alg('h1133', "R' B U2 B' R' U' B' R B R U' R' U2 R2"), # 14
        root_alg('h895', "R' U2 R' U2 B' R B R2 B' R' B R' U2 R2"), # 14
        root_alg('h876', "B' R B' R' B2 U2 R B' R L' B' L B R2"), # 14
        root_alg('h837', "R' B' U' R U B U2 R' U2 R U R2 U R2"), # 14
        root_alg('h502c', "L F2 R2 F' R2 F' L' U2 F R B' R' F' B"), # 14
        root_alg('h566', "L F U' R U R' L' B' L U F' U' L' B"), # 14
        root_alg('h1168b', "B' L F2 R2 F2 U' R' U R F2 R F2 L' B"), # 14
        root_alg('h772b', "B2 L U F U' L' B R' L F R F2 L' B"), # 14
        root_alg('h1025e', "R U D' R2 B' R' B R' D R' U' B' R' B"), # 14
        root_alg('h783', "R U B U' B' U R' B' R B U' B' R' B"), # 14
        root_alg('h412b', "R2 D R' U R D' R2 B' R B U' B' R' B"), # 14
        root_alg('h544', "B L' B L B2 R U R' U R U2 B' R' B"), # 14
        root_alg('h874b', "F' L' U R' L U' R F U R U2 B' R' B"), # 14
        root_alg('h810', "R U2 R2 U' R2 U' B' R' B U2 R B' R' B"), # 14
        root_alg('h481', "F' B' U R U2 F2 R' L F L' F2 U' R' B"), # 14
        root_alg('h1049', "L' U' B' U B' R2 D2 R' D2 B' L B2 R' B"), # 14
        root_alg('h544b', "R U B U' B L2 D2 L D2 B' L B2 R' B"), # 14
        root_alg('h278', "R2 D' R' U R' D B2 U' B U2 R' U2 R' B"), # 14
        root_alg('h662c', "L2 B2 D R' F2 R D' B2 L2 B2 R B R' B"), # 14
        root_alg('h1136', "B2 D' R D B U2 R U' R2 U2 R2 U R' B"), # 14
        root_alg('h329c', "B L2 D' B D' R2 B' D2 L2 B2 U F' U' B"), # 14
        root_alg('h479', "B' R U R2 U R' U' R U R' U2 R' U' B"), # 14
        root_alg('h43', "B R U B2 U' R' B U2 R' U2 R B U' B"), # 14
        root_alg('h331', "R B' R' U2 R B R' U' B' R' U' R U' B"), # 14
        root_alg('h154', "B' R' U' R2 D R' U2 R D' R2 U R U' B"), # 14
        root_alg('h382', "B' R2 B2 R' U R' B' R B U' R B2 R2 B"), # 14
        root_alg('h826', "B' R2 B2 U B' R' B R U2 R' U B2 R2 B"), # 14
        root_alg('h706', "R2 U B' U2 R' B R U R2 B' R U R2 B"), # 14
        root_alg('h270', "L F U' R U R' U' F' U2 L' U' B' U2 B"), # 14
        root_alg('h285', "R L' B L B U B2 U' B2 R' U' B' U2 B"), # 14
        root_alg('h589b', "B2 D' B U' B' D R B R' B U' B' U2 B"), # 14
        root_alg('h554', "R B' R' B U B U' B2 U' B U' B' U2 B"), # 14
        root_alg('h270b', "L U2 L' U' B' R' U' R U' B U' B' U2 B"), # 14
        root_alg('h893', "B' R' U R U' R' U' R U' B U' B' U2 B"), # 14
        root_alg('h554b', "B' R' U R B' R B R' U2 B U' B' U2 B"), # 14
        root_alg('h1085', "R U B U' B' R' L' B L B' U2 B' U2 B"), # 14
        root_alg('h285d', "R L' D B2 D' R' B L U B' U2 B' U2 B"), # 14
        root_alg('h1106b', "R' U2 R B2 L B U2 B' L2 B2 L B' U2 B"), # 14
        root_alg('h554c', "B' L U L' U B2 R L' B' L B' R' U2 B"), # 14
        root_alg('h278b', "L' D' R B R' D L2 U L2 B L B2 U2 B"), # 14
        root_alg('h772', "B' U' R' U R B' D' B U2 B' D B U2 B"), # 14
        root_alg('h717', "B' R2 U' R2 U' L' B R' B R B' L U2 B"), # 14
        root_alg('h1196b', "B' U2 L' B2 U' B' U B R B R' L U2 B"), # 14
        root_alg('h312e', "F U2 L F2 L' U2 F' B U B2 D' R2 D B"), # 14
        root_alg('h651', "B2 D' F2 D2 L D L2 D' B D2 F2 R D B"), # 14
        root_alg('h1119', "B2 R' B L' B' R2 B' R' U' B' U B2 L B"), # 14
        root_alg('h129b', "L B' U2 L2 U R' U' L2 U2 B L' B' R B"), # 14
        root_alg('h495', "R B2 L' D2 L B R2 B L F L' B' R B"), # 14
        root_alg('h353', "L' U' L U' L' U2 L2 U L' B' R' U' R B"), # 14
        root_alg('h126', "B' U' R' U R2 B' R' B2 U' B' R' U' R B"), # 14
        root_alg('h582', "B' U' R' U R U' R' U2 R U' R' U' R B"), # 14
        root_alg('h673b', "B U L U' L' B2 R' U R U' R' U' R B"), # 14
        root_alg('h1140b', "R L' D' B D R' L U2 B' U' R' U2 R B"), # 14
        root_alg('h1184b', "F B' U F2 L F L2 U2 R' U' L U2 R B"), # 14
        root_alg('h495c', "B2 L B2 U2 R B L B D2 B R2 F R B"), # 14
        root_alg('h224', "L' U' B L' B' L U L B' U' R' U R B"), # 14
        root_alg('h475', "B' U L U L2 B L B2 U B R' U R B"), # 14
        root_alg('h415b', "R L' D' B' D R' L U' B' U R' U R B"), # 14
        root_alg('h475c', "F B' U F2 L F L2 U L U R' U R B"), # 14
        root_alg('h1136b', "L' B' R L' D2 L D' B' D' R2 L U R B"), # 14
        root_alg('h1136c', "L' B L B2 R L' D B' D' R2 L U R B"), # 14
        root_alg('h1022', "R' U2 R U2 R2 U R' B' R U' R U R B"), # 14
        root_alg('h153', "R B' R2 D2 R U' R' D2 R2 B R' B' U B"), # 14
        root_alg('h955c', "R2 U B2 D B2 U' B D' B' R2 U2 B' U B"), # 14
        root_alg('h499', "B' U2 R' B L' B' R B2 L B' U B' U B"), # 14
        root_alg('h1081', "L2 F2 R' D F D' F2 R F' L2 U B' U B"), # 14
        root_alg('h891', "R U' B' U2 B U R' B' U' B U B' U B"), # 14
        root_alg('h688', "R B2 L' B2 R' B L B2 U2 B U B' U B"), # 14
        root_alg('h575', "B' U' R' U R2 D B U B' U' D' R' U B"), # 14
        root_alg('h248', "R U2 R2 U' R' U R2 U' R' B' U' R' U B"), # 14
        root_alg('h548', "B2 R2 B2 U B' R2 B U' B2 R' B R' U B"), # 14
        root_alg('h289', "B U2 B2 U' B2 U' B2 U B' R B R' U B"), # 14
        root_alg('h1061', "L' U' B' U B2 L B' U' B2 R B R' U B"), # 14
        root_alg('h312f', "F U2 R U2 R' U2 F' B D L2 D' B2 U B"), # 14
        root_alg('h548b', "B L2 D R' L D' L' D R D' L2 B2 U B"), # 14
        root_alg('h329', "L U2 L' B R' U R2 B R2 U' R B2 U B"), # 14
        root_alg('h377', "B' R2 U R2 B' R B R2 U R' U2 R2 U B"), # 14
        root_alg('h662', "B' U' B' R B2 R U2 R' B' R U2 R2 U B"), # 14
        root_alg('h745', "B' R' U2 F R' F' D' L F L' D R2 U B"), # 14
        root_alg('h1025b', "B' R' U' R U R2 D' R U' R' D R2 U B"), # 14
        root_alg('h988b', "L2 D R' F' R D' L2 B' U R' U' R U B"), # 14
        root_alg('h400', "B' R' U' R B' R B R' U R' U' R U B"), # 14
        root_alg('h1002', "R U2 R' U' B' R B U' B' R2 U' R U B"), # 14
        root_alg('h863', "R' U2 R2 U R' U R U2 B' R2 U' R U B"), # 14
        root_alg('h1082', "L' U' B' U B' R B2 L B' R2 U' R U B"), # 14
        root_alg('h893b', "L' U2 L B' L' B U2 B' R' L U' R U B"), # 14
        root_alg('h475d', "B' R2 F2 B2 L F L' F B2 R U' R U B"), # 14
        root_alg('h1072b', "B U B2 R D' R2 U R' D R U2 R U B"), # 14
        root_alg('h1072c', "R B2 D B D2 R2 U R' D R U2 R U B"), # 14
        root_alg('h1168', "L U L' U' F' B2 R F' D2 F R' B2 L' F"), # 14
        root_alg('h634e', "F2 B2 R D2 R' B2 D F2 U F2 D' F L' F"), # 14
        root_alg('h634f', "F2 B2 R D2 R' B2 U L2 U L2 U' F L' F"), # 14
        root_alg('h601b', "F' R B L2 U D' R B2 R' D B' U' R' F"), # 14
        root_alg('h285c', "R L' D B2 D' R' B L U F' L2 B' L2 F"), # 14
        root_alg('h986b', "F' B L2 D' B D2 F' D R' F D2 B2 L2 F"), # 14
        root_alg('h1211', "L' B' L F' L D2 F2 R' F2 D2 L B L2 F"), # 14
        root_alg('h554d', "R L' U' L U R' U F' D' B L' B' D F"), # 14
        root_alg('h1074', "R2 F D' F D L D2 F2 R2 F' L2 B L F"), # 14
        root_alg('h451b', "R2 B2 D2 F L' B D2 F' R2 B R' F' R F"), # 14
        root_alg('h1152', "L' B' R B' R' B L F' L' B U' L U F"), # 14
        root_alg('h1098', "B' U2 B U B' R B' R' B2 U B L' B' L"), # 14
        root_alg('h1068', "R L2 B L B' R' L' B L2 U L' U' B' L"), # 14
        root_alg('h1171', "L2 B L B' R B2 R' U2 B U2 B' U2 B' L"), # 14
        root_alg('h734', "F' L F L2 B2 R B2 L' B' R' B2 L B' L"), # 14
        root_alg('h408', "R2 L' U2 R' B' R U2 R2 B U' B U B' L"), # 14
        root_alg('h1196', "R B2 R' U' B' U B U R B2 L' B' R' L"), # 14
        root_alg('h866c', "B U2 B2 U' R B R2 U R2 B L' B' R' L"), # 14
        root_alg('h1108', "B' R' U' R2 B' R' B2 U R B L' B' R' L"), # 14
        root_alg('h863b', "L' B U B' R D B' L U' L' U D' R' L"), # 14
        root_alg('h285b', "R L2 B2 L B U B2 R B2 R' B' U' R' L"), # 14
        root_alg('h220c', "L' U' B U2 B2 U2 B' R U B' U' B2 R' L"), # 14
        root_alg('h126b', "R' U L' F' R2 D' F' D F D2 B' D2 R' L"), # 14
        root_alg('h572f', "R2 L' D' B' D2 B' D2 B2 D B' R' B R' L"), # 14
        root_alg('h866b', "L' U2 R B U B' U' B' R' U2 R B R' L"), # 14
        root_alg('h572e', "L' B' U' B2 U B U' B2 U B R B R' L"), # 14
        root_alg('h1120', "R U2 L' U B U B' U L U L' U R' L"), # 14
        root_alg('h184', "R L' B' U' B2 U2 B U2 B' U2 B2 U R' L"), # 14
        root_alg('h937', "R U L' U B U' B U2 B2 U2 B2 U R' L"), # 14
        root_alg('h608b', "R B2 L' B' L B' L' U B U' B' R' U' L"), # 14
        root_alg('h412', "R2 U R' B R U' R' B' U' L' U R' U' L"), # 14
        root_alg('h1080', "R B U B' U' B U B' U2 L' U R' U' L"), # 14
        root_alg('h807', "R L' U B2 U2 B2 U2 B U B U R' U' L"), # 14
        root_alg('h312d', "R U2 L' U L' B' L2 U2 L2 B R' L U' L"), # 14
        root_alg('h662b', "L D R' F R D' L2 B' U' R B' R' B2 L"), # 14
        root_alg('h1085b', "F U R U' R' F' B' R B L' B2 R' B2 L"), # 14
        root_alg('h734b', "B L' B R2 L2 F R F' U2 R U2 L2 B2 L"), # 14
        root_alg('h382b', "L' B2 L2 U' R L' B R' B' L U L2 B2 L"), # 14
        root_alg('h1020c', "B' U2 B U2 B L' B R D' R D R2 B2 L"), # 14
        root_alg('h907c', "B2 R L' D B2 D2 L' D' L B2 R D R2 L"), # 14
        root_alg('h907b', "B2 R L' D B' R D' R' D2 B R D R2 L"), # 14
        root_alg('h378c', "R L' D B D' R2 U' R U B U2 B' U2 L"), # 14
        root_alg('h410', "F2 R2 F2 R B' R' B L' U2 F R F' U2 L"), # 14
        root_alg('h852b', "R B2 L B' L2 B' R' U2 B L2 B' L' U2 L"), # 14
        root_alg('h83', "R U2 L' B U' B' U2 L U2 R' U' L' U2 L"), # 14
        root_alg('h478b', "L' U R' U' R U' B2 L' B2 L2 U' L' U2 L"), # 14
        root_alg('h314c', "L' U2 D2 R2 B' R2 D2 L2 F2 L' F L' U2 L"), # 14
        root_alg('h684b', "B U2 B' R' L' U2 R B' U' R B R' U2 L"), # 14
        root_alg('h72', "L' U' B' U B U2 R L U' L' U R' U2 L"), # 14
        root_alg('h91c', "L U2 B R2 L2 U L' U' R2 B' U2 L2 U2 L"), # 14
        root_alg('h616', "R' U' R U' B D' R' U2 R D B' L' B L"), # 14
        root_alg('h650', "B' R' U' R L U' L' U' B' U2 B L' B L"), # 14
        root_alg('h200', "L' B' L U' R' U R U' R' U R L' B L"), # 14
        root_alg('h111', "L' B' R2 L U2 R2 U R2 U R2 U L' B L"), # 14
        root_alg('h419b', "L' B2 R2 D2 R' D2 B' L B' L' B' R' B L"), # 14
        root_alg('h419c', "R B2 L2 D2 L D2 B' L B' L' B' R' B L"), # 14
        root_alg('h353b', "R' U' R U' B U' B' U' R L' B' R' B L"), # 14
        root_alg('h207b', "B' U2 B U B' U B L' B2 R B R' B L"), # 14
        root_alg('h224b', "B' U' B2 L' B' L2 U' L2 B2 R B R' B L"), # 14
        root_alg('h224c', "R L' B' R' B U B U' B' U2 B' U B L"), # 14
        root_alg('h783b', "R L' U D' B U' B' D R' U2 B' U B L"), # 14
        root_alg('h810b', "L' B L U R L2 B2 R' L U B2 U B L"), # 14
        root_alg('h907', "L' B U2 B U R' U R B U' B U B L"), # 14
        root_alg('h871b', "L' B' U' B U2 B U2 R B' R' U2 B' U L"), # 14
        root_alg('h111b', "L' U' R L2 B2 L2 B L2 B L2 B R' U L"), # 14
        root_alg('h711', "L2 U L U2 L2 U R L' U' L2 U R' U L"), # 14
        root_alg('h1025c', "B' R' U' R B2 L' D' B2 U' B' D B2 U L"), # 14
        root_alg('h516', "B U B' U' B' R B R' L' B' U' B U L"), # 14
        root_alg('h1140', "B' R B R' U' R' U R L' B' U' B U L"), # 14
        root_alg('h488c', "L' U2 L' D' R B2 R' D L B' U' B U L"), # 14
        root_alg('h829', "B' R' B L' B' R U' B U B' U' B U L"), # 14
        root_alg('h1073', "L' B2 R B U2 R2 U' R2 U' R' U2 B U L"), # 14
        root_alg('h900', "B L U L' U' L B' R' B U L' U' B' R"), # 14
        root_alg('h154b', "B D F' L F D' B' L U2 R' U L' U' R"), # 14
        root_alg('h669', "B U2 B2 R' L2 U' R U L2 B U2 R' U' R"), # 14
        root_alg('h1196c', "L U' R' U R2 L' D L' B L D' R2 U' R"), # 14
        root_alg('h478', "R' U R2 B2 U R2 U R2 U' B2 U' R2 U' R"), # 14
        root_alg('h455', "B' R B R U' R U R U B' R' B U' R"), # 14
        root_alg('h737', "R2 F R F2 L' B' U L F L' B L U' R"), # 14
        root_alg('h493', "R L2 B L B' R' L U' R' L' U L U' R"), # 14
        root_alg('h198b', "R' B2 U2 R2 B' R B R B' R B U2 B2 R"), # 14
        root_alg('h416c', "R' F2 L D' L B' D' B2 D B D L2 F2 R"), # 14
        root_alg('h1020b', "B' R2 F R2 B R' F L D' L D L2 F2 R"), # 14
        root_alg('h871', "R B U2 R' U' R U' R2 U2 R B' R' U2 R"), # 14
        root_alg('h144', "B2 L2 U B' L' B U' L2 B' U B' R' U2 R"), # 14
        root_alg('h312', "R U B' R B R' U' R2 U' R U' R' U2 R"), # 14
        root_alg('h314b', "R2 L2 D2 R F' R2 D2 L2 B2 R' B R' U2 R"), # 14
        root_alg('h608', "B U2 B2 U' R' U R2 B2 U B' U' R2 U2 R"), # 14
        root_alg('h8', "R2 D' R U' R' D R' B U B' U' R2 U2 R"), # 14
        root_alg('h14', "L U' R' U L' U2 R2 B U B' U' R2 U2 R"), # 14
        root_alg('h415', "R U2 L' U R' U' R' L U' R2 U' R2 U2 R"), # 14
        root_alg('h733', "B L U L' U' L' B2 R B' L B2 R2 U2 R"), # 14
        root_alg('h730', "B L' B' R' L U' R U' B2 R B2 R2 U2 R"), # 14
        root_alg('h1061b', "B' U' R' U R2 B R' U2 B' R B R2 U2 R"), # 14
        root_alg('h731', "L' B2 U B2 U' B2 U' L B' R B R2 U2 R"), # 14
        root_alg('h1026', "R' U' R U' B L U' L' B2 R B R2 U2 R"), # 14
        root_alg('h120', "R B2 D L2 D F L2 D' B D' R2 B U2 R"), # 14
        root_alg('h663', "R D B' R' U B' U' R B R D' R U2 R"), # 14
        root_alg('h663b', "R B U B' U2 R' U2 R' D' L F2 L' D R"), # 14
        root_alg('h144b', "R L2 B' L2 B L2 B R2 F2 L' F L' F R"), # 14
        root_alg('h898d', "D' L' F' B L F L2 B' U L2 D R' F R"), # 14
        root_alg('h1211b', "F' U2 F U2 F2 R' F D2 B' L B D2 F R"), # 14
        root_alg('h220b', "F' L' U' L U F B L U' L' B' R' U R"), # 14
        root_alg('h1017', "R U2 R2 U' R2 U' R' U B U' B' R' U R"), # 14
        root_alg('h202', "B U L U2 L' B U L U' L' B2 R' U R"), # 14
        root_alg('h129', "B' R B R U L U' R2 U L' U2 R' U R"), # 14
        root_alg('h955', "R' U R2 B2 R' U2 R' U2 R B2 U2 R' U R"), # 14
        root_alg('h51b', "L B2 R2 B' L2 B R2 L2 B2 L' U R' U R"), # 14
        root_alg('h634b', "L' U2 B U2 B U2 B' U2 B2 L U R' U R"), # 14
        root_alg('h891b', "B U L U2 L' U' B' R' U' R U R' U R"), # 14
        root_alg('h44', "B L2 F' L' F L' B' R' U2 R U R' U R"), # 14
        root_alg('h488', "R' U R U2 R U B' R' B R U' R2 U R"), # 14
        root_alg('h733c', "B L U L' U2 L' B' R B2 L B2 R2 U R"), # 14
        root_alg('h1144', "L' U2 L U B L' U L B2 R B R2 U R"), # 14
        root_alg('h877', "R U R2 U B' R' B R U R U R2 U R"), # 14
        root_alg('h204', "B L U L' U B' U' R' U2 F' U2 F U R"), # 14
        root_alg('h312b', "R B2 L' B' L B' R2 U' F R' F' R U R"), # 14

        root_alg('h411b', "B U B R2 U2 R B2 R' U2 R2 B' L U' L' B'"), # 15
        root_alg('h483b', "R B' R2 B U2 B U2 B' R B U L U' L' B'"), # 15
        root_alg('h761i', "B L2 F2 R' D' F R' D' R D R L' F L' B'"), # 15
        root_alg('h748', "B' R2 B R2 B U' R2 B2 R' U B U' B2 R' B'"), # 15
        root_alg('h374', "R B R' U2 B2 R' U2 R2 B R' U2 R B2 R' B'"), # 15
        root_alg('h271', "B L U L' B R2 U2 R B' R' U2 R2 B' U' B'"), # 15
        root_alg('h761h', "R B' R' B2 L' U2 F' L' F U2 L2 U L' U' B'"), # 15
        root_alg('h234', "R' U L' U R2 U' L U2 B U' B2 R' B2 U' B'"), # 15
        root_alg('h761j', "R' F' L' U' B U2 B' U2 L F B' R B2 U' B'"), # 15
        root_alg('h330d', "L' U R' U' R2 B R' B' R B' R' L B U' B'"), # 15
        root_alg('h780b', "L' U R' U' R2 B R' L U2 L' B L B U' B'"), # 15
        root_alg('h27b', "B' U2 B U2 B2 L' D' B' R B2 R' D L U' B'"), # 15
        root_alg('h330b', "B R2 B R' B U' B U2 B' U B' R B' R2 B'"), # 15
        root_alg('h158c', "B2 U' B2 U B R2 U2 B' R B' R2 B2 U2 R2 B'"), # 15
        root_alg('h761', "R U B U2 B2 R' B U B U2 R U' R' U2 B'"), # 15
        root_alg('h411g', "B U L U' L' U2 B2 R2 D' R' D R' B2 U2 B'"), # 15
        root_alg('h27', "R' B U' R' B2 U2 R U2 B R' U B R2 U2 B'"), # 15
        root_alg('h355', "R' U2 R U B L U2 L2 B L B2 U B U2 B'"), # 15
        root_alg('h786', "R2 F2 L F L' F2 R F2 U F R U B U2 B'"), # 15
        root_alg('h256b', "R B' R' B2 R' B R2 U2 B2 U2 R2 B' R U2 B'"), # 15
        root_alg('h27c', "B2 D' R2 F D' F2 L2 U2 F' D F2 R2 U' D B'"), # 15
        root_alg('h330e', "F' L' B' U B2 L' B' L2 F2 D B' R B D' F'"), # 15
        root_alg('h483', "L F' L2 B L2 F L2 B' L F U R U' R' F'"), # 15
        root_alg('h330k', "F R2 L2 B R D' R2 B2 R2 D R' B' R2 L2 F'"), # 15
        root_alg('h613', "F2 L F L' F R U' B U' B' U' R2 F R F'"), # 15
        root_alg('h338b', "F' B D L D2 F' D2 B R' D' F' R' B2 U F'"), # 15
        root_alg('h10', "F' B D' L' D B' L2 F' R' F L2 F2 R U F'"), # 15
        root_alg('h786b', "F B' U' B U F' U2 L F U' R U2 R' F' L'"), # 15
        root_alg('h761b', "B L U L' B2 U' B L U F R' U R F' L'"), # 15
        root_alg('h228c', "L' B' R B' L B2 R' B2 L' B2 L U' L U' L'"), # 15
        root_alg('h228e', "L' B' R B' R D2 R' D2 R' B2 L U' L U' L'"), # 15
        root_alg('h761d', "L B' U2 B U2 B' U F U' F' R B' R' B2 L'"), # 15
        root_alg('h281c', "L B2 L2 B U' B2 R B2 R' B2 U B' L2 B2 L'"), # 15
        root_alg('h761e', "F U R F' L2 D' B' D L' F R2 F R F2 L'"), # 15
        root_alg('h732', "R2 L2 D2 R F L2 U' R B L U' R2 F R2 L'"), # 15
        root_alg('h561b', "L' B U2 D2 L D2 R' B2 R L2 U2 B' L2 U2 L'"), # 15
        root_alg('h236b', "B2 R B' U R' B2 R U' B' L B' R' B U2 L'"), # 15
        root_alg('h761f', "L U R' U2 R U2 R' F U' F' R2 B' R' B L'"), # 15
        root_alg('h231', "L F' U2 R B2 U' R' F2 R U B2 R' U2 F L'"), # 15
        root_alg('h761c', "R B2 L2 D L2 U L' U' D' B' U L U' B' R'"), # 15
        root_alg('h231b', "R B D2 R' B2 U L' B2 L U' B2 R D2 B' R'"), # 15
        root_alg('h374b', "R L' B' R' L2 U2 L' B L' B' R B' L B' R'"), # 15
        root_alg('h755b', "B2 L' U2 F' L' F U2 B' L2 U L' U' R B' R'"), # 15
        root_alg('h256c', "R2 D L2 D' R' D2 L' U' L D' L' U L' D' R'"), # 15
        root_alg('h767', "R2 B' L' B' R' B L B2 R B' R' U B' U' R'"), # 15
        root_alg('h166', "R2 B R' U2 B U2 B' R' U R2 B2 R' B U' R'"), # 15
        root_alg('h265', "R B2 R2 U' R U' B' R' U2 R2 B U B U' R'"), # 15
        root_alg('h281', "R B2 L U' L2 B' L U2 L' B L2 U L' B2 R'"), # 15
        root_alg('h281b', "R B2 R2 B U' B2 L U2 L' B2 U B' R2 B2 R'"), # 15
        root_alg('h15', "L' B2 L2 U2 L2 B R B' L B R2 U2 R2 B2 R'"), # 15
        root_alg('h158b', "R2 U R2 U' R B2 U2 R2 B2 R' B' R' U2 B2 R'"), # 15
        root_alg('h366b', "R B2 R2 D' R D R2 U B2 U B R' U2 B2 R'"), # 15
        root_alg('h338', "R B2 L U L2 U R U' L U B R' U2 B2 R'"), # 15
        root_alg('h366', "R B2 R2 U2 R B' U' B2 U' R2 D' R' D B2 R'"), # 15
        root_alg('h330g', "R B L' U2 F' L' F L2 U L2 U L B' U2 R'"), # 15
        root_alg('h236c', "B2 D' R D B2 L U' R L' U2 B U B' U2 R'"), # 15
        root_alg('h256', "R2 B' R' U' R U R B R U R2 U2 R' U2 R'"), # 15
        root_alg('h802', "R L' B' L U R' U R B' U2 B' U2 B U2 R'"), # 15
        root_alg('h366c', "R L' B L U' B2 D' F R2 F' U2 D B U2 R'"), # 15
        root_alg('h265b', "R L' B' R' U2 R2 L' B' R' B2 L B L U2 R'"), # 15
        root_alg('h748b', "R2 B2 R' U B U' D R D' B D R' D' B R'"), # 15
        root_alg('h755', "R B' L' B L2 U L' U B U L U L' B R'"), # 15
        root_alg('h236', "R2 D B2 U B' U' B' R' U R D' B' R' B R'"), # 15
        root_alg('h166b', "R B U' L U' L' B' U' R' U R2 B' R' B R'"), # 15
        root_alg('h1176b', "R2 B2 R' L' B' L U' B' R B' R2 U' R B R'"), # 15
        root_alg('h1176', "R L U2 L2 B L U' B' R B' R2 U' R B R'"), # 15
        root_alg('h330h', "B2 L2 F' L D' B D B2 L' F L2 B2 R B R'"), # 15
        root_alg('h330i', "B2 L2 F' L2 B2 U B U' L2 F L2 B2 R B R'"), # 15
        root_alg('h330j', "F2 R2 F' R2 F2 U B U' L2 F L2 B2 R B R'"), # 15
        root_alg('h853d', "L2 B2 R' F D F' R B2 L' U' R U L' U R'"), # 15
        root_alg('h330f', "R2 L' D2 F D' B' D F' D2 B' R' B L U R'"), # 15
        root_alg('h761g', "L2 D L' U L2 D' L B2 U F D' R' D F' B2"), # 15
        root_alg('h853b', "B' R L' B' D B2 D' R' B2 R B' L B' R' B2"), # 15
        root_alg('h1176c', "L' B L B2 R2 B2 U L' B' L B U' B R2 B2"), # 15
        root_alg('h802b', "F2 R2 D' B2 R F B' L F' B R' B2 D R2 F2"), # 15
        root_alg('h802c', "F2 R2 U' L2 B R L' F R' L B' L2 U R2 F2"), # 15
        root_alg('h755c', "R2 L2 D' F' D2 F2 D R' D' L2 B' L2 D' R' L2"), # 15
        root_alg('h166c', "R B' U B U' R' L U F' L F2 U F' U' L2"), # 15
        root_alg('h234b', "L2 B2 R' F D F' D' L' F2 R' L D' R2 B2 L2"), # 15
        root_alg('h1110', "R L' B R2 B2 D' R D B2 U2 R B L' B L2"), # 15
        root_alg('h613b', "B2 L' B' L B' R' U F' U F U2 F R' F' R2"), # 15
        root_alg('h687', "R2 F' B2 L F' L B D B' L' D' L' F2 B2 R2"), # 15
        root_alg('h158d', "R B U2 L' B2 R B' R' L U B2 U' R B2 R2"), # 15
        root_alg('h158', "R B2 U2 R B R' U2 B2 R U R2 U R2 U2 R2"), # 15
        root_alg('h411', "B U2 B2 U' R B R2 U2 R' B' R U' R' B R2"), # 15
        root_alg('h853c', "B R L' B R2 L U2 R B2 U' B L U L' B"), # 15
        root_alg('h853', "B' U B' R B' R2 B' U' B R2 B R' B U' B"), # 15
        root_alg('h226', "B' R' U' R B U B U2 R B' R' U2 B2 U2 B"), # 15
        root_alg('h330', "B' R' B U2 R U' R' U2 R U R' U2 B' R B"), # 15
        root_alg('h228', "R2 U' B' R' B2 U B2 R B U R2 U B' R B"), # 15
        root_alg('h158e', "R' L U L' U' R U2 B' R2 F R F' U2 R B"), # 15
        root_alg('h330c', "B' U' B U2 R B' R' U2 R B R' U2 B' U B"), # 15
        root_alg('h313', "B' R' U' R B2 U B2 U B2 U2 B' U B' U B"), # 15
        root_alg('h228d', "R B' L' B2 R' L B U L' B L U' B2 U B"), # 15
        root_alg('h28', "R U B U' B D B D2 R D R U' R U B"), # 15
        root_alg('h271b', "R B L U' L' U L U' L' B' R' U' F' U2 F"), # 15
        root_alg('h749b', "R U' L' U R' U' R L B U' B' R' F' U F"), # 15
        root_alg('h749c', "R U D' B U' B2 D R' B D L2 D' L B' L"), # 15
        root_alg('h28c', "L2 U B R2 L2 B' L2 B D L2 D' R2 L B' L"), # 15
        root_alg('h174', "L' B2 L2 U2 B U B' U L2 B R B' R' B2 L"), # 15
        root_alg('h561', "L' U B' U2 B U' B' U R' U2 R U' B U2 L"), # 15
        root_alg('h411c', "L' B' U' B U B' R B2 R' B2 L U2 L' B L"), # 15
        root_alg('h411d', "L' B' U' B U B' L U2 R' U2 R U2 L' B L"), # 15
        root_alg('h411e', "L' B' U' B U B' L U2 L' B2 R B2 R' B L"), # 15
        root_alg('h780', "L' B' U R' U' R B2 U B2 U B2 U2 B' U L"), # 15
        root_alg('h483c', "F' L' U' L U F R B' R2 B U2 B U2 B' R"), # 15
        root_alg('h28b', "L' B L U R2 L F L D2 R L' F L' U' R"), # 15
        root_alg('h749', "L' B' U B L F U' F' L U' R' U L' U' R"), # 15
        root_alg('h228b', "R' U R B U2 B' U B U2 B2 R B R2 U' R"), # 15
        root_alg('h411f', "B L2 F B2 U F' U' B2 L B L B2 R' U2 R"), # 15
        root_alg('h174b', "L' B' R B R' L U B U B2 R B R2 U2 R"), # 15
        root_alg('h374c', "F' B D' L2 D F2 U' F' U2 B' R' F' U' F R"), # 15

        root_alg('h693', "F' L2 B L B' U2 B L' B' L2 U F U' R U2 R'"), # 16
    ]
  end
end