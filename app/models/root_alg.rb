class RootAlg
  
  attr_reader :name, :moves
  
  def initialize(name, moves)
    @name = name
    @moves = moves
  end
  
  def alg_variants
    reverse_alg = BaseAlg.reverse(@moves)
    variants = {
         a: Cube.new(@moves).standard_ll_code,
        Ma: Cube.new(BaseAlg.mirror(@moves)).standard_ll_code,
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

  def self.all
    [
        RootAlg.new('h435', "B' U' R' U R B"), # 6

        RootAlg.new('Niklas', "L' U R U' L U R'"), # 7 #h556
        RootAlg.new('h181', "L' B' R B' R' B2 L"), # 7
        RootAlg.new('Sune', "R' U' R U' R' U2 R"), # 7 #h213

        RootAlg.new('h918', "R B2 L' B2 R' B L B'"), # 8
        RootAlg.new('h304', "B' R' U R B L U' L'"), # 8
        RootAlg.new('h518b', "B L B' R B L' B' R'"), # 8
        RootAlg.new('Clix', "L' B' R B L B' R' B"), # 8 #h518
        RootAlg.new('h1161', "R' U' R U R B' R' B"), # 8
        RootAlg.new('h347', "B' U' B' R B R' U B"), # 8
        RootAlg.new('h17', "B U B2 R B R2 U R"), # 8

        RootAlg.new('h304c', "B U B' R' U2 R B U' B'"), # 9
        RootAlg.new('h117', "B' R' B2 D2 F2 L' F2 D2 B'"), # 9
        RootAlg.new('h117b', "B' L' D2 F2 U2 R' F2 D2 B'"), # 9
        RootAlg.new('h468', "B U2 B' R B' R' B2 U2 B'"), # 9
        RootAlg.new('h187', "B' R B2 L' B2 R' B2 L B'"), # 9
        RootAlg.new('Czeslaw', "B' R2 B' L2 B R2 B' L2 B2"), # 9 #h568
        RootAlg.new('Arneb', "F2 R2 L2 B2 D' F2 R2 L2 B2"), # 9 #h31b
        RootAlg.new('Arne', "B2 R2 L2 F2 D' F2 R2 L2 B2"), # 9 #h31
        RootAlg.new('h787', "R U2 R D L' B2 L D' R2"), # 9
        RootAlg.new('h534', "R U2 R D R' U2 R D' R2"), # 9
        RootAlg.new('Allan', "R2 U F B' R2 F' B U R2"), # 9 #h113
        RootAlg.new('h806', "B' U' R U B U' B' R' B"), # 9
        RootAlg.new('h484', "B2 L2 B R B' L2 B R' B"), # 9
        RootAlg.new('h347b', "B' R' U' R B U' B' U2 B"), # 9
        RootAlg.new('h304b', "B' R' U R U2 R' U' R B"), # 9
        RootAlg.new('h886', "L2 B2 R B R' B2 L B' L"), # 9
        RootAlg.new('h806b', "R L' U B U' B' R' U' L"), # 9
        RootAlg.new('h442', "L' B2 R D' R D R2 B2 L"), # 9
        RootAlg.new('h347c', "L' B2 R B R' U' B U L"), # 9
        RootAlg.new('Bruno', "R U2 R2 U' R2 U' R2 U2 R"), # 9 #h183

        RootAlg.new('h1004', "R U B U' L B' R' B L' B'"), # 10
        RootAlg.new('h846', "R' B U L U' B' R B L' B'"), # 10
        RootAlg.new('h32', "R' U2 R U B L U2 L' U' B'"), # 10
        RootAlg.new('h519', "B U2 B2 U' R' U R B2 U' B'"), # 10
        RootAlg.new('h933', "R D L' B L D' R' B U' B'"), # 10
        RootAlg.new('h1134', "R L' B' R' B L U2 B U2 B'"), # 10
        RootAlg.new('h942b', "B R' U2 R B2 L' B2 L U2 B'"), # 10
        RootAlg.new('h942c', "B R' U2 L U2 L' U2 R U2 B'"), # 10
        RootAlg.new('h942d', "B L' B2 L B2 R' U2 R U2 B'"), # 10
        RootAlg.new('h1126', "L2 B2 R B R' B L2 F U2 F'"), # 10
        RootAlg.new('h655', "L2 D' B D' R2 B' D2 L2 U F'"), # 10
        RootAlg.new('h942', "R U2 L B L' U2 L B' R' L'"), # 10
        RootAlg.new('h442d', "B' R' U' R B2 L' B' L2 U' L'"), # 10
        RootAlg.new('h116', "R B L' B' R' L U L U' L'"), # 10
        RootAlg.new('h1112', "B L2 B2 R B' R' B2 L' U2 L'"), # 10
        RootAlg.new('h371', "B' R B' R' B' L' B' L2 U2 L'"), # 10
        RootAlg.new('Buffy', "L U2 L' U2 R' U L U' R L'"), # 10 #h1125
        RootAlg.new('h116b', "B L' B' R' L U L U' R L'"), # 10
        RootAlg.new('h832', "B U L U' B' R B L' B' R'"), # 10
        RootAlg.new('h179', "R B R' L U L' U' R B' R'"), # 10
        RootAlg.new('h48', "R U B U' L U' L' U B' R'"), # 10
        RootAlg.new('h971', "R U B U2 B' U B U B' R'"), # 10
        RootAlg.new('h275', "R B L' B L B' U B' U' R'"), # 10
        RootAlg.new('h208', "R B U B' U' B U B' U' R'"), # 10
        RootAlg.new('h904', "R B2 D B' U B D' B2 U' R'"), # 10
        RootAlg.new('h50', "R B U B' R B' R' B U' R'"), # 10
        RootAlg.new('h569', "R B' U' B2 U' B2 U2 B U' R'"), # 10
        RootAlg.new('h442c', "L' U2 R U' R' U2 R L U' R'"), # 10
        RootAlg.new('h275b', "R B U B' U R' U' R U' R'"), # 10
        RootAlg.new('h1076', "B' R B U B' R' B R U' R'"), # 10
        RootAlg.new('h1153b', "B' R' U' R2 U R' B R U' R'"), # 10
        RootAlg.new('h615', "B' R B' D2 F L' F' D2 B2 R'"), # 10
        RootAlg.new('h464', "R B2 R2 L U L' U' R2 B2 R'"), # 10
        RootAlg.new('h604', "B' R U2 R' B R B' U2 B R'"), # 10
        RootAlg.new('h610', "R2 D' F2 D R2 B2 D L2 D' B2"), # 10
        RootAlg.new('h405', "B2 R2 B' L U L' U' B R2 B2"), # 10
        RootAlg.new('h370', "R L' B L' B' D' B D R' L2"), # 10
        RootAlg.new('h610b', "B2 D' R2 U R2 B2 D L2 U' L2"), # 10
        RootAlg.new('h341', "L2 B2 R B' D' B D R' B2 L2"), # 10
        RootAlg.new('h1206', "B L' B L B2 U2 R B' R' B"), # 10
        RootAlg.new('h942f', "R' U2 R2 B2 L' B' L B2 R' B"), # 10
        RootAlg.new('h942e', "L U2 L2 B2 R B' L B2 R' B"), # 10
        RootAlg.new('h434', "R U2 R' B' U R U R' U' B"), # 10
        RootAlg.new('h1153', "B' U' R' U2 R U R' U' R B"), # 10
        RootAlg.new('h644', "L' B L B' U' B' R' U R B"), # 10
        RootAlg.new('h833', "B' R B U B' U' R2 U R B"), # 10
        RootAlg.new('h1125b', "R U2 R' U' B' R U' R' U B"), # 10
        RootAlg.new('h167', "L' U R' U' R2 D B2 D' R' L"), # 10
        RootAlg.new('h931', "L' U R B2 U B2 U' B2 R' L"), # 10
        RootAlg.new('h932', "B U B' U' L' B' R B R' L"), # 10
        RootAlg.new('h976', "R L' U' B' U B U R' U' L"), # 10
        RootAlg.new('h894', "B' R' B L' B' R2 B' R' B2 L"), # 10
        RootAlg.new('h442b', "L' U2 R L U' L' U R' U2 L"), # 10
        RootAlg.new('h1113', "R U' L' U R' U2 B' U B L"), # 10
        RootAlg.new('h775', "L' U R' U' R L U2 R' U' R"), # 10
        RootAlg.new('h769', "R' L' U2 R U R' U2 L U' R"), # 10

        RootAlg.new('h794', "R B' R' B U2 B U' L U' L' B'"), # 11
        RootAlg.new('h487', "B2 U B R B R2 U R2 B R' B'"), # 11
        RootAlg.new('h283', "R' U2 R U B U2 L U2 L' U' B'"), # 11
        RootAlg.new('h268', "R' U2 R B2 L' B' L2 U L' U' B'"), # 11
        RootAlg.new('h1045', "R B L' B' R' B L2 U L' U' B'"), # 11
        RootAlg.new('h564b', "R B2 L' B2 R' B L2 U L' U' B'"), # 11
        RootAlg.new('h221', "B' U' R' U R B2 L U L' U' B'"), # 11
        RootAlg.new('h64', "B' R' U' R U B2 L U L' U' B'"), # 11
        RootAlg.new('h570', "R' U2 R2 U B U' B2 R' B2 U' B'"), # 11
        RootAlg.new('h247', "R D L' B' L D' R' U2 B U' B'"), # 11
        RootAlg.new('h138', "R' F' U F R B2 L' B' L U' B'"), # 11
        RootAlg.new('h145', "B L2 F2 D2 R' D' R D' F2 L2 B'"), # 11
        RootAlg.new('h161', "B U2 B2 R2 D' R' D R' B2 U2 B'"), # 11
        RootAlg.new('h49', "B' U' R2 D' R' D R' U B2 U2 B'"), # 11
        RootAlg.new('h274c', "B U2 B' U' R' U2 R U B U2 B'"), # 11
        RootAlg.new('h571', "B U2 B' U' R' U R U B U2 B'"), # 11
        RootAlg.new('h607', "B D' B2 U R' U' R U' B2 D B'"), # 11
        RootAlg.new('h290', "B D' B2 U R' U2 R U' B2 D B'"), # 11
        RootAlg.new('h381', "B D' B2 U2 R' U R U B2 D B'"), # 11
        RootAlg.new('h53', "B R' D2 R B' U' B R' D2 R B'"), # 11
        RootAlg.new('h11', "B R' D2 R B' U2 B R' D2 R B'"), # 11
        RootAlg.new('h80', "B R' U2 L F' U2 F L' U2 R B'"), # 11
        RootAlg.new('h612', "B2 L' B' L B' R' U' R B U B'"), # 11
        RootAlg.new('h1178', "L' U R B L' B' R' L2 F U' F'"), # 11
        RootAlg.new('h294', "L2 D' R B' R' D L2 U F U F'"), # 11
        RootAlg.new('h1038', "L F2 R2 B' R F' R' B R2 F' L'"), # 11
        RootAlg.new('h438', "L F R2 L' B' R' B R' L F' L'"), # 11
        RootAlg.new('h441', "B' U2 B L F R U R' U F' L'"), # 11
        RootAlg.new('h720b', "R U B' U' B R' L F U F' L'"), # 11
        RootAlg.new('h929', "L U' B' R2 D' F D R2 B U' L'"), # 11
        RootAlg.new('h216', "B' R' F' U2 F R B U' L U' L'"), # 11
        RootAlg.new('h609b', "R' F2 L2 D2 R' B' L' D2 R2 F2 L'"), # 11
        RootAlg.new('h609c', "L F2 R2 D2 L B' L' D2 R2 F2 L'"), # 11
        RootAlg.new('h345', "L' B2 D' R2 D' R2 D2 B2 L2 U2 L'"), # 11
        RootAlg.new('h308b', "L U2 L' B' R' U2 R B L U2 L'"), # 11
        RootAlg.new('h1150', "L2 F2 R2 B' D2 B R2 F L' F L'"), # 11
        RootAlg.new('h1028', "L' B' R B R' L2 U' R' U R L'"), # 11
        RootAlg.new('h1212', "L U' L2 D' R B R' D L2 U L'"), # 11
        RootAlg.new('h308', "R B L U2 L' U2 L U2 L' B' R'"), # 11
        RootAlg.new('h573', "B' U2 B U R B' U B2 U' B' R'"), # 11
        RootAlg.new('h251', "R B2 L' B' L B' U B U' B' R'"), # 11
        RootAlg.new('h351', "R B L' B L B2 U B U' B' R'"), # 11
        RootAlg.new('h1164', "R U2 B' R' U' R U B2 U2 B' R'"), # 11
        RootAlg.new('h203', "R B2 L' B' L B L' B' L B' R'"), # 11
        RootAlg.new('h106', "R B R' U2 L U2 L' U2 R B' R'"), # 11
        RootAlg.new('h106b', "R B L' B2 L B2 R' U2 R B' R'"), # 11
        RootAlg.new('h720', "R B L U' L' B' U' B U B' R'"), # 11
        RootAlg.new('h533', "R B2 U L' U' B' U L B' U' R'"), # 11
        RootAlg.new('h504', "B L' B' R B2 L B' U B' U' R'"), # 11
        RootAlg.new('h1154', "B U B' U' B' R B2 U B' U' R'"), # 11
        RootAlg.new('h564', "B U2 B' U2 B' R B2 U B' U' R'"), # 11
        RootAlg.new('h253', "R U2 R' U' R U' B U B' U' R'"), # 11
        RootAlg.new('h274', "R U2 R' U' R B' R B R' U' R'"), # 11
        RootAlg.new('h175', "R U2 R2 U2 R2 U R2 U R2 U' R'"), # 11
        RootAlg.new('h1029', "R U' B' U2 L' B L U2 B U' R'"), # 11
        RootAlg.new('h1137', "R L' D' B' D L B' U B U' R'"), # 11
        RootAlg.new('h274b', "B U2 B' U2 B' U' R U B U' R'"), # 11
        RootAlg.new('h180', "R B' D' B' D2 F L2 F' D' B2 R'"), # 11
        RootAlg.new('h1032', "B' R2 D' F2 R' D2 B' L' D' B2 R'"), # 11
        RootAlg.new('h163', "R B2 R2 U2 B' U' B U' R2 B2 R'"), # 11
        RootAlg.new('h555', "R B2 R2 U2 R B' R' U2 R2 B2 R'"), # 11
        RootAlg.new('h288', "R B2 R2 U2 R B2 R' U2 R2 B2 R'"), # 11
        RootAlg.new('h770', "R' F' R' F R' D2 L B' L' D2 R'"), # 11
        RootAlg.new('h921', "R' U' R2 B U B' R2 U R2 U2 R'"), # 11
        RootAlg.new('h106c', "R U2 L' B L U2 L' B' L U2 R'"), # 11
        RootAlg.new('h624', "F' L' U2 B L' B' L2 F R U2 R'"), # 11
        RootAlg.new('h762', "B U L' B L B2 U' B' R B R'"), # 11
        RootAlg.new('h762b', "B U2 B2 R B R' U2 B' R B R'"), # 11
        RootAlg.new('h992', "L' U B U B' U' L B' R B R'"), # 11
        RootAlg.new('h225', "L' B L U2 B' U2 B' U2 R B R'"), # 11
        RootAlg.new('h788', "B U2 B2 U2 L' B' L U2 R B R'"), # 11
        RootAlg.new('h908', "B' U2 B U R B' R' U R B R'"), # 11
        RootAlg.new('h364', "R F' L2 B' D' B' D B2 L2 F R'"), # 11
        RootAlg.new('h607b', "R U' B2 D B' U' B D' B2 U R'"), # 11
        RootAlg.new('h290b', "R U' B2 D B' U2 B D' B2 U R'"), # 11
        RootAlg.new('h795', "R L' B2 U B2 U' B2 U' L U R'"), # 11
        RootAlg.new('h739', "R2 L' D B' D' B' R' B L U R'"), # 11
        RootAlg.new('h574', "R U B U B' U' R' U2 R U R'"), # 11
        RootAlg.new('h277', "B2 L D2 L' B2 U2 B2 R F2 R' B2"), # 11
        RootAlg.new('h1031', "B' R F R2 F B' L D2 L' F2 B2"), # 11
        RootAlg.new('h122', "B' R B' R2 U R U R' U' R B2"), # 11
        RootAlg.new('h948', "R U R' U F2 L' B L' B' L2 F2"), # 11
        RootAlg.new('h835', "F U2 F L2 D B' R2 B D' L2 F2"), # 11
        RootAlg.new('h219', "L2 B2 R B' L B' L' B2 R' B2 L2"), # 11
        RootAlg.new('h141', "L2 B2 L' F2 R' F' R F' L B2 L2"), # 11
        RootAlg.new('h633', "L' U' L U' L2 D' R B2 R' D L2"), # 11
        RootAlg.new('h811', "R U2 R' U' R2 D R' U' R D' R2"), # 11
        RootAlg.new('h1043', "R' U' R U' R2 D' R U2 R' D R2"), # 11
        RootAlg.new('h342b', "B2 U' B R B' U B2 U' B' R' B"), # 11
        RootAlg.new('h1060', "R' U2 R2 U R' U R U2 B' R' B"), # 11
        RootAlg.new('h522', "R U2 R2 U' R U R U2 B' R' B"), # 11
        RootAlg.new('h1016b', "L' B2 R2 D' R' D B2 L B' R' B"), # 11
        RootAlg.new('h1016', "L' B' U R' U' R2 B L B' R' B"), # 11
        RootAlg.new('h1008', "R B' U2 D L B' L' U2 D' R' B"), # 11
        RootAlg.new('h1159', "R B2 D2 F L' F' D' B D' R' B"), # 11
        RootAlg.new('h982b', "L' B2 R2 D2 R' D2 B' L B2 R' B"), # 11
        RootAlg.new('h982', "R B2 L2 D2 L D2 B' L B2 R' B"), # 11
        RootAlg.new('h723b', "R' L2 D F D' R L2 U' B' U' B"), # 11
        RootAlg.new('h968', "B' U' R' U2 L U' R U L' U' B"), # 11
        RootAlg.new('h812', "L' D' R B' R' D L U' B' U2 B"), # 11
        RootAlg.new('h346', "L' D' R B R' D L U B' U2 B"), # 11
        RootAlg.new('h1129', "B L U' L' B2 D' F R F' D B"), # 11
        RootAlg.new('h642', "B2 U' R B R' L' D' B D L B"), # 11
        RootAlg.new('h311', "B' R B' R' B2 U' B' R' U' R B"), # 11
        RootAlg.new('h139', "L U2 L' U' B' R' F' U' F R B"), # 11
        RootAlg.new('h915', "B' R U R2 U R2 U2 R2 U R B"), # 11
        RootAlg.new('h19', "B' U2 B U B2 R B R2 U R B"), # 11
        RootAlg.new('h420', "L F2 R' F' R U' F' L' B' U B"), # 11
        RootAlg.new('h383', "B' U' R' U R U2 B U B' U B"), # 11
        RootAlg.new('h311b', "B' R' U R B L' B L B2 U B"), # 11
        RootAlg.new('h309', "F2 L F' D2 B R' B' D2 F2 L' F"), # 11
        RootAlg.new('h328', "F' R B2 L B' L2 B L' B2 R' F"), # 11
        RootAlg.new('h936', "F' U2 R B2 D L2 D' B2 R' U' F"), # 11
        RootAlg.new('h211', "R' L' U2 R B2 L2 F' L B2 L2 F"), # 11
        RootAlg.new('h219b', "F' L2 F2 B2 R B R' F2 B L2 F"), # 11
        RootAlg.new('h1185', "R2 D L' B' L D' R2 U' F' U2 F"), # 11
        RootAlg.new('h726', "R U2 R' F' L' U B' U2 B L F"), # 11
        RootAlg.new('h439', "F D2 B2 R B2 D2 F2 U' L U F"), # 11
        RootAlg.new('h214', "R2 L' B2 R' B' R B' R' B' R' L"), # 11
        RootAlg.new('h306', "R B L' D' R' B' R D B' R' L"), # 11
        RootAlg.new('h168', "R L2 B' L B' L' B2 L B' R' L"), # 11
        RootAlg.new('h52', "R L2 B' L B' R' U2 R B' R' L"), # 11
        RootAlg.new('h214b', "B U2 B' U' R L' D B' D' R' L"), # 11
        RootAlg.new('h992c', "L' U R D' B U B' U' D R' L"), # 11
        RootAlg.new('h642b', "L2 D' R B R' D B L B' U' L"), # 11
        RootAlg.new('h571b', "R L' U R' B' R U' R' B U' L"), # 11
        RootAlg.new('h1011', "R' U2 R L' U B2 U B2 U' B2 L"), # 11
        RootAlg.new('h137', "R U R' U L' B' R2 B' R2 B2 L"), # 11
        RootAlg.new('h723', "R U' B' R B L' D B D' R2 L"), # 11
        RootAlg.new('h448', "L' U' L U' R U' L' U R' U2 L"), # 11
        RootAlg.new('h865b', "L2 B2 R B' R' B2 L2 U2 L' B L"), # 11
        RootAlg.new('h1158', "L U2 L' B2 R B2 L' B' R' B L"), # 11
        RootAlg.new('h1077', "L2 D' R B R' D L B' U' B L"), # 11
        RootAlg.new('h19b', "R L' B2 D B D2 R D R2 B L"), # 11
        RootAlg.new('h199', "L B' U' R' U B L2 B' R B L"), # 11
        RootAlg.new('h666', "L2 B2 R B2 L B' R2 U2 R B L"), # 11
        RootAlg.new('h865', "L2 B2 R B' L B2 R2 U2 R B L"), # 11
        RootAlg.new('h796', "R' B L2 F L' F' L F' L2 B' R"), # 11
        RootAlg.new('h172', "R' U2 B' D' R2 D B2 U' B' U' R"), # 11
        RootAlg.new('h992b', "B2 L' B' L2 U2 L' U B' R' U' R"), # 11
        RootAlg.new('h342', "B' R B R' B U2 B' U' R' U' R"), # 11
        RootAlg.new('h297', "R' U R2 D L' B2 L D' R2 U' R"), # 11
        RootAlg.new('h1035', "R2 D L B2 L D2 R D' L2 D2 R"), # 11
        RootAlg.new('h609', "L F2 R2 D2 L B' R D2 L2 F2 R"), # 11
        RootAlg.new('h595', "R' U R U B U2 B' U2 R' U2 R"), # 11
        RootAlg.new('h209', "R D B' U B' U' B D' R2 U2 R"), # 11
        RootAlg.new('h19c', "R' L U L2 B L B2 U B U2 R"), # 11
        RootAlg.new('h656', "R' U2 B L2 D F D' L2 B' U R"), # 11
        RootAlg.new('h47', "R U2 R2 U' R2 U' R' U R' U R"), # 11
        RootAlg.new('h197', "R' U2 R U R' U' R U R' U R"), # 11
        RootAlg.new('h1019', "L U' R' U L' U R U R' U R"), # 11

        RootAlg.new('h1078', "R' U2 B L B' R F B U2 F' L' B'"), # 12
        RootAlg.new('h809', "L' D2 R2 B' R2 D2 L B L F' L' B'"), # 12
        RootAlg.new('h808', "R B L B' R' B U' F U F' L' B'"), # 12
        RootAlg.new('h93', "R' F' U' F R2 B' R' B2 L U' L' B'"), # 12
        RootAlg.new('h800', "B U2 B' U' R' U R B L U' L' B'"), # 12
        RootAlg.new('h92b', "B U R' L U L' U' R L U' L' B'"), # 12
        RootAlg.new('h512', "B L U2 B' R2 D' F D R2 B L' B'"), # 12
        RootAlg.new('h269', "B L2 D' B2 U' R' U' R B2 D L' B'"), # 12
        RootAlg.new('h465', "B' U' R' U R B2 L2 F' L' F L' B'"), # 12
        RootAlg.new('h536', "B U L2 D R' F2 R D' L' U L' B'"), # 12
        RootAlg.new('h307b', "B U2 R D B D' R' B U' B' U' B'"), # 12
        RootAlg.new('h527', "R' U' R2 B2 L2 B R' B' L2 B' U' B'"), # 12
        RootAlg.new('h252c', "B' R B2 L' B2 R' B2 L2 U L' U' B'"), # 12
        RootAlg.new('h471b', "R' U' R2 B' R' B2 U' L U L' U' B'"), # 12
        RootAlg.new('h741', "B R U B R B R' B' U' R' U' B'"), # 12
        RootAlg.new('h1105b', "R' U' R B U B' R B' R' B2 U' B'"), # 12
        RootAlg.new('h949', "B U L' B2 R B' L B R' B2 U' B'"), # 12
        RootAlg.new('h2b', "B U2 B2 U' D' R' U R D B2 U' B'"), # 12
        RootAlg.new('h585', "B' U' R2 D' R' D R2 U R B2 U' B'"), # 12
        RootAlg.new('h446', "B' R' U' R U B2 U2 B' U' B U' B'"), # 12
        RootAlg.new('h155', "R' U' R2 B' R' B2 U B' U' B U' B'"), # 12
        RootAlg.new('h276', "R' F' U L' U L F R U' B U' B'"), # 12
        RootAlg.new('h242', "R' F' L' U2 L F U R U2 B U' B'"), # 12
        RootAlg.new('h597d', "R D L' B L D' R2 U' R B U' B'"), # 12
        RootAlg.new('h621b', "R D L' B L D' R2 U R B U' B'"), # 12
        RootAlg.new('h773', "L2 B L D2 R L F' L' F2 R' D2 B'"), # 12
        RootAlg.new('h957', "B2 R2 B' U L U' L B R2 B' L2 B'"), # 12
        RootAlg.new('h133', "R' U2 R B2 L' B' L2 F' L F L2 B'"), # 12
        RootAlg.new('h307', "L B U B' L' B U R B' R' U2 B'"), # 12
        RootAlg.new('h969', "B U' R U' B2 U' B2 U B2 R' U2 B'"), # 12
        RootAlg.new('h632', "R2 F2 L F L' F R' B' R' B2 U2 B'"), # 12
        RootAlg.new('h143', "B L U L' U B' R B' R' B2 U2 B'"), # 12
        RootAlg.new('h354', "B' R' U' R' D' R' D R' U B2 U2 B'"), # 12
        RootAlg.new('h793', "B' R2 D' R U' R2 D R' U B2 U2 B'"), # 12
        RootAlg.new('h252', "B' R' U' R U' B2 U B2 U B2 U2 B'"), # 12
        RootAlg.new('h523b', "B' U' B R B' R' U B U2 B U2 B'"), # 12
        RootAlg.new('h142', "R D L' B' L D' R2 U' R B U2 B'"), # 12
        RootAlg.new('h979', "B2 D' B2 U2 B' R2 U R2 U B2 D B'"), # 12
        RootAlg.new('h394b', "B D' R2 U D L U' L' D' R2 D B'"), # 12
        RootAlg.new('h1147', "B L2 F R B' U2 B R' F2 L F B'"), # 12
        RootAlg.new('h36', "R U2 R2 U' R2 U' R' B2 L' B' L B'"), # 12
        RootAlg.new('h191', "R' U' R U2 B2 U L U' L2 B' L B'"), # 12
        RootAlg.new('h940', "R B U B' U' B L' B' R' B L B'"), # 12
        RootAlg.new('h977', "B' L' B' L2 U2 L' U B' R' U' R B'"), # 12
        RootAlg.new('h358', "B R' D2 R L U L' U' R' D2 R B'"), # 12
        RootAlg.new('h470', "B R' U' B2 R U' R' U B2 U R B'"), # 12
        RootAlg.new('h295', "B L U2 L' U B' R B' R' B2 U B'"), # 12
        RootAlg.new('h599b', "R' U' R2 B R' U2 B2 L' B2 L U B'"), # 12
        RootAlg.new('h617', "B' R' B2 U B L' B R B2 L U B'"), # 12
        RootAlg.new('h387', "B U L' B2 L B2 U R' U R U B'"), # 12
        RootAlg.new('h597e', "L2 D' R B R' D L2 F R U' R' F'"), # 12
        RootAlg.new('h261b', "L' B' R' U R B L F R U' R' F'"), # 12
        RootAlg.new('h603', "L2 U F' D' B2 D' L' B' D2 F2 R' F'"), # 12
        RootAlg.new('h266', "R L B R' F R F' B' L' F R' F'"), # 12
        RootAlg.new('h1007', "L F' L' F2 R' U2 B' R' B U2 R F'"), # 12
        RootAlg.new('h261', "R B R' L F R L' B' R' L F' L'"), # 12
        RootAlg.new('h562', "B L2 F' L2 B' L F' R' F' R F' L'"), # 12
        RootAlg.new('h1094', "R U2 L D2 B L' U2 L B' D2 R' L'"), # 12
        RootAlg.new('h94', "B' U' R' U R B L F U F' U' L'"), # 12
        RootAlg.new('h84', "L F' L2 B2 R D' R' B2 L2 F U' L'"), # 12
        RootAlg.new('h506', "B L2 B2 R B' R' B2 L2 U' L U' L'"), # 12
        RootAlg.new('h636', "R' F' R B' R' F U R B L U' L'"), # 12
        RootAlg.new('h363b', "R2 L D' F' D R2 U' B U' B' U2 L'"), # 12
        RootAlg.new('h719', "L U2 R' U' R B2 D L D' B2 U2 L'"), # 12
        RootAlg.new('h244', "B' R' F' U2 F R B2 L' B' L2 U2 L'"), # 12
        RootAlg.new('h5b', "B L' B2 R B2 L B R' B2 L U2 L'"), # 12
        RootAlg.new('h5', "B R' U2 R U2 R B R' B2 L U2 L'"), # 12
        RootAlg.new('h348', "B' U' R' U F' U2 F R B L U2 L'"), # 12
        RootAlg.new('h1105', "R' L U L U' R U L2 U L U2 L'"), # 12
        RootAlg.new('h105', "L B' R' U L' U2 R U' L U2 B L'"), # 12
        RootAlg.new('h718', "L' B' R' U2 R B L U2 F' L F L'"), # 12
        RootAlg.new('h1177', "F' B U' F U B' L F R' F' R L'"), # 12
        RootAlg.new('h590b', "B' R B' R' B2 U2 R' U L U' R L'"), # 12
        RootAlg.new('h307c', "R2 L' D B' D' R L2 D' F D R L'"), # 12
        RootAlg.new('h16', "L' U R U' D' B2 D L2 U2 R' U L'"), # 12
        RootAlg.new('h963', "R L U2 L2 D' B2 D L2 U R' U L'"), # 12
        RootAlg.new('h386', "L B' D2 F D F2 D B U' R2 U L'"), # 12
        RootAlg.new('h550b', "R' L' D2 L U L' D2 L2 U' R U L'"), # 12
        RootAlg.new('h1091', "R' L' U2 R U R' U2 L2 U' R U L'"), # 12
        RootAlg.new('h698', "B L U' L' B' R' U2 L U' R U L'"), # 12
        RootAlg.new('h1156', "R B U' L U' L' U L U2 L' B' R'"), # 12
        RootAlg.new('h1186', "R2 U R' B' R U' R' U B2 U' B' R'"), # 12
        RootAlg.new('h92', "B U B' U' B' U' R U B2 U' B' R'"), # 12
        RootAlg.new('h800b', "R L' U' B' U B L U2 B U' B' R'"), # 12
        RootAlg.new('h34', "F2 B D' L D F2 B' R B U' B' R'"), # 12
        RootAlg.new('h136', "B L U L' U' B' R U B U' B' R'"), # 12
        RootAlg.new('h21', "F' L' U' L U F R U B U' B' R'"), # 12
        RootAlg.new('h359b', "R B U' L U R' U L' U' R B' R'"), # 12
        RootAlg.new('h477', "R U B U' R' L U L' U' R B' R'"), # 12
        RootAlg.new('h640', "B L' B' R B' L B2 R' U2 R B' R'"), # 12
        RootAlg.new('h790', "R U B2 D B' U2 B D' B' U B' R'"), # 12
        RootAlg.new('h90', "R U B' U' B2 U' B2 U2 B2 U B' R'"), # 12
        RootAlg.new('h362', "R2 D B2 L2 D' R' D L' U2 L' D' R'"), # 12
        RootAlg.new('h2', "R U D B2 U2 B' U B U B2 D' R'"), # 12
        RootAlg.new('h1053', "B U B' R D B' U B' U' B D' R'"), # 12
        RootAlg.new('h1055', "R D L' B L B2 L' B L B D' R'"), # 12
        RootAlg.new('h1030', "R F D L' U' B2 U L D' R2 F' R'"), # 12
        RootAlg.new('h815', "R B L' U R U' L U R' B' U' R'"), # 12
        RootAlg.new('h1090', "R2 D L' B' L D' R' B U2 B' U' R'"), # 12
        RootAlg.new('h372', "R2 L' D B' D' R' L B U2 B' U' R'"), # 12
        RootAlg.new('h169b', "R L' B U' B' U L B U2 B' U' R'"), # 12
        RootAlg.new('h471', "B' R2 D' R' D2 B' D' B' U B' U' R'"), # 12
        RootAlg.new('h901', "R2 B2 L' B' L B2 R' B2 U B' U' R'"), # 12
        RootAlg.new('h252b', "R' B U2 B' U2 B' R2 B2 U B' U' R'"), # 12
        RootAlg.new('h437', "R' U2 R U R' U R2 B U B' U' R'"), # 12
        RootAlg.new('h182', "B U L U' L' B' R B U B' U' R'"), # 12
        RootAlg.new('h169', "B' R' U' R U B R B U B' U' R'"), # 12
        RootAlg.new('h867', "R' U2 R2 B' U R2 U R2 U' B U' R'"), # 12
        RootAlg.new('h1188', "F' L' U2 B L' B' L2 F U' R U' R'"), # 12
        RootAlg.new('h108', "R U2 L' B' R B R2 L U' R U' R'"), # 12
        RootAlg.new('h194', "B2 U' R2 B R' B' R' U B2 R U' R'"), # 12
        RootAlg.new('h86', "B' D R2 U' R' U R2 D' B R U' R'"), # 12
        RootAlg.new('h171', "R B2 U D L B L' B' U' D' B2 R'"), # 12
        RootAlg.new('h599', "B' R B' D B2 R' U' R B2 D' B2 R'"), # 12
        RootAlg.new('h990b', "R B2 U L' B' L B L U' L' B2 R'"), # 12
        RootAlg.new('h709', "B' R B' D2 L D' L' D L' D2 B2 R'"), # 12
        RootAlg.new('h580', "B L' B' R B2 D' B D B' L B2 R'"), # 12
        RootAlg.new('h1014', "B L' B L B' L' B2 R B' L B2 R'"), # 12
        RootAlg.new('h523', "R B U' B' U' B U L' B L B2 R'"), # 12
        RootAlg.new('h61', "R B R' U L U' R L2 B L B2 R'"), # 12
        RootAlg.new('h819', "L U L' U R U' B2 U' B2 U B2 R'"), # 12
        RootAlg.new('h990', "R B2 L' U' B' U L U' B U B2 R'"), # 12
        RootAlg.new('h357b', "R B D B2 D F U' L2 U F' D2 R'"), # 12
        RootAlg.new('h445b', "L B2 L2 B2 L' B' R B D2 L2 D2 R'"), # 12
        RootAlg.new('h445c', "R D2 L2 D2 B' R' B R D2 L2 D2 R'"), # 12
        RootAlg.new('h267', "F' U' F R2 D L' B' L D' R' U2 R'"), # 12
        RootAlg.new('h970', "R U' B U' B' U' B' R B R' U2 R'"), # 12
        RootAlg.new('h363', "R L' B R B2 L' B R' B' L2 U2 R'"), # 12
        RootAlg.new('h1024', "B U B2 R B2 U B' R2 U R2 U2 R'"), # 12
        RootAlg.new('h295b', "R B U2 B2 R2 D' R' D R' B U2 R'"), # 12
        RootAlg.new('h645', "R U B U B2 U' R' U R B U2 R'"), # 12
        RootAlg.new('h750', "R L U2 L' B L U2 L2 B' L U2 R'"), # 12
        RootAlg.new('h1101', "F' U' L' U' B L' B' L2 F R U2 R'"), # 12
        RootAlg.new('h950', "R B U2 L' B' R B2 L B R' B R'"), # 12
        RootAlg.new('h1209', "B' R2 U' R2 B R' B' R' U R' B R'"), # 12
        RootAlg.new('h550', "B' R U' R' U' B R U' B' U' B R'"), # 12
        RootAlg.new('h357', "R L B2 L F R' U2 R F' L2 B R'"), # 12
        RootAlg.new('h540', "B' U2 B2 U B R B R2 U R2 B R'"), # 12
        RootAlg.new('h946', "B U L U' L' U B' U' B' R B R'"), # 12
        RootAlg.new('h920', "B2 D B' U B D' B2 U' B' R B R'"), # 12
        RootAlg.new('h1021', "B L U L2 B L B2 U' B' R B R'"), # 12
        RootAlg.new('h515', "R U2 R' U' R B' U' R' U R B R'"), # 12
        RootAlg.new('h1209b', "R U' R' U R2 B' R2 U' R U B R'"), # 12
        RootAlg.new('h991b', "B' R B U' R U D' R U' R' D R'"), # 12
        RootAlg.new('h97', "L2 U' B L B' L2 U2 R D' B2 D R'"), # 12
        RootAlg.new('h189', "R F' L2 B2 D L' D' L B2 L2 F R'"), # 12
        RootAlg.new('h951', "R U' B2 L U L' U' B' U' B' U R'"), # 12
        RootAlg.new('h218b', "R B' U' B2 R B' R' B2 U B U R'"), # 12
        RootAlg.new('h990e', "L' U' R U' D B' U2 B D' L U R'"), # 12
        RootAlg.new('h1067', "R' U R U2 R' L' U R2 U' L U R'"), # 12
        RootAlg.new('h843', "L' U F2 D2 B2 L' D2 F2 U L U R'"), # 12
        RootAlg.new('h884', "R' L' F' U2 F R L B2 D L2 D' B2"), # 12
        RootAlg.new('h524', "R' U' R U2 B2 U L' B L B' U' B2"), # 12
        RootAlg.new('h399', "B R U B2 U' B R' B U B' U' B2"), # 12
        RootAlg.new('h816', "B2 U B R' U' R U B U' B2 U' B2"), # 12
        RootAlg.new('h991', "B U' B U' R B R' B' U2 B U' B2"), # 12
        RootAlg.new('h511', "L U L' U B2 R L2 B R' B' L2 B2"), # 12
        RootAlg.new('h71', "B' R B' L2 D R D R' D' R' L2 B2"), # 12
        RootAlg.new('h883e', "B2 L2 U' B2 D B2 D' R2 U R2 L2 B2"), # 12
        RootAlg.new('h883c', "B2 L2 D' R2 D R2 U' R2 U R2 L2 B2"), # 12
        RootAlg.new('h944', "B2 R2 U B' L B U' B' L' B R2 B2"), # 12
        RootAlg.new('h427c', "B2 R2 B' U L' B L B' U' B R2 B2"), # 12
        RootAlg.new('h896b', "B L' B R2 B' L2 U L' U' B R2 B2"), # 12
        RootAlg.new('h35', "R B L' B' R' B2 R2 B' L B R2 B2"), # 12
        RootAlg.new('h173', "R B2 L' B2 R' B2 R2 B' L B R2 B2"), # 12
        RootAlg.new('h67d', "R L' B2 D2 B' R2 L2 F' R L' U2 B2"), # 12
        RootAlg.new('h764', "B U2 B U B2 U B2 R B' R' U2 B2"), # 12
        RootAlg.new('h1162', "B2 U2 B R B' R' U R' U' R U2 B2"), # 12
        RootAlg.new('h984', "B' U' B2 D' B R B R' U B' D B2"), # 12
        RootAlg.new('h672', "B2 R2 F' L F' D2 F2 R2 F' L' F B2"), # 12
        RootAlg.new('h67c', "B2 R' L U2 F' R2 L2 B' D2 R' L B2"), # 12
        RootAlg.new('h1135', "B2 U' B2 R B' R' U' B' U B' U B2"), # 12
        RootAlg.new('h1187', "R D2 L2 B L B' D' L2 D' R' U B2"), # 12
        RootAlg.new('h1157b', "B2 U' R' D2 L U2 L' D2 R B2 U B2"), # 12
        RootAlg.new('h676', "L' B L' B' L2 F2 D B' R2 B D' F2"), # 12
        RootAlg.new('h549b', "L' U' L F U F D B' R B D' F2"), # 12
        RootAlg.new('h486', "F' U R L2 D' B' D R' L' F' L' F2"), # 12
        RootAlg.new('h67b', "B2 R L' D2 B R2 L2 F' D2 R L' F2"), # 12
        RootAlg.new('h149', "R' F' L F R F2 L2 B L' B' L2 F2"), # 12
        RootAlg.new('h883d', "F2 R2 D' L2 U B2 U' B2 D R2 L2 F2"), # 12
        RootAlg.new('h1100', "F2 R2 L2 B' R' B R2 F' R F L2 F2"), # 12
        RootAlg.new('h300', "F2 U L' U' B' R' U R B L U2 F2"), # 12
        RootAlg.new('h888', "F2 D' L2 B' R' F U2 F' R B D F2"), # 12
        RootAlg.new('h67', "B2 R' L U2 F R2 L2 B' U2 R' L F2"), # 12
        RootAlg.new('h888b', "F2 U' F2 L' B' R U2 R' B L U F2"), # 12
        RootAlg.new('h830', "R' U' R U L' B R L' B R' B' L2"), # 12
        RootAlg.new('h641', "L' B' R B R' B R L' B R' B' L2"), # 12
        RootAlg.new('h445', "R L2 D2 R' L2 B' R B L2 D2 R' L2"), # 12
        RootAlg.new('h1054', "L2 B2 L B' R' U2 R2 B2 L' B R' L2"), # 12
        RootAlg.new('h1054b', "L2 B2 L B' L U2 L2 B2 R B R' L2"), # 12
        RootAlg.new('h594', "L' U R B' R2 U' R U' B' L' B2 L2"), # 12
        RootAlg.new('h38', "B' U' B U B L2 B2 R B' R' B2 L2"), # 12
        RootAlg.new('h427', "L2 B2 R B' L' D L D' B R' B2 L2"), # 12
        RootAlg.new('h427b', "L2 B2 R D' B R' B' R D R' B2 L2"), # 12
        RootAlg.new('h1086', "L F R' F R L B2 L' F2 L B2 L2"), # 12
        RootAlg.new('h857b', "B' U2 B L F R' F' L F2 R F2 L2"), # 12
        RootAlg.new('h63', "R2 L2 D L2 F2 R2 L2 B2 R2 D' R2 L2"), # 12
        RootAlg.new('h63b', "R2 L2 D L2 B2 R2 L2 F2 R2 D' R2 L2"), # 12
        RootAlg.new('h1109', "L2 B' R B' R' B2 U2 F' L' F U2 L2"), # 12
        RootAlg.new('h803', "L' U' L' D' L U' R L' B2 R' D L2"), # 12
        RootAlg.new('h928', "R L' B L' B' R' D' R B R' D L2"), # 12
        RootAlg.new('h926', "F U2 F' L2 D' B' R B' R' B2 D L2"), # 12
        RootAlg.new('h1157', "L2 D' R' D2 L U2 L' D2 R B2 D L2"), # 12
        RootAlg.new('h1174', "R B' R B2 R2 L' B L B' R2 B' R2"), # 12
        RootAlg.new('h1190', "R B' R B D B L' B L B2 D' R2"), # 12
        RootAlg.new('h549', "R B U' B' U' R D L' B L D' R2"), # 12
        RootAlg.new('h919', "R2 U R2 B' R B R B' R B U' R2"), # 12
        RootAlg.new('h1145', "R B2 L' B' R L U R' B' R U' R2"), # 12
        RootAlg.new('h264', "R2 U B' R' B R' U R U' R U' R2"), # 12
        RootAlg.new('h426', "R U' B R U2 R' U2 B' U R U' R2"), # 12
        RootAlg.new('h1182', "R' F2 R' B2 R L F L' F R' B2 R2"), # 12
        RootAlg.new('h1027', "B' U R2 D B D' R2 B U' R2 B2 R2"), # 12
        RootAlg.new('h896', "R B' R B2 L' B2 D B' D' L B2 R2"), # 12
        RootAlg.new('h432', "R2 B2 R2 U' R U B U' B' R B2 R2"), # 12
        RootAlg.new('h1095', "R L2 B R B' L2 B2 R' B R B2 R2"), # 12
        RootAlg.new('h576', "R B' R' B U2 R2 F' L F' L' F2 R2"), # 12
        RootAlg.new('h990d', "L' D2 L2 F L2 D2 B L B' R2 B R2"), # 12
        RootAlg.new('h1155', "R B2 L' B2 L B' R L' B' L B R2"), # 12
        RootAlg.new('h359', "R U' B U' B' R' U R B' R B R2"), # 12
        RootAlg.new('h146', "B' R B R' U2 R2 D' L F2 L' D R2"), # 12
        RootAlg.new('h195', "B' R B R' U2 R2 D' R U2 R' D R2"), # 12
        RootAlg.new('h537b', "B2 U B R B D' B' R' B R2 D R2"), # 12
        RootAlg.new('h528', "R' U2 B' D' R' D B2 U2 B' R' U R2"), # 12
        RootAlg.new('h990c', "B' D B' U2 B R' B' U2 B R D' B"), # 12
        RootAlg.new('h889', "L B' R2 D' F' D R' B L' B' R' B"), # 12
        RootAlg.new('h777', "R' U' R U' B U' B' U' R B' R' B"), # 12
        RootAlg.new('h1005', "R U2 R2 U' R2 U' R' U2 R B' R' B"), # 12
        RootAlg.new('h1014b', "L U' R' U L' U R U2 R B' R' B"), # 12
        RootAlg.new('h910', "L U2 L' B L2 B R B' L2 B2 R' B"), # 12
        RootAlg.new('h923d', "L U L' U' L' B' R B2 L B2 R' B"), # 12
        RootAlg.new('h480', "L U2 R' U L' U' R B2 R B R' B"), # 12
        RootAlg.new('h771', "B' U' B' R' U' R U B2 U2 B' U' B"), # 12
        RootAlg.new('h951b', "L U L' B2 U' R' U R2 B R' U' B"), # 12
        RootAlg.new('h597b', "B D F' L F D' B R B R' U' B"), # 12
        RootAlg.new('h317b', "B U L U' L' B2 R' F R' F' R2 B"), # 12
        RootAlg.new('h913', "B' U' R' U2 R' D' R U' R' D R2 B"), # 12
        RootAlg.new('h1089b', "R U B2 D B' U' B2 D2 R D R2 B"), # 12
        RootAlg.new('h551', "B U B2 R2 U' R' D' R U D R2 B"), # 12
        RootAlg.new('h1173', "B' U2 R U R' B R U' R' B' U2 B"), # 12
        RootAlg.new('h1151', "B' R' U' R B2 L U L' U' B2 U2 B"), # 12
        RootAlg.new('h273', "B U2 B' R B' R' U' B2 U' B2 U2 B"), # 12
        RootAlg.new('h857', "B' U2 R' B L' B' R B2 L B2 U2 B"), # 12
        RootAlg.new('h1122', "B' R' U' R2 U' L' U R' U' L U2 B"), # 12
        RootAlg.new('h1173b', "B' U2 B' R' B U B U' B' R U2 B"), # 12
        RootAlg.new('h597c', "B L U' L' U B2 D' F R F' D B"), # 12
        RootAlg.new('h114', "B' U' D' R2 U R' U' R' U R' D B"), # 12
        RootAlg.new('h1114', "B2 R B L' B2 R' U' B' U B2 L B"), # 12
        RootAlg.new('h537', "L' U B2 R' B U B U' L B' R B"), # 12
        RootAlg.new('h206', "L U F U' F' U L' B' R' U' R B"), # 12
        RootAlg.new('h626', "L U L2 B' R B L B' R2 U' R B"), # 12
        RootAlg.new('h218', "B' R' B U2 B' U' B U' B' U2 R B"), # 12
        RootAlg.new('h721', "B' U R' U R B U B' R' U2 R B"), # 12
        RootAlg.new('h1046', "R' F' L F' L' F R B' R' F R B"), # 12
        RootAlg.new('h440', "L U2 L' U B' U' R' F' U2 F R B"), # 12
        RootAlg.new('h923', "B' U2 B U L U L' B' R' U R B"), # 12
        RootAlg.new('h89', "R B U B' U' R' B' U' R' U R B"), # 12
        RootAlg.new('h923b', "L' B2 R B2 L B' R' U' R' U R B"), # 12
        RootAlg.new('h923c', "R' U2 R U2 R B' R' U' R' U R B"), # 12
        RootAlg.new('h317', "B U2 B' U' B U' B2 U' R' U R B"), # 12
        RootAlg.new('h327', "B L F' L F L2 B2 U' R' U R B"), # 12
        RootAlg.new('h218c', "L U L' B' R' U' R U' R' U R B"), # 12
        RootAlg.new('h809b', "R L' D' B2 D B L B' R' B' U B"), # 12
        RootAlg.new('h1201', "R U B' R B R2 B' R U' R' U B"), # 12
        RootAlg.new('h186', "B' U' B' R B R' B' R B R' U B"), # 12
        RootAlg.new('h376', "L U L2 B L B2 R B' R' B U B"), # 12
        RootAlg.new('h627', "L2 D L D2 R B R' D B' L U B"), # 12
        RootAlg.new('h922', "L' U' B' U R' B L B' U' R U B"), # 12
        RootAlg.new('h21b', "R U B U' B' R' B' R' U' R U B"), # 12
        RootAlg.new('h729', "L' B L B' U2 B' U2 R' U' R U B"), # 12
        RootAlg.new('h1138b', "B2 L2 B R2 B' L2 B R U' R U B"), # 12
        RootAlg.new('h177', "F' L B2 R L D L' D' R' B2 L' F"), # 12
        RootAlg.new('h114d', "F B' R B D2 B2 R' F2 U2 B2 L' F"), # 12
        RootAlg.new('h114e', "F B' R B D2 B2 L' U2 B2 D2 R' F"), # 12
        RootAlg.new('h176', "F B2 R' B2 R B2 R F2 L2 B2 L2 F"), # 12
        RootAlg.new('h1039', "R' F2 L' D2 L' F' R2 B' R' F2 L2 F"), # 12
        RootAlg.new('h1123', "F' U R D' B2 D R' U2 L U L2 F"), # 12
        RootAlg.new('h621', "F D B' R B D' F2 U' L' U' L F"), # 12
        RootAlg.new('h961', "L' B' U R' U' R L F' L' B L F"), # 12
        RootAlg.new('h712', "B L U' L' F' B' R' F U F' R F"), # 12
        RootAlg.new('h938', "L' U' B U R B2 R' L U L' B' L"), # 12
        RootAlg.new('h977b', "R L' D B2 D' R' B L U L' B' L"), # 12
        RootAlg.new('h394', "L' D B' R' L2 U R U' L2 B D' L"), # 12
        RootAlg.new('h647', "R B U B' L' U B U' B' U' R' L"), # 12
        RootAlg.new('h861', "R B U B' R U' L' U R' U' R' L"), # 12
        RootAlg.new('h1015b', "R U2 B' U2 B' U2 B U2 L' B2 R' L"), # 12
        RootAlg.new('h1127b', "L' B U B2 U' B2 U' B R B2 R' L"), # 12
        RootAlg.new('h63c', "F2 B2 U R2 L2 D' R' L U2 D2 R' L"), # 12
        RootAlg.new('h114b', "R L F' R2 U2 L2 B' R2 D2 B R' L"), # 12
        RootAlg.new('h114c', "R L B' D2 R2 U2 F' R2 D2 B R' L"), # 12
        RootAlg.new('h935b', "R U' B' U2 B U L' D' B D R' L"), # 12
        RootAlg.new('h967', "L' B' U' B2 U2 R B R' U2 B' U' L"), # 12
        RootAlg.new('h491', "B U B' L' B' R B R2 U R U' L"), # 12
        RootAlg.new('h539', "B' U' R' U B L' B' R2 B' R' B2 L"), # 12
        RootAlg.new('h130', "L' U2 L U L' U B' R B' R' B2 L"), # 12
        RootAlg.new('h707', "L' B' U B U' B' U' R B' R' B2 L"), # 12
        RootAlg.new('h998', "B' R B L' B2 R' B R B' R' B2 L"), # 12
        RootAlg.new('h1083', "L' B2 U' R D' R' U R2 D R2 B2 L"), # 12
        RootAlg.new('h935', "R2 L' B D B2 D' B D B D' R2 L"), # 12
        RootAlg.new('h1015', "R B2 R L' B' D2 B' D2 B D2 R2 L"), # 12
        RootAlg.new('h349', "R L2 B2 R' L B U2 B2 U2 B' U2 L"), # 12
        RootAlg.new('h185', "R F U' B U' B' U F' R' L' U2 L"), # 12
        RootAlg.new('h593', "R L2 B L B U B2 U' B2 R' U2 L"), # 12
        RootAlg.new('h798', "L' U2 B2 R' U' R U B U' B U2 L"), # 12
        RootAlg.new('h1138', "B' R' U' R U R B L' B' R' B L"), # 12
        RootAlg.new('h841', "R U' L' U R' U' B2 R B R' B L"), # 12
        RootAlg.new('h156', "L' U' L U' L' U2 B2 R B R' B L"), # 12
        RootAlg.new('h1018', "L2 B2 R B' L B2 R2 U' R U' B L"), # 12
        RootAlg.new('h1166', "L' B L' B' L B2 R B R' U2 B L"), # 12
        RootAlg.new('h422', "B2 U' B R' B' U B2 L' B' R B L"), # 12
        RootAlg.new('h1065', "B' R' U' R U R' B L' B' R B L"), # 12
        RootAlg.new('h1091b', "B' R B L' B2 R' B2 U' B' U B L"), # 12
        RootAlg.new('h993', "R' U L U' R U L2 U' B' U B L"), # 12
        RootAlg.new('h659', "L2 D' R B2 R' D L U B' U B L"), # 12
        RootAlg.new('h983', "L' B L B' U L' D' R B' R' D L"), # 12
        RootAlg.new('h597', "L' B L B' U' L' D' R B R' D L"), # 12
        RootAlg.new('h715', "B' R' U' R B L' D' R B R' D L"), # 12
        RootAlg.new('h987', "L2 D' B2 R D L D' R2 U2 R D L"), # 12
        RootAlg.new('h883b', "B U' F U2 B' U F' R' L' U2 R L"), # 12
        RootAlg.new('h590', "R' U' R2 B' R' B L' B U' B' U L"), # 12
        RootAlg.new('h188', "F R U' B U B' U' R' F' L' U L"), # 12
        RootAlg.new('h23', "R B U B' U' R' L' B' U' B U L"), # 12
        RootAlg.new('h82', "B' R' U' R U B L' B' U' B U L"), # 12
        RootAlg.new('h101', "R' U' F' U F R L' B' U' B U L"), # 12
        RootAlg.new('h241', "R L2 D' B2 D R' L B' U B U L"), # 12
        RootAlg.new('h808b', "R L' U' L' B' U' B U R' L U L"), # 12
        RootAlg.new('h923e', "B U B' U' B' R' B U2 B U2 B' R"), # 12
        RootAlg.new('h358b', "R' B U' R' L2 F R F' L2 U B' R"), # 12
        RootAlg.new('h784', "L' U' B' U B L2 U' R' U L' U' R"), # 12
        RootAlg.new('h215', "R' U R2 U D B U' B' D' R2 U' R"), # 12
        RootAlg.new('h724', "R' U2 R U' R B U B' U' R2 U' R"), # 12
        RootAlg.new('h1192', "R' U' R U2 R B U B' U' R2 U' R"), # 12
        RootAlg.new('h88', "R B2 L' B' R2 L D2 L2 F L2 D2 R"), # 12
        RootAlg.new('h1127', "R' U' R U' B L U' L' B' R' U2 R"), # 12
        RootAlg.new('h791', "R' U2 R2 U B U' B' R' U' R' U2 R"), # 12
        RootAlg.new('h744', "B' R B R' U2 R' U R U' R' U2 R"), # 12
        RootAlg.new('h1013', "B' R B R' U2 B U' B' U R' U2 R"), # 12
        RootAlg.new('h1165', "R U B2 U R2 U' R2 U' B2 R2 U2 R"), # 12
        RootAlg.new('h600', "R U B2 D B2 U' B' D' B R2 U2 R"), # 12
        RootAlg.new('h18', "R' U' R U2 B U B2 R B R2 U2 R"), # 12
        RootAlg.new('h1127c', "L' B U B2 U' B2 U' B' R' L U2 R"), # 12
        RootAlg.new('h1003', "R' B' R U' R' U2 R U' R' U' B R"), # 12
        RootAlg.new('h862', "R' B' R2 U R2 U' R' U2 R' U' B R"), # 12
        RootAlg.new('h239', "R' B' R2 B U B' R2 U' R2 U B R"), # 12
        RootAlg.new('h1059', "R' B' R2 U R2 U R2 U2 R2 U B R"), # 12
        RootAlg.new('h883', "R2 D' L2 D' B2 L' D' R D2 L' D R"), # 12
        RootAlg.new('h993b', "R' F' B U' L' U L U B' U' F R"), # 12
        RootAlg.new('h1047', "R B2 D2 L2 B D2 R' B R' U2 F R"), # 12
        RootAlg.new('h1046b', "L' U' B' U2 B R' L F U' F' U R"), # 12
        RootAlg.new('h135', "R' U' R B2 L U L' U' B2 R' U R"), # 12
        RootAlg.new('h995b', "L U2 L' U2 L' B2 L B2 U R' U R"), # 12
        RootAlg.new('h494', "R B L' B' R' B2 L B2 U R' U R"), # 12
        RootAlg.new('h995c', "R B2 L' B2 R' B2 L B2 U R' U R"), # 12
        RootAlg.new('h995', "R B2 R' U2 R' U2 R B2 U R' U R"), # 12
        RootAlg.new('h473', "B L U' L' B' R' U' R U R' U R"), # 12
        RootAlg.new('h326', "R U B U' B' R2 U2 R U R' U R"), # 12
        RootAlg.new('h822', "R' U' R U' R U B U' B' R2 U R"), # 12
        RootAlg.new('h1012', "B U B' R B2 L' B' L B' R2 U R"), # 12
        RootAlg.new('h551b', "R B2 D B2 U2 B' D' B U2 R2 U R"), # 12
        RootAlg.new('h1089', "R U B2 D B' U' B2 D' B R2 U R"), # 12
        RootAlg.new('h217', "B L U L' U' B' R' F' U' F U R"), # 12

        RootAlg.new('h190', "B2 L2 U2 B R B R' B2 U2 L2 B' L' B'"), # 13
        RootAlg.new('h131', "B U' R' U' R U' B2 L' B2 L2 U' L' B'"), # 13
        RootAlg.new('h828', "B' U2 B2 U B2 R' U R B2 L U' L' B'"), # 13
        RootAlg.new('h658', "R' U L F R' F' R2 L' B L U' L' B'"), # 13
        RootAlg.new('h973', "B2 R2 B' L2 B R2 B' L2 U L U' L' B'"), # 13
        RootAlg.new('h325', "R U2 R' U' R U' R' B U L U' L' B'"), # 13
        RootAlg.new('h703', "B2 L U2 R B' R' U2 B2 U2 B U2 L' B'"), # 13
        RootAlg.new('h1194', "F' U2 F U R B U L B' R' B L' B'"), # 13
        RootAlg.new('h583', "R B2 U2 B' U' L B U' B2 R' B L' B'"), # 13
        RootAlg.new('h127', "B U' L U' L' U R' U L U' R L' B'"), # 13
        RootAlg.new('h1200', "B U R L D2 R' U2 R D2 R' U L' B'"), # 13
        RootAlg.new('h638b', "B L' B2 D' R2 D' R2 D2 B2 L2 U L' B'"), # 13
        RootAlg.new('h1000', "L U' R' U L' U R U B L U L' B'"), # 13
        RootAlg.new('h667', "B R B L' B' L B' L' B' L B R' B'"), # 13
        RootAlg.new('h397b', "B R U' B2 U' B U' B' U2 B2 U R' B'"), # 13
        RootAlg.new('h759', "B R U B' U2 B' U2 B' U2 B2 U R' B'"), # 13
        RootAlg.new('h243', "B U L' B R2 L2 U L' U' R2 B' U' B'"), # 13
        RootAlg.new('h104', "B U B R2 U2 R B2 R' U2 R2 B' U' B'"), # 13
        RootAlg.new('h914', "R' U2 R B L U' F U F' U2 L' U' B'"), # 13
        RootAlg.new('h856', "B' D' F R' F' D B2 U' L U2 L' U' B'"), # 13
        RootAlg.new('h398b', "B U2 B' U' B R' U L U' R L' U' B'"), # 13
        RootAlg.new('h869b', "B U' R' U L2 U' R U L' U L' U' B'"), # 13
        RootAlg.new('h81b', "B' U' R B' R' B U B2 L U L' U' B'"), # 13
        RootAlg.new('h462', "F R2 B' R' B R' F' B L U L' U' B'"), # 13
        RootAlg.new('h284', "R B2 L' B' L B' R' B L U L' U' B'"), # 13
        RootAlg.new('h352c', "R U2 R' U' R U' R' B L U L' U' B'"), # 13
        RootAlg.new('h476', "R B U B' U' R2 U' R2 B' R' B2 U' B'"), # 13
        RootAlg.new('h384b', "F' B2 D L' D' F B2 R B' R' B2 U' B'"), # 13
        RootAlg.new('h683', "B L U' L2 B' R B L B2 R' B2 U' B'"), # 13
        RootAlg.new('h927', "B U2 B2 U' L' B2 R' L U' R B2 U' B'"), # 13
        RootAlg.new('h151', "B L2 U2 R' U L2 U' R L2 U2 L2 U' B'"), # 13
        RootAlg.new('h699', "R2 D' L F L' D' L2 F' L2 D2 R2 U' B'"), # 13
        RootAlg.new('h454', "B U B' R2 U' R U' R' U2 R2 B U' B'"), # 13
        RootAlg.new('h497', "R2 D' R U2 R' L F' L' D R2 B U' B'"), # 13
        RootAlg.new('h850b', "L' B L U' R L' B2 R' B' L B U' B'"), # 13
        RootAlg.new('h66', "B' R' U' R B2 U B L' B2 L B U' B'"), # 13
        RootAlg.new('h850', "L' B L U R' U2 R L' B L B U' B'"), # 13
        RootAlg.new('h824c', "B2 D B' U B D' B2 R' U R B U' B'"), # 13
        RootAlg.new('h725', "B' U2 B U R B' R' U B U B U' B'"), # 13
        RootAlg.new('h797', "B U2 B' U' R' U' R B2 L' B' L U' B'"), # 13
        RootAlg.new('h212b', "R' U' F' U2 F U2 R B2 L' B' L U' B'"), # 13
        RootAlg.new('h638c', "B U' F2 R' D2 R' D2 R2 F2 U2 L U' B'"), # 13
        RootAlg.new('h428b', "B2 R2 B' L' B R2 B2 U' B U L U' B'"), # 13
        RootAlg.new('h70c', "B L U R' L' U2 B' U' B U' R U' B'"), # 13
        RootAlg.new('h776c', "F2 B2 D2 F' R F D2 B2 L B L' F2 B'"), # 13
        RootAlg.new('h360b', "B R L2 U2 L2 B L' B' L' U2 R' L2 B'"), # 13
        RootAlg.new('h743', "B2 R2 F2 D2 F D F R2 B2 U' B L2 B'"), # 13
        RootAlg.new('h263b', "F' B L F2 B' R U R' F' U B L2 B'"), # 13
        RootAlg.new('h76', "B L2 D' B R2 D' F2 D R2 B' D L2 B'"), # 13
        RootAlg.new('h646', "R U B U' L B' R' F' B L F L2 B'"), # 13
        RootAlg.new('h375', "B L2 U' L B' R B' R' B2 L' U L2 B'"), # 13
        RootAlg.new('h765b', "B R U2 R' U' R U' R' L U L' U2 B'"), # 13
        RootAlg.new('h125', "B U' B' R B' R' B2 U2 L U L' U2 B'"), # 13
        RootAlg.new('h679b', "B R2 B' L' B R2 L U2 R B R' U2 B'"), # 13
        RootAlg.new('h81d', "R2 L2 F' D' F R2 L2 U' B U2 B2 U2 B'"), # 13
        RootAlg.new('h681', "R B' R2 U' R U' L' B' L U2 B2 U2 B'"), # 13
        RootAlg.new('h545', "B' U' B2 L U R' U2 R L' U B2 U2 B'"), # 13
        RootAlg.new('h115', "B' U' B R D B2 D' B' R' U B2 U2 B'"), # 13
        RootAlg.new('h799b', "B U' R U' B' R D B2 D' B' R2 U2 B'"), # 13
        RootAlg.new('h751', "B U2 R B' R B2 R' B' R B' R2 U2 B'"), # 13
        RootAlg.new('h39b', "B U2 B2 R B' D B D' B R' B U2 B'"), # 13
        RootAlg.new('h164', "B U L U' L' U2 B2 R B R' B U2 B'"), # 13
        RootAlg.new('h989', "R B' R' B2 U B' R' U' R U' B U2 B'"), # 13
        RootAlg.new('h648b', "R L' B R' L U2 L' B L U2 B U2 B'"), # 13
        RootAlg.new('h1037b', "R' U2 R2 U B U' B2 R' B U B U2 B'"), # 13
        RootAlg.new('h814', "B U' R' U2 B2 D' R2 D B2 U2 R U2 B'"), # 13
        RootAlg.new('h1207', "B D' R2 U2 D R B R' U2 D' R2 D B'"), # 13
        RootAlg.new('h887', "B' R F' D2 F R' F B2 U2 F2 L' F B'"), # 13
        RootAlg.new('h1103d', "F B D' L' D F2 U' R U' R' U2 F B'"), # 13
        RootAlg.new('h336b', "F' U B L U2 R U' L' U R' U2 F B'"), # 13
        RootAlg.new('h614', "B' R B R' U B2 U L U' L2 B' L B'"), # 13
        RootAlg.new('h335', "R2 B' L' F' R' F2 L D2 B2 L' F' L B'"), # 13
        RootAlg.new('h335b', "R2 B' L' F' L' U2 L F2 D2 R' F' L B'"), # 13
        RootAlg.new('h685', "F B' R F2 D2 F2 B R' B U2 F' L B'"), # 13
        RootAlg.new('h631d', "B U B' U B R' U2 R B2 L' B2 L B'"), # 13
        RootAlg.new('h1075d', "B R B2 D B2 D' R2 U' R L' B2 L B'"), # 13
        RootAlg.new('h581b', "B' U' R U B U' B L' B2 R' B2 L B'"), # 13
        RootAlg.new('h1210b', "R U2 R2 U' R2 U' B2 L' B R' B2 L B'"), # 13
        RootAlg.new('h407b', "L F' R2 F U2 L' U2 L' B' D2 B2 L B'"), # 13
        RootAlg.new('h679', "B2 L' D' B R2 B R B' R2 D B2 L B'"), # 13
        RootAlg.new('h1195b', "B U2 R B R' U2 R2 B' L' B R2 L B'"), # 13
        RootAlg.new('h824', "R2 U R' B R U' R' L' B' R' B L B'"), # 13
        RootAlg.new('h588', "R U2 R' U' R U' B2 L' B2 R' B L B'"), # 13
        RootAlg.new('h588b', "R L' B2 D' R D' R' D2 B2 R' B L B'"), # 13
        RootAlg.new('h104b', "R L' U' L U B2 L' B2 R' U2 B L B'"), # 13
        RootAlg.new('h503', "R B2 L2 B2 U' L' U R' L U2 B L B'"), # 13
        RootAlg.new('h1141b', "F U R U2 R' F' B L' B' U B L B'"), # 13
        RootAlg.new('h1117b', "B U B' U B R' D2 R U2 R' D2 R B'"), # 13
        RootAlg.new('h631c', "B U B' U B R' U2 L U2 L' U2 R B'"), # 13
        RootAlg.new('h747b', "B L U L' U R' U2 L U2 L' U2 R B'"), # 13
        RootAlg.new('h631b', "B U B' U B L' B2 L B2 R' U2 R B'"), # 13
        RootAlg.new('h747c', "B L U L' U L' B2 L B2 R' U2 R B'"), # 13
        RootAlg.new('h581', "B' U' R U B U' B R' U2 R' U2 R B'"), # 13
        RootAlg.new('h452', "B R' U2 B2 R2 B R' B' R' B2 U2 R B'"), # 13
        RootAlg.new('h296', "B R' U2 B2 R' B R2 B' R B2 U2 R B'"), # 13
        RootAlg.new('h897', "B2 U2 R B' R' U' B2 R B R2 U R B'"), # 13
        RootAlg.new('h789', "R' F2 L F R L' B R' U' F U R B'"), # 13
        RootAlg.new('h1099', "B2 R2 U B U B' U' B' U' R2 B' U B'"), # 13
        RootAlg.new('h1128', "B U' L U' B' R' U' R U B L' U B'"), # 13
        RootAlg.new('h33', "B U' R U' B2 U2 B2 U2 B2 U' R' U B'"), # 13
        RootAlg.new('h33b', "B U' R' B2 U2 R2 U2 B2 R2 U2 R' U B'"), # 13
        RootAlg.new('h41', "R B' D B2 L' B L D' B R' B2 U B'"), # 13
        RootAlg.new('h293', "B U' B2 R2 U' B R2 B' U R2 B2 U B'"), # 13
        RootAlg.new('h272b', "B' D' R2 U' R2 U B U2 B' D B2 U B'"), # 13
        RootAlg.new('h1056', "F' B U' F R' L2 D' F D R L2 U B'"), # 13
        RootAlg.new('h847', "B U2 B U2 R B2 R' U2 B2 U' B U B'"), # 13
        RootAlg.new('h65c', "R' U R B U2 B' U2 R' U2 R B U B'"), # 13
        RootAlg.new('h39c', "R B2 L2 D L B D' B R' B L U B'"), # 13
        RootAlg.new('h423c', "F L2 D2 R' B R D2 L2 F L F' L' F'"), # 13
        RootAlg.new('h817d', "L' U2 R L B' R' F R B2 U2 B' R' F'"), # 13
        RootAlg.new('h678b', "R B R' U2 L U2 L' U2 F R B' R' F'"), # 13
        RootAlg.new('h678', "R B L' B2 L B2 R' U2 F R B' R' F'"), # 13
        RootAlg.new('h305b', "F2 R2 L2 B' D B R2 L2 F' R U' R' F'"), # 13
        RootAlg.new('h66c', "L' B' R' U R B U2 L F R U' R' F'"), # 13
        RootAlg.new('h396', "L' B' R B' R' B2 L F U R U' R' F'"), # 13
        RootAlg.new('h75', "F' L2 B L B' L F2 R2 B' R' B R' F'"), # 13
        RootAlg.new('h708', "F R B' U2 L' B' L U2 B U' R' U' F'"), # 13
        RootAlg.new('h959', "F R U F2 D2 L B2 D L' D F2 U' F'"), # 13
        RootAlg.new('h81c', "R2 L2 F' D' F R2 L2 U' F R2 B2 R2 F'"), # 13
        RootAlg.new('h178b', "F' U' F U F R2 D2 L B' L' D2 R2 F'"), # 13
        RootAlg.new('h657', "L2 D' L' D' B R' B' D2 L' U' F' U2 F'"), # 13
        RootAlg.new('h85', "F2 R2 D2 L B L' D' R D' R F' U2 F'"), # 13
        RootAlg.new('h660', "F U2 L2 D2 B R B' D2 L' F' L' U2 F'"), # 13
        RootAlg.new('h660b', "B L2 D2 R2 F R B' D2 L' F' L' U2 F'"), # 13
        RootAlg.new('h100', "L' B L' B' L2 F2 B' R' F' R B U2 F'"), # 13
        RootAlg.new('h404', "L2 B' D2 B' L B2 L2 F L' U2 R U2 F'"), # 13
        RootAlg.new('h423b', "R2 B' R' F' R' F2 D2 R' B2 L' B' R F'"), # 13
        RootAlg.new('h423', "R2 B' R' F' L' U2 F2 R' D2 R' B' R F'"), # 13
        RootAlg.new('h1103e', "F' B L' F' B' L2 F' R' B D2 B' R F'"), # 13
        RootAlg.new('h33c', "F2 R2 L2 B' R' D B R2 L2 F' U' R F'"), # 13
        RootAlg.new('h1128b', "F U' R L' B' U' B U L U' R' U F'"), # 13
        RootAlg.new('h746', "F R B U2 L U' L2 B L B2 R' U F'"), # 13
        RootAlg.new('h12', "L2 U F2 R2 D' B2 D2 R D' F' R U F'"), # 13
        RootAlg.new('h73', "L' U' L F' R2 B' R' B R2 F2 R U F'"), # 13
        RootAlg.new('h375b', "L B U' L2 B' R B' R' B2 L2 U B' L'"), # 13
        RootAlg.new('h496', "R B L' B' R' B L2 F L' B' L F' L'"), # 13
        RootAlg.new('h1009d', "R B' U' B R' L U F' U2 F2 U F' L'"), # 13
        RootAlg.new('h960', "R U2 R' U' R L B L' U' L B' R' L'"), # 13
        RootAlg.new('h766', "L U2 R B L2 B L2 D L' D' B2 R' L'"), # 13
        RootAlg.new('h565b', "B' U' R' U2 R2 B2 L' B2 R' B L2 U' L'"), # 13
        RootAlg.new('h565', "B' U' L U2 L2 B2 R B2 R' B L2 U' L'"), # 13
        RootAlg.new('h460b', "B' U' R' U R B L U2 L' U' L U' L'"), # 13
        RootAlg.new('h240', "B' R' U' R U B L U2 L' U' L U' L'"), # 13
        RootAlg.new('h620', "L2 B2 D R' F2 R D' B2 L2 U' L U' L'"), # 13
        RootAlg.new('h409', "B' R B' R' B2 U B' U' B U' L U' L'"), # 13
        RootAlg.new('h250b', "L' B2 D' R2 D' R2 D2 B2 L U' L U' L'"), # 13
        RootAlg.new('h388', "R' U2 B' R2 B' R2 B2 U2 R U' L U' L'"), # 13
        RootAlg.new('h962', "F U B' U R U2 B' R' F' B2 L U' L'"), # 13
        RootAlg.new('h985', "B' U' B U' B' U' R B' R' B2 L U' L'"), # 13
        RootAlg.new('h123', "L U L' U2 B2 R B R' B U2 L U' L'"), # 13
        RootAlg.new('h272', "B' U' R U R2 U R2 U2 R' B L U' L'"), # 13
        RootAlg.new('h559b', "R' L U' R2 B U B' U' R2 U2 R U' L'"), # 13
        RootAlg.new('h238c', "L B' R2 F' D2 L2 F R2 B' U2 L2 B2 L'"), # 13
        RootAlg.new('h128b', "L' U2 L U2 L F2 D2 B R' B' D2 F2 L'"), # 13
        RootAlg.new('h128', "R' F2 L F2 R F2 D2 B R' B' D2 F2 L'"), # 13
        RootAlg.new('h738b', "F2 D B' R2 B D' L2 B L B' L2 F2 L'"), # 13
        RootAlg.new('h238b', "L F' U2 F' R2 D2 B L2 B' D2 R2 F2 L'"), # 13
        RootAlg.new('h238', "L F' U2 B' D2 L2 B U2 F' D2 R2 F2 L'"), # 13
        RootAlg.new('h282', "R B' R' F R2 B R F' L F2 R F2 L'"), # 13
        RootAlg.new('h817c', "R L B L U2 L B2 R B' L2 B2 R2 L'"), # 13
        RootAlg.new('h702', "L' D' R2 D' B' R D R D L2 F' U2 L'"), # 13
        RootAlg.new('h689', "L U' B L' B' U' R B L B' R' U2 L'"), # 13
        RootAlg.new('h892c', "B' R B' D2 F2 R' L D' L' D' B2 U2 L'"), # 13
        RootAlg.new('h892b', "B' R B R' L U2 B2 D L' D' B2 U2 L'"), # 13
        RootAlg.new('h860', "L U2 B L2 B' R' U2 R B2 L' B2 U2 L'"), # 13
        RootAlg.new('h1118', "B2 L2 B R B' R' L2 B' L' B' L2 U2 L'"), # 13
        RootAlg.new('h844b', "R B2 R' B L' B L B' L' B2 L2 U2 L'"), # 13
        RootAlg.new('h456b', "L U L' U R' U2 R B2 L' B2 L2 U2 L'"), # 13
        RootAlg.new('h232', "R' U L U' R2 U' L' U R' U' L U2 L'"), # 13
        RootAlg.new('h989b', "B' R' U2 F R' F' R2 U B U' L U2 L'"), # 13
        RootAlg.new('h779', "B' R' U' R2 U B U' B2 R' B2 L U2 L'"), # 13
        RootAlg.new('h671', "L U L' U2 B' U' R' U' R B L U2 L'"), # 13
        RootAlg.new('h1051', "R' U L' U R U' L2 U2 R' U R U2 L'"), # 13
        RootAlg.new('h965', "R L B' D' R2 F R' F2 R' D R' B L'"), # 13
        RootAlg.new('h230', "L B' D2 L' U R' U2 R U' L D2 B L'"), # 13
        RootAlg.new('h356', "L D' B2 R2 D2 L D' L' D' R2 B2 D L'"), # 13
        RootAlg.new('h99', "L D' L2 B2 D' F R2 F' D B2 L2 D L'"), # 13
        RootAlg.new('h838', "B' U' R' U R B2 L2 F' L2 B' L F L'"), # 13
        RootAlg.new('h152', "R2 B2 L2 D2 B' L2 B' R2 F2 U2 L F L'"), # 13
        RootAlg.new('h530', "B' U' B2 L' B' L' U' R' U L' U' R L'"), # 13
        RootAlg.new('h754d', "B' R' U R B L2 U' R' U L' U' R L'"), # 13
        RootAlg.new('h975', "B L2 U L U' B' R' L U L2 U' R L'"), # 13
        RootAlg.new('h690', "R' L' F' U2 F L2 U2 B L2 B' U2 R L'"), # 13
        RootAlg.new('h87', "R2 L F2 U' F' U F2 R2 B U2 B' U L'"), # 13
        RootAlg.new('h332', "L U' R U2 B L' U2 L B' U2 R' U L'"), # 13
        RootAlg.new('h1079b', "L U F B U B2 D' R2 D F' B U L'"), # 13
        RootAlg.new('h781', "B L' B' L B2 R B R' B U' L U L'"), # 13
        RootAlg.new('h343', "R' L U L' U' R B' U2 B U L U L'"), # 13
        RootAlg.new('h542', "R2 D' R U2 R' D R U' L U' R U L'"), # 13
        RootAlg.new('h1040', "B' R' U' R U B R' U L U' R U L'"), # 13
        RootAlg.new('h592', "B2 L2 B2 U' R' U L U L2 U2 R U L'"), # 13
        RootAlg.new('h1170', "R2 U R' B U' L U R U' R' L' B' R'"), # 13
        RootAlg.new('h1062b', "R B' R B2 L' B' R' B L2 U2 L' B' R'"), # 13
        RootAlg.new('h490', "R B2 L' B' L2 U2 L' U' L U2 L' B' R'"), # 13
        RootAlg.new('h813', "R U B U' L U2 L' U' L U2 L' B' R'"), # 13
        RootAlg.new('h801', "R B2 L' B2 R' B L2 B' R B L' B' R'"), # 13
        RootAlg.new('h695b', "R B' R D' R D R2 B2 L U L' B' R'"), # 13
        RootAlg.new('h243b', "R2 L' D B' D' R' L B L U L' B' R'"), # 13
        RootAlg.new('h66b', "R L' B U' B' U L B L U L' B' R'"), # 13
        RootAlg.new('h418', "R U2 R2 U' R2 B' D B' D' B' U' B' R'"), # 13
        RootAlg.new('h140', "R B U2 R' U' R2 D B2 D' R' U' B' R'"), # 13
        RootAlg.new('h361', "L' B2 R2 B R2 B R L U' B U' B' R'"), # 13
        RootAlg.new('h879b', "L U' L' U2 R L U' L' U2 B U' B' R'"), # 13
        RootAlg.new('h824e', "R L' D L U' L' D' L U2 B U' B' R'"), # 13
        RootAlg.new('h879', "L U' R U R' L' U2 R U2 B U' B' R'"), # 13
        RootAlg.new('h1170b', "R2 D L' B2 L D' R2 U' R B U' B' R'"), # 13
        RootAlg.new('h449', "L U2 L' U' L U' R L' U B U' B' R'"), # 13
        RootAlg.new('h212', "B L U' L' B' R' U R2 U B U' B' R'"), # 13
        RootAlg.new('h596', "R B L U L2 U' B' U B L U' B' R'"), # 13
        RootAlg.new('h255', "R B2 L D2 R F R' D2 L B' L2 B' R'"), # 13
        RootAlg.new('h365', "R B L2 U2 L2 B L' B' L' U2 L2 B' R'"), # 13
        RootAlg.new('h756', "F R' F' R U2 R U2 B2 L' B' L B' R'"), # 13
        RootAlg.new('h417b', "L' U' B' U B R L B2 L' B' L B' R'"), # 13
        RootAlg.new('h321', "B L U L' U' B' R B2 L' B' L B' R'"), # 13
        RootAlg.new('h127b', "R B2 L2 D2 F' D' F D' L B' L B' R'"), # 13
        RootAlg.new('h1079c', "R2 B' D2 F L' F' D2 L' B2 R' L B' R'"), # 13
        RootAlg.new('h974', "R2 B2 L' B' L B L' B R' B2 L B' R'"), # 13
        RootAlg.new('h941', "R U B U2 L' U' L2 U' L2 U2 L B' R'"), # 13
        RootAlg.new('h1009b', "B L F U' F' U L2 B' R B L B' R'"), # 13
        RootAlg.new('h881b', "B' R B R' U2 B2 L' B2 R B L B' R'"), # 13
        RootAlg.new('h65b', "R B2 U R B2 R' B' U' R' U2 R B' R'"), # 13
        RootAlg.new('h667b', "R B U B' U' B U' B' U' B U B' R'"), # 13
        RootAlg.new('h890', "B U2 B' U' R' U R2 D L' B' L D' R'"), # 13
        RootAlg.new('h804', "B U B' R D B' U' B' U B U D' R'"), # 13
        RootAlg.new('h59b', "R2 D L' D' R2 U R U' D L U D' R'"), # 13
        RootAlg.new('h885b', "R2 B' R' B2 L F U2 F' L' U' B' U' R'"), # 13
        RootAlg.new('h45', "R B R' U L U' R U' L' U2 B' U' R'"), # 13
        RootAlg.new('h631', "R B L U2 L' U' L U L' U2 B' U' R'"), # 13
        RootAlg.new('h892', "R B2 L' B' L U' B' U' B U2 B' U' R'"), # 13
        RootAlg.new('h1210c', "R2 B2 L' B2 R' B L2 U2 L' U B' U' R'"), # 13
        RootAlg.new('h953', "R B L U2 L' U' L U2 L' U B' U' R'"), # 13
        RootAlg.new('h447', "F' U2 F U R B L U L' U B' U' R'"), # 13
        RootAlg.new('h1037', "B' R U2 R' B R B' U2 B2 U B' U' R'"), # 13
        RootAlg.new('h831', "R U2 B' D' B U2 B' D B2 U B' U' R'"), # 13
        RootAlg.new('h695', "B2 U' R U2 B' R' B' R B U' B2 U' R'"), # 13
        RootAlg.new('h123b', "R U R' U2 R U2 B L' B L B2 U' R'"), # 13
        RootAlg.new('h262b', "F' L' B' U B L F R2 B' R' B U' R'"), # 13
        RootAlg.new('h1042', "R U' R' U2 R2 U B U' B2 R' B U' R'"), # 13
        RootAlg.new('h436', "B L U L' U' B' R U2 R' U' R U' R'"), # 13
        RootAlg.new('h81', "R2 U R U R2 U' R' U' R2 U' R U' R'"), # 13
        RootAlg.new('h421', "B2 U' B2 U' B2 U R U R' B2 R U' R'"), # 13
        RootAlg.new('h501', "B' U' R' U R2 B U B' R' B R U' R'"), # 13
        RootAlg.new('h577b', "B' R' U' R B' R B U R' B R U' R'"), # 13
        RootAlg.new('h457', "R B2 U D B2 D' B' D B' U' D' B2 R'"), # 13
        RootAlg.new('h150', "B U L' B L2 B2 U' B' R B' L' B2 R'"), # 13
        RootAlg.new('h716', "R U B2 L' B' U' B U L2 U' L' B2 R'"), # 13
        RootAlg.new('h765', "R D B2 D' B' D B' U D' B U' B2 R'"), # 13
        RootAlg.new('h965c', "R' F2 U' F U' R2 B' D2 B' L2 D2 B2 R'"), # 13
        RootAlg.new('h456d', "L U L' U L' B2 R D2 L' D2 L2 B2 R'"), # 13
        RootAlg.new('h994b', "R B2 L' D L' D R F' R' D2 L2 B2 R'"), # 13
        RootAlg.new('h452b', "R B2 R2 U2 B2 R B R' B U2 R2 B2 R'"), # 13
        RootAlg.new('h881', "R' U R B' R B' R2 B' U' B R2 B2 R'"), # 13
        RootAlg.new('h109', "R U D' B R2 B R2 B' R2 U' D B2 R'"), # 13
        RootAlg.new('h124', "R' U' R U' R' U2 R2 B L' B L B2 R'"), # 13
        RootAlg.new('h1204', "R U B U2 B' U' B U L' B L B2 R'"), # 13
        RootAlg.new('h352b', "R L' B R' B' R L B2 R' B' R B2 R'"), # 13
        RootAlg.new('h352', "R L' B L B2 R' L' B L B' R B2 R'"), # 13
        RootAlg.new('h249', "R L' B R' L2 U2 L2 B L B' R B2 R'"), # 13
        RootAlg.new('h397', "R B2 U' B U' B U' B' U2 B' U B2 R'"), # 13
        RootAlg.new('h238d', "R D' R2 U' F2 L2 U R2 D' B2 L2 D2 R'"), # 13
        RootAlg.new('h1203', "B2 D2 F2 L D2 B' U2 R2 B' D2 F D2 R'"), # 13
        RootAlg.new('h369', "R F2 R L2 D R' D' B' D B L2 F2 R'"), # 13
        RootAlg.new('h1099c', "B' R' U R2 U2 R' B L U' R L' U2 R'"), # 13
        RootAlg.new('h1099d', "R2 B2 R' B2 U' R' U2 L U R L' U2 R'"), # 13
        RootAlg.new('h586', "R2 D L2 B' L B' L' B2 L2 D' R' U2 R'"), # 13
        RootAlg.new('h1051c', "R D L2 D' R D L B2 L D' R' U2 R'"), # 13
        RootAlg.new('h1193', "R U B' R B D R' U R D' R' U2 R'"), # 13
        RootAlg.new('h238e', "R U' B2 U' R2 F2 D L2 D' F2 R2 U2 R'"), # 13
        RootAlg.new('h238f', "R U' B2 D' F2 L2 D B2 U' F2 R2 U2 R'"), # 13
        RootAlg.new('h459', "R U2 R' U2 R' U2 B' R B U2 R2 U2 R'"), # 13
        RootAlg.new('h107', "R' U2 R2 U2 R U2 R' U2 R U2 R2 U2 R'"), # 13
        RootAlg.new('h476b', "R' U2 R2 B' R' B R U R2 U R2 U2 R'"), # 13
        RootAlg.new('h425', "R B U2 B2 L2 U' R' U R L2 B U2 R'"), # 13
        RootAlg.new('h939', "B' U R U' R' U2 B R B' U B U2 R'"), # 13
        RootAlg.new('h13', "R U2 B' U' B2 R B' R' B2 U B U2 R'"), # 13
        RootAlg.new('h26', "R U2 B' U' B2 R B2 R' B2 U B U2 R'"), # 13
        RootAlg.new('h917', "R L U2 L' B U' L U' L2 B' L U2 R'"), # 13
        RootAlg.new('h70', "R B U B' U L' U R' U' R L U2 R'"), # 13
        RootAlg.new('h1099b', "R2 B' R' U' R' U R B R' U2 R U2 R'"), # 13
        RootAlg.new('h578', "R U R' B' U' R' U R B U2 R U2 R'"), # 13
        RootAlg.new('h905', "L' U B' R U R' B U' L U2 R U2 R'"), # 13
        RootAlg.new('h934', "R B' U' B2 U' B2 U2 B R' U R U2 R'"), # 13
        RootAlg.new('h466', "B' R' U' R U B R U R' U R U2 R'"), # 13
        RootAlg.new('h37', "B2 U' R2 B R' B' R' U B2 U R U2 R'"), # 13
        RootAlg.new('h384', "R2 L' D B' D' R2 L U' R2 B' R' B R'"), # 13
        RootAlg.new('h648', "R' U2 R B' R2 B2 R U2 R' B2 R' B R'"), # 13
        RootAlg.new('h3', "F' B L' U B' L U' F B' R U' B R'"), # 13
        RootAlg.new('h1044', "R U B' U' R2 D2 R U R' D2 R2 B R'"), # 13
        RootAlg.new('h318', "R B' U2 R B D B' D' R' B' U2 B R'"), # 13
        RootAlg.new('h500', "B' R U2 R D' R' D2 B' D' B U2 B R'"), # 13
        RootAlg.new('h639', "R U R' U' R B' U2 L' B' L U2 B R'"), # 13
        RootAlg.new('h1063', "R U2 R' U2 R B' U2 L' B' L U2 B R'"), # 13
        RootAlg.new('h547', "R' U' R B L U2 L' B' U' B' R B R'"), # 13
        RootAlg.new('h1146', "B' R' U' R U B2 U B' U' B' R B R'"), # 13
        RootAlg.new('h605', "B' R' U' R U B2 U2 B' U2 B' R B R'"), # 13
        RootAlg.new('h849b', "R L' B R' L U2 L' B L B' R B R'"), # 13
        RootAlg.new('h1124', "B U2 B2 R B R2 U R U B' R B R'"), # 13
        RootAlg.new('h878', "B U B' U2 R' U R B U' B2 R B R'"), # 13
        RootAlg.new('h792', "B' U' B U' B U B' U' B' U2 R B R'"), # 13
        RootAlg.new('h758', "B' U' B U B U2 B' U2 B' U2 R B R'"), # 13
        RootAlg.new('h508', "R U B U' B' U B' U' R' U R B R'"), # 13
        RootAlg.new('h546b', "B U2 B2 U' B' U' B2 U B U R B R'"), # 13
        RootAlg.new('h799c', "R' U2 R2 B D' R2 U2 D R2 B2 U B R'"), # 13
        RootAlg.new('h315', "L2 U' L U' L U L U2 R D' B2 D R'"), # 13
        RootAlg.new('h450b', "R D' R2 B' R' U' R U B U' R2 D R'"), # 13
        RootAlg.new('h148b', "R F' L2 D2 F' D B D' F D2 L2 F R'"), # 13
        RootAlg.new('h148', "R' F' L F R2 F' L D' B D L2 F R'"), # 13
        RootAlg.new('h201c', "R2 U R' F' B U B' L' U2 L U F R'"), # 13
        RootAlg.new('h521', "R B2 U2 B' U2 B' U' R B R' B' U R'"), # 13
        RootAlg.new('h531', "R F' U2 B2 D L2 D' B' U' F B' U R'"), # 13
        RootAlg.new('h704', "R U' L2 D' B D L2 U F U2 F' U R'"), # 13
        RootAlg.new('h279', "R U' L D2 B L' U2 L B' D2 L' U R'"), # 13
        RootAlg.new('h799', "R L U2 L' B U2 B' U' L U L' U R'"), # 13
        RootAlg.new('h1210', "R2 U2 R2 B' U' R U B R2 U2 R' U R'"), # 13
        RootAlg.new('h450c', "R U' B2 L' B' U' B U L U' B2 U R'"), # 13
        RootAlg.new('h1097', "B' R B U' B2 D2 F' L' F D2 B2 U R'"), # 13
        RootAlg.new('h391', "R U' R2 U' D' R U' R' U2 D R2 U R'"), # 13
        RootAlg.new('h869', "R U B' U2 B' U B' U' B U2 B U R'"), # 13
        RootAlg.new('h1175', "R' L' D2 L' F' D' L D' R2 B' L U R'"), # 13
        RootAlg.new('h510', "B U L' U' L B' L' U2 R U' L U R'"), # 13
        RootAlg.new('h1143', "B' U' R' U R B L' U R U' L U R'"), # 13
        RootAlg.new('h59', "F' L' B' L F L' B U R U' L U R'"), # 13
        RootAlg.new('h229', "L' U R B2 U' B' U2 B' U' B2 L U R'"), # 13
        RootAlg.new('h962b', "R2 L2 D B' D' L B' R' U2 B L U R'"), # 13
        RootAlg.new('h792b', "L' U' B' U B R U' B' U B L U R'"), # 13
        RootAlg.new('h417d', "B2 D L' F B' R' F R F2 B L D' B2"), # 13
        RootAlg.new('h4b', "B2 R' L U2 R2 L2 B' R2 L2 U2 R L' B2"), # 13
        RootAlg.new('h4c', "R2 L2 B2 R' L U2 B' R2 L2 U2 R L' B2"), # 13
        RootAlg.new('h842', "R L U' L' U R' B' R' U2 R2 B' R' B2"), # 13
        RootAlg.new('h3e', "B2 R U' D B L2 U2 L2 B' U D' R' B2"), # 13
        RootAlg.new('h3d', "B2 R F B' D F2 L2 F2 D' F' B R' B2"), # 13
        RootAlg.new('h526', "R U' R' B2 R' B2 U B2 U' R2 U R' B2"), # 13
        RootAlg.new('h1051b', "B2 R2 U L U' R2 U' R L' B2 R' U' B2"), # 13
        RootAlg.new('h598', "R2 D' R2 D L' B2 D B2 D' L B2 U' B2"), # 13
        RootAlg.new('h417e', "B2 U B' R' L F' L F R L2 B U' B2"), # 13
        RootAlg.new('h909', "B R U' L U L' B' R' B U B U' B2"), # 13
        RootAlg.new('h817', "B R B R' U2 L' U' B U B L U' B2"), # 13
        RootAlg.new('h668', "B R B R' L' B L U R' U' R U' B2"), # 13
        RootAlg.new('h509', "B D F' L D2 B R' D' F' R' F2 D2 B2"), # 13
        RootAlg.new('h521b', "B2 R D' B' D B R' D' R2 D' R2 D2 B2"), # 13
        RootAlg.new('h1131', "B L2 F' L' B D2 F' D2 R' D2 R F2 B2"), # 13
        RootAlg.new('h205b', "R' L U L2 U2 R U L2 U2 L B2 L2 B2"), # 13
        RootAlg.new('h193', "B' R B' L2 B2 R' U' R' U R B2 L2 B2"), # 13
        RootAlg.new('h611', "B' R U R B U2 B' U' R' U' B' R2 B2"), # 13
        RootAlg.new('h859', "B' R2 B U' B2 R2 B2 U' B' U2 B' R2 B2"), # 13
        RootAlg.new('h945', "B2 R2 B2 R' U' R' U R B' R B' R2 B2"), # 13
        RootAlg.new('h817b', "B2 R2 B R' D B U B' D' R B' R2 B2"), # 13
        RootAlg.new('h690b', "F B2 D2 F B' L' F' D2 B R' F' R2 B2"), # 13
        RootAlg.new('h190b', "R B2 D2 F L F' D2 R2 F R' F' R2 B2"), # 13
        RootAlg.new('h685b', "F' B L2 F' D B' L2 F U' F B2 R2 B2"), # 13
        RootAlg.new('h649', "B2 R' B2 U B2 D' R' U' D R' U R2 B2"), # 13
        RootAlg.new('h293b', "B2 R2 U2 R2 U R2 B2 U2 B2 U R2 U2 B2"), # 13
        RootAlg.new('h924', "B' R' U2 R B' U2 B' U B' U' B U2 B2"), # 13
        RootAlg.new('h611b', "B' U2 B L' B L B D' F R2 F' D B2"), # 13
        RootAlg.new('h735', "B2 R' B2 U' B2 R2 U' R' U D' R' D B2"), # 13
        RootAlg.new('h159', "B U2 B D' R2 D B' U2 B D' R2 D B2"), # 13
        RootAlg.new('h148c', "R' U' R B2 L' U2 B D' B' U2 D L B2"), # 13
        RootAlg.new('h658b', "B' U' D L' B' L U' D' R' U2 B' R B2"), # 13
        RootAlg.new('h3b', "B2 R' F B' D' F2 L2 F2 D F' B R B2"), # 13
        RootAlg.new('h1096', "L' B R' L2 U2 L' U' B' U' B U R B2"), # 13
        RootAlg.new('h1167', "B' U B' U' R B2 R' B L U2 L' U B2"), # 13
        RootAlg.new('h406', "B2 U' B U B U' B' U' R B' R' U B2"), # 13
        RootAlg.new('h178', "B2 U' B R B' R' B2 L U2 L' B2 U B2"), # 13
        RootAlg.new('h118b', "R2 B2 U' F B R' F B' D L2 B2 D' F2"), # 13
        RootAlg.new('h118c', "R2 B2 D' R L F' R' L D B2 R2 U' F2"), # 13
        RootAlg.new('h628', "F L F L2 B' R' U R B U' L U' F2"), # 13
        RootAlg.new('h818', "F2 L2 F U' R B L B' R' U F' L2 F2"), # 13
        RootAlg.new('h825', "F' L' B L' B' L' F' R2 F L' F' R2 F2"), # 13
        RootAlg.new('h40', "F R' F R' B2 D2 F L F' D2 B2 R2 F2"), # 13
        RootAlg.new('h965b', "F R' F R' B2 D L' D L D2 B2 R2 F2"), # 13
        RootAlg.new('h930', "R U2 R' U' F' U' F' D' B L' B' D F2"), # 13
        RootAlg.new('h611c', "F' B' U2 R' U2 R U2 F' B D' L2 D F2"), # 13
        RootAlg.new('h782', "F2 R2 D2 L B' L' D2 R2 F' R' F R F2"), # 13
        RootAlg.new('h836', "L' B U2 R B R' U2 B2 U2 B2 L' B' L2"), # 13
        RootAlg.new('h1163b', "L' B' R B R' B U2 R L' B' R' B' L2"), # 13
        RootAlg.new('h939b', "L U2 L D' R' L B2 R' D2 R2 L' D' L2"), # 13
        RootAlg.new('h1117d', "R L' D' B2 D2 L2 U' L' U L2 D' R' L2"), # 13
        RootAlg.new('h1117e', "R L' U B2 U2 L2 D L' U L2 D' R' L2"), # 13
        RootAlg.new('h369b', "L2 B2 L2 U' L2 B2 R D' B' D B R' L2"), # 13
        RootAlg.new('h1103', "R L2 B R' B2 L B' R B R' L' B2 L2"), # 13
        RootAlg.new('h538', "B L' B' L' B2 R2 D L D' R2 L' B2 L2"), # 13
        RootAlg.new('h258b', "R L' B' R2 U2 R B' U' B U L' B2 L2"), # 13
        RootAlg.new('h966', "L2 B2 R2 B' L B R' B2 L' B2 R' B2 L2"), # 13
        RootAlg.new('h1006', "L' B2 R B R2 U2 R2 B L' B2 R' B2 L2"), # 13
        RootAlg.new('h714', "L' U' B' U2 R' U R2 B2 L' B R' B2 L2"), # 13
        RootAlg.new('h686', "R' L' B' U2 B R L' B2 U' B2 U B2 L2"), # 13
        RootAlg.new('h379b', "R2 B2 L F2 L2 D' R' D R' B2 L' F2 L2"), # 13
        RootAlg.new('h517', "R L' B' L U2 L' B2 L' B R B' R2 L2"), # 13
        RootAlg.new('h4', "R2 L2 F2 R L' U2 F' U2 R' L F2 R2 L2"), # 13
        RootAlg.new('h3c', "L2 B' U D' R' B2 U2 B2 R U' D B L2"), # 13
        RootAlg.new('h939c', "L U2 L D R2 L D2 R B2 R L' D L2"), # 13
        RootAlg.new('h1163c', "L' U' B' U2 B U' L' D' R B' R' D L2"), # 13
        RootAlg.new('h763', "L U2 L2 U' L2 U' L D' R B2 R' D L2"), # 13
        RootAlg.new('h1057', "L' B' U' B U D' R2 D L' D' R2 D L2"), # 13
        RootAlg.new('h606', "L' B' R B' R' B L' U' L B L' U L2"), # 13
        RootAlg.new('h943', "R B' L U2 L' B U2 B' U2 B' R B' R2"), # 13
        RootAlg.new('h824d', "R U B U' B' D L2 D' R D L2 D' R2"), # 13
        RootAlg.new('h1075b', "R U2 R' U' R U R D L' B2 L D' R2"), # 13
        RootAlg.new('h1205', "R' U2 R2 U R2 U R' D R' U2 R D' R2"), # 13
        RootAlg.new('h1179', "R D L' B' R' L U B' R B R D' R2"), # 13
        RootAlg.new('h751b', "R F2 B2 D' F L F2 D B2 R F' U' R2"), # 13
        RootAlg.new('h258', "R2 U R' U' B U B' U R' U' R2 U' R2"), # 13
        RootAlg.new('h875', "R2 U R2 B' U' R2 U R2 B U R2 U' R2"), # 13
        RootAlg.new('h1075c', "R2 L' U R U' D B2 D' L U R U' R2"), # 13
        RootAlg.new('h1148', "R2 B2 D B' R' F' L F R B D' B2 R2"), # 13
        RootAlg.new('h978b', "R U L' B' L2 F U F' U R L' B2 R2"), # 13
        RootAlg.new('h1148b', "R2 B2 U R' F' L' B L F R U' B2 R2"), # 13
        RootAlg.new('h592b', "L2 F2 B2 R D L D' R D L F2 B2 R2"), # 13
        RootAlg.new('h302', "R2 B2 R' B D' R' U2 R D B' R B2 R2"), # 13
        RootAlg.new('h431', "R2 B2 R' L' B' L B U B' U' R B2 R2"), # 13
        RootAlg.new('h431b', "R L U2 L2 B L B U B' U' R B2 R2"), # 13
        RootAlg.new('h299', "R2 B2 R2 B' U' B R U B U' R B2 R2"), # 13
        RootAlg.new('h379c', "R2 F2 R' B2 L' D L' D' L2 B2 R F2 R2"), # 13
        RootAlg.new('h340', "R' L2 B R B' R' L B' L U2 R' U2 R2"), # 13
        RootAlg.new('h450', "R2 B' D R' U' R U B U' B' D' B R2"), # 13
        RootAlg.new('h864', "R L U' D2 R' U R D2 L' B' R B R2"), # 13
        RootAlg.new('h716b', "R B U B U2 B2 R2 D' R U' R2 D R2"), # 13
        RootAlg.new('h65', "R2 U B' U' R U R2 B R U' R' U R2"), # 13
        RootAlg.new('h298', "B' D R' B2 U R U2 R' U' B2 R D' B"), # 13
        RootAlg.new('h444b', "F B2 D2 F L' F' D2 B2 R' B' R F' B"), # 13
        RootAlg.new('h1195', "B' L F2 B' R F' R' F B R' F2 L' B"), # 13
        RootAlg.new('h60', "B R' U2 R U B2 U B2 U L U2 L' B"), # 13
        RootAlg.new('h1075e', "B R B2 D B2 D' R2 U L U2 R L' B"), # 13
        RootAlg.new('h591', "B U2 B' R2 U2 B' R B U2 R' B' R' B"), # 13
        RootAlg.new('h563', "R U B' R B R2 B' R B U' B' R' B"), # 13
        RootAlg.new('h880', "L U L2 B L B2 R U B U' B' R' B"), # 13
        RootAlg.new('h760', "L' B2 L2 U' R' U R2 L2 B2 L B' R' B"), # 13
        RootAlg.new('h1139', "B' U' R2 U R2 B R U' R' U B' R' B"), # 13
        RootAlg.new('h1009', "B' U' B' R B2 U' B' U2 B U B' R' B"), # 13
        RootAlg.new('h1050', "R' F' R B' R D2 B' L2 D' B D' R' B"), # 13
        RootAlg.new('h637', "R U2 R' U' B' R2 U R U' R' U' R' B"), # 13
        RootAlg.new('h472', "B' R B2 R U2 B' U' B U' R' B2 R' B"), # 13
        RootAlg.new('h78', "B R L2 D2 R D' F D' R' L2 B2 R' B"), # 13
        RootAlg.new('h849', "B L' B L B R B' L' B' L B2 R' B"), # 13
        RootAlg.new('h579', "B' U' R U B' U R2 U' R2 U' B R' B"), # 13
        RootAlg.new('h39', "R B2 L2 D L B D2 B' D L B R' B"), # 13
        RootAlg.new('h1193b', "B U L U' L2 B' L U2 B2 R B R' B"), # 13
        RootAlg.new('h1202', "B2 R2 B U R2 B U' B2 R' B U R' B"), # 13
        RootAlg.new('h823', "R U R' U2 B2 R' D' R2 D B R' U' B"), # 13
        RootAlg.new('h319', "B2 R B L' D B D' R2 L U' R U' B"), # 13
        RootAlg.new('h974c', "L F L' B L F' B2 D2 F2 R F2 D2 B"), # 13
        RootAlg.new('h103b', "B' D' R2 U' D L B2 L' D2 R U D2 B"), # 13
        RootAlg.new('h1139b', "B' U' R2 U R' U' D R' U R D' R2 B"), # 13
        RootAlg.new('h201b', "L U L2 B L B2 U R' F R' F' R2 B"), # 13
        RootAlg.new('h630', "B' R2 U' R U' R2 B' R' B R2 U2 R2 B"), # 13
        RootAlg.new('h1071', "B' R2 U' R U' R2 U R U' R U2 R2 B"), # 13
        RootAlg.new('h407', "B' R2 U' D' F' U F L F L' D R2 B"), # 13
        RootAlg.new('h546', "B' R' B U B' R' U' B' R2 B U R2 B"), # 13
        RootAlg.new('h507', "B' U2 R U B' R' B2 R U' R' B' U2 B"), # 13
        RootAlg.new('h210', "R B U B' U2 B' U B U R' B' U2 B"), # 13
        RootAlg.new('h1075', "L' U R U' L B' U B U R' B' U2 B"), # 13
        RootAlg.new('h552', "B' U2 R U B' U' R' U B2 U' B' U2 B"), # 13
        RootAlg.new('h1197', "R U2 R' U' B' R U' R' B U' B' U2 B"), # 13
        RootAlg.new('h443b', "L U L' B' R' U' R U' B U' B' U2 B"), # 13
        RootAlg.new('h635', "L U L' B2 R B R' U2 B U' B' U2 B"), # 13
        RootAlg.new('h1036b', "R L2 D' B' D B L2 B' R' U2 B' U2 B"), # 13
        RootAlg.new('h1195c', "L' D' R B R' L U L' D L B' U2 B"), # 13
        RootAlg.new('h827c', "B' R' U2 R U' R' L U' R U L' U2 B"), # 13
        RootAlg.new('h104d', "B' R' B2 D2 F2 L' U' F2 U D2 B2 U2 B"), # 13
        RootAlg.new('h104c', "B' L' D2 F2 U2 R' U' F2 U D2 B2 U2 B"), # 13
        RootAlg.new('h250', "R' U2 B L' B' L U2 R B U2 B2 U2 B"), # 13
        RootAlg.new('h1121', "B' U2 L' U B R B' R' U' B' L U2 B"), # 13
        RootAlg.new('h1121b', "B' U2 L' B' R B D B' D' R' L U2 B"), # 13
        RootAlg.new('h336', "B' R B U B' U2 L' U R' U' L U2 B"), # 13
        RootAlg.new('h458', "B2 R B2 R' B U B2 U L' B L U2 B"), # 13
        RootAlg.new('h450d', "B' U2 R' L' U' L U' L' U2 R L U2 B"), # 13
        RootAlg.new('h637b', "F' B2 D L' D' F B D' F R F' D B"), # 13
        RootAlg.new('h110', "B2 D' B R B2 U B' R' U' B' R' D B"), # 13
        RootAlg.new('h110b', "B2 D' R D B' U B2 D' R' U' R' D B"), # 13
        RootAlg.new('h54', "B' R2 L' U2 R' D B D' R U2 R2 L B"), # 13
        RootAlg.new('h429', "B2 U2 B' U2 B U2 R L' B R' B L B"), # 13
        RootAlg.new('h262', "B' R2 U' B' R' B U R B U2 B' R B"), # 13
        RootAlg.new('h112b', "L2 B2 R B2 L B' R2 U2 B L B' R B"), # 13
        RootAlg.new('h460', "F' L F R' F2 L' F' R B' R' F' R B"), # 13
        RootAlg.new('h911', "L U L2 B' L U L U' R' L' U' R B"), # 13
        RootAlg.new('h1169', "L2 D L' U2 L D' L2 U' B' R' U' R B"), # 13
        RootAlg.new('h577', "B' R' U' R U R' U R U' R' U' R B"), # 13
        RootAlg.new('h1146b', "B' R' U' R U2 R B' R' B R' U' R B"), # 13
        RootAlg.new('h978', "B' R B U B' R2 U R2 U2 R2 U' R B"), # 13
        RootAlg.new('h543', "B' U' B U B' U B U2 B' R' U2 R B"), # 13
        RootAlg.new('h776', "B2 D' R' D B' D B D2 R D B R B"), # 13
        RootAlg.new('h417', "L U2 L' U' L U' L' B' U' R' U R B"), # 13
        RootAlg.new('h402', "R' F2 L F L' F R B' U' R' U R B"), # 13
        RootAlg.new('h747', "B' R B2 R' B2 L U2 L' U R' U R B"), # 13
        RootAlg.new('h638', "F2 R2 B L' D' L B' R2 F2 U2 B' U B"), # 13
        RootAlg.new('h1062', "B' R' U R2 B R' U2 R' U2 R B' U B"), # 13
        RootAlg.new('h821', "R' B' U' R2 U R2 U' R2 B R B' U B"), # 13
        RootAlg.new('h368', "R U B U' B' R' B' U2 B U B' U B"), # 13
        RootAlg.new('h1064', "L' B2 R B2 L B' R' U2 B U B' U B"), # 13
        RootAlg.new('h958', "B' U' R2 U2 R' B R U2 R' B' R' U B"), # 13
        RootAlg.new('h510b', "R2 D R' U R D' R2 B' R U' R' U B"), # 13
        RootAlg.new('h303d', "R L' D' B' D R' L B2 R B R' U B"), # 13
        RootAlg.new('h952b', "B' U2 B2 U L U' L' B R B R' U B"), # 13
        RootAlg.new('h482', "B U B2 R' U' R B2 L U' L' B2 U B"), # 13
        RootAlg.new('h6b', "B' R2 U2 L U' R U R' L' U2 R2 U B"), # 13
        RootAlg.new('h525', "L U' L' B' R2 U2 B' R' B U2 R2 U B"), # 13
        RootAlg.new('h754', "R U R' U2 B' R' U' R' B' R2 B U B"), # 13
        RootAlg.new('h851', "B2 R2 B2 U B' R2 B U' B2 R2 B U B"), # 13
        RootAlg.new('h1116', "B U' B' R B' R2 U R L' B2 L U B"), # 13
        RootAlg.new('h310', "L U2 L' U' L U' L' B' R' U' R U B"), # 13
        RootAlg.new('h474', "R' U2 R U R' U R B' R' U' R U B"), # 13
        RootAlg.new('h1103b', "B D F' L F D' B2 U' R' U2 R U B"), # 13
        RootAlg.new('h725b', "F' B U' D2 R F R' U D2 L' B' L' F"), # 13
        RootAlg.new('h430', "R' F2 R' L B R F2 R' B' R2 F' L' F"), # 13
        RootAlg.new('h727', "F2 L F' B2 D2 B R' B' D2 F2 B2 L' F"), # 13
        RootAlg.new('h160', "R D2 L' U2 B' L D2 R' F' L F2 L' F"), # 13
        RootAlg.new('h774b', "F' U F2 L2 D B' R B D' L2 F2 U' F"), # 13
        RootAlg.new('h1009c', "R B' U' B R' U F' B L' B' L U' F"), # 13
        RootAlg.new('h902b', "L2 F2 B2 R D2 R' F2 L' F' L B2 L2 F"), # 13
        RootAlg.new('h653', "F' R U2 L' U' B U' B' L U2 R' U2 F"), # 13
        RootAlg.new('h79', "F2 D B' R' B D' F D' B L B' D F"), # 13
        RootAlg.new('h824b', "R U B U' B' R2 F' L' F R F' L F"), # 13
        RootAlg.new('h654b', "R' F2 L F' R F2 L2 U2 B' U2 B L F"), # 13
        RootAlg.new('h974d', "F B' D2 B2 L B2 D2 R B R' F2 R F"), # 13
        RootAlg.new('h453', "L' B' R B' R' B2 L F' L' U' L U F"), # 13
        RootAlg.new('h1103c', "F D B' R2 B D' F2 U' L' U L U F"), # 13
        RootAlg.new('h584', "R U2 R' F2 L F L B L2 F L' B' L"), # 13
        RootAlg.new('h54b', "L' B R2 F B2 U R U' F' B2 R2 B' L"), # 13
        RootAlg.new('h485', "L' U' B2 U B' R' U' R U' B' U2 B' L"), # 13
        RootAlg.new('h885', "L2 B R2 F D B D' F' B' R2 L B' L"), # 13
        RootAlg.new('h1172', "L2 D' R B R' D L2 U L2 B L B' L"), # 13
        RootAlg.new('h322', "L F U R' F R' U' L2 D B2 R2 D' L"), # 13
        RootAlg.new('h263', "R2 L' D B D' R' B L U2 L' B' R' L"), # 13
        RootAlg.new('h1132', "B' R' U' R U' B U2 R B L' B' R' L"), # 13
        RootAlg.new('h1034', "B U B' U' L' B' L U2 R L' B' R' L"), # 13
        RootAlg.new('h947', "R' L' U2 L U L' U R2 D B2 D' R' L"), # 13
        RootAlg.new('h804b', "R U R' F U F' R L' B' U' B R' L"), # 13
        RootAlg.new('h489', "R2 L' B' L B2 R' B L U2 L2 B R' L"), # 13
        RootAlg.new('h834b', "B' U2 B U L U' R L2 D' B D R' L"), # 13
        RootAlg.new('h664', "R B U2 L' U2 L U2 B' U' L' U R' L"), # 13
        RootAlg.new('h1181b', "R U' B2 U' L' U2 L U B2 L' U R' L"), # 13
        RootAlg.new('h367', "R2 L' D' R D R U R U2 B2 U R' L"), # 13
        RootAlg.new('h820', "L U2 R L2 B' U' L B' L' B U R' L"), # 13
        RootAlg.new('h1040b', "L' U2 R2 B D B2 D' R' U2 B U R' L"), # 13
        RootAlg.new('h973b', "R L' U' B2 U2 B2 U2 B' U' B' R' U' L"), # 13
        RootAlg.new('h587', "R L' U B2 D' B U' B' D B2 R' U' L"), # 13
        RootAlg.new('h529', "R L' U' B2 U2 B U B U B2 R' U' L"), # 13
        RootAlg.new('h492', "R' U L' U R2 B' R2 U2 R2 B R' U' L"), # 13
        RootAlg.new('h873', "B L' B' R B2 L B2 U' L' U R' U' L"), # 13
        RootAlg.new('h1084', "B L U L' U' B' R U' L' U R' U' L"), # 13
        RootAlg.new('h1001', "B' U' R' U R B R U' L' U R' U' L"), # 13
        RootAlg.new('h406b', "R L' U' B U B R B2 R' U R' U' L"), # 13
        RootAlg.new('h322b', "L F U R' F R' D' B2 D R2 F2 U' L"), # 13
        RootAlg.new('h680', "L' U2 R2 B' D L' B L D' B R2 U' L"), # 13
        RootAlg.new('h1111', "L2 B2 L B2 L U' L' U R' U R U' L"), # 13
        RootAlg.new('h999', "R B' R' U2 B' U2 R B R' U2 L' B2 L"), # 13
        RootAlg.new('h134', "F U F' U L' B' R' U2 R2 B' R' B2 L"), # 13
        RootAlg.new('h452c', "L' B' R' U2 R U2 R' U2 R2 B' R' B2 L"), # 13
        RootAlg.new('h324', "B L U L' U' B' L' B' R B' R' B2 L"), # 13
        RootAlg.new('h102', "L U2 L' U' L U' L2 B' R B' R' B2 L"), # 13
        RootAlg.new('h201', "B L2 D L D2 B D B R B' R' B2 L"), # 13
        RootAlg.new('h162', "L' B' U' B U B2 R2 D' R' D R' B2 L"), # 13
        RootAlg.new('h461', "L' B' R B' R' L2 U' R' U R L2 B2 L"), # 13
        RootAlg.new('h994', "R B2 L' D L' D R F' L D2 R2 B2 L"), # 13
        RootAlg.new('h456c', "L U L' U L' B2 R D2 R D2 R2 B2 L"), # 13
        RootAlg.new('h165', "L2 B2 R B R' B' R2 B' L B R2 B2 L"), # 13
        RootAlg.new('h205', "L' B2 R D' R D R' D' R D R2 B2 L"), # 13
        RootAlg.new('h498', "L' U' B2 D' F R2 F' B U' B' D B2 L"), # 13
        RootAlg.new('h356b', "L2 D L B2 R D' R' B2 D2 B2 D B2 L"), # 13
        RootAlg.new('h778', "B' R B2 L' B R' D2 R2 D R2 D B2 L"), # 13
        RootAlg.new('h911b', "L' D2 R' B R2 B R2 B2 R2 B R' D2 L"), # 13
        RootAlg.new('h1189', "L' B2 D' R' D B2 D2 R U R' U' D2 L"), # 13
        RootAlg.new('h147b', "L' D2 R2 D2 B2 D' B' D B' D2 R2 D2 L"), # 13
        RootAlg.new('h1023', "L' U R2 D B' D' B R2 U' R2 B' R2 L"), # 13
        RootAlg.new('h834', "F' U2 F U R U R L' D B D' R2 L"), # 13
        RootAlg.new('h147', "R2 L' D2 R2 B2 D' B' D B' R2 D2 R2 L"), # 13
        RootAlg.new('h1079', "R2 B2 R2 L' B L B' R2 B2 L' B R2 L"), # 13
        RootAlg.new('h1036', "F2 D B' R' B D' F' U F' U' L' U2 L"), # 13
        RootAlg.new('h868b', "B' L F2 D2 R D2 F2 L' B U2 L' U2 L"), # 13
        RootAlg.new('h868', "B' R U2 F2 R F2 U2 R' B U2 L' U2 L"), # 13
        RootAlg.new('h507b', "R L' U' L U2 B U' B' R' U L' U2 L"), # 13
        RootAlg.new('h899', "R L' U' L2 U2 R' U R U2 R' L2 U2 L"), # 13
        RootAlg.new('h817e', "F R U2 B' R B R2 F2 L F L2 U2 L"), # 13
        RootAlg.new('h380b', "R L' B' R' U2 R2 L' B' L B R2 U2 L"), # 13
        RootAlg.new('h380', "R L' B R' U2 R2 B' L' B R2 L U2 L"), # 13
        RootAlg.new('h118', "B' R2 U' B2 R' B U B U R2 L' B L"), # 13
        RootAlg.new('h710b', "L' B L' B2 R B2 R' B2 L2 U2 L' B L"), # 13
        RootAlg.new('h132', "R B' R' U' L U' L' B2 U B L' B L"), # 13
        RootAlg.new('h754b', "L U L' B' R' U' R2 B L' B' R' B L"), # 13
        RootAlg.new('h121', "L' B' R B2 D2 L' D' L D' B2 R' B L"), # 13
        RootAlg.new('h112', "L' B2 R' L2 F R' F' R' L2 B R' B L"), # 13
        RootAlg.new('h521c', "L2 U' L B' L' U R' L U R U' B L"), # 13
        RootAlg.new('h121b', "L' B' R B2 R' B2 U' L U' L' U2 B L"), # 13
        RootAlg.new('h157b', "L2 B2 R B' R' L B2 L U2 L' U2 B L"), # 13
        RootAlg.new('h878b', "F U F' U2 L' U' B2 R B R' U2 B L"), # 13
        RootAlg.new('h157', "L2 B2 R B' D2 R D2 R' B2 R' L B L"), # 13
        RootAlg.new('h340b', "L2 B R B' D2 B' D2 B D2 R' L B L"), # 13
        RootAlg.new('h848b', "L B' R' U F U' F' B L2 B' R B L"), # 13
        RootAlg.new('h839', "L2 B' L U' R' U L' B L B' R B L"), # 13
        RootAlg.new('h654', "F' L' B L2 F L2 B2 U R' U2 R B L"), # 13
        RootAlg.new('h1066', "R' U L' U2 R U R B' R2 U2 R B L"), # 13
        RootAlg.new('h710', "L' B L' B2 R B2 L B2 R2 U2 R B L"), # 13
        RootAlg.new('h385', "R B2 L' B' L B' R' L' U' B' U B L"), # 13
        RootAlg.new('h417c', "R U R' U R U2 R' L' U' B' U B L"), # 13
        RootAlg.new('h401', "L' D' B R2 B R' B R B2 R2 B' D L"), # 13
        RootAlg.new('h1117c', "L' D2 R' U R U' D R B2 R' B2 D L"), # 13
        RootAlg.new('h403', "L2 D2 R' D2 L B2 U D' R U' R D L"), # 13
        RootAlg.new('h1107', "R' U L' U2 R U2 B' U B R' U2 R L"), # 13
        RootAlg.new('h6', "R' U L' U2 R2 B U B' U' R2 U2 R L"), # 13
        RootAlg.new('h428', "L2 B2 R B R' B2 L2 U L' U' B' U L"), # 13
        RootAlg.new('h70b', "R B U B' U L' U L U2 R' L' U L"), # 13
        RootAlg.new('h674', "R B U2 L' U2 L U2 B' R' U' L' U L"), # 13
        RootAlg.new('h303b', "L' U2 R L U' L' U R' L U L' U L"), # 13
        RootAlg.new('h303', "R U R' L' U2 R U R' L U L' U L"), # 13
        RootAlg.new('h245', "R U B U' B' R' L' U2 L U L' U L"), # 13
        RootAlg.new('h692', "R L' B2 U' B2 U B U2 B U R' U L"), # 13
        RootAlg.new('h395', "R U2 R' U' R U' R' L' B' U' B U L"), # 13
        RootAlg.new('h945b', "L D2 R F R' D2 L B' L U' B U L"), # 13
        RootAlg.new('h119b', "L' B2 R B R' U R' U' R U' B U L"), # 13
        RootAlg.new('h912', "R U' L' U2 R' B' R U' R' U2 B U L"), # 13
        RootAlg.new('h954', "L2 B2 R B2 L B' R2 U' R U2 B U L"), # 13
        RootAlg.new('h661', "L2 F2 R2 D R' B2 R D' R2 F2 L U L"), # 13
        RootAlg.new('h972', "B' U B U R' B R2 U2 B2 U2 R2 B' R"), # 13
        RootAlg.new('h474b', "R' U2 F2 U2 B L F' L F2 L2 F B' R"), # 13
        RootAlg.new('h738', "R' B U L U R U2 L' U' R' U B' R"), # 13
        RootAlg.new('h774', "R' D B2 R2 U L' B L U' R2 B2 D' R"), # 13
        RootAlg.new('h301', "R' D B2 U2 D' B' R2 B U2 D B2 D' R"), # 13
        RootAlg.new('h776b', "R2 D R' B R D B' D' R' B' R2 D' R"), # 13
        RootAlg.new('h848', "R2 D B R' U' R' U2 R B' U2 R2 D' R"), # 13
        RootAlg.new('h827', "R2 U R2 U R2 U' R D R' U' R D' R"), # 13
        RootAlg.new('h827b', "R' D R U' R2 U R2 U R2 U2 R D' R"), # 13
        RootAlg.new('h974b', "B D2 F2 L F2 D2 F B2 R B R' F' R"), # 13
        RootAlg.new('h804c', "R2 L2 D B D B' D2 R2 L2 U R' F' R"), # 13
        RootAlg.new('h360', "R' F L2 F2 B L' F' L F' B' L2 F' R"), # 13
        RootAlg.new('h559', "R' B U2 B2 U' R' U R B2 U' B' U' R"), # 13
        RootAlg.new('h443', "B' R' B U' R' U' R U' B U' B' U' R"), # 13
        RootAlg.new('h514', "R' F' U' F B L2 D F D' L2 B' U' R"), # 13
        RootAlg.new('h870', "R' U' B L2 F L' F L F' L2 B' U' R"), # 13
        RootAlg.new('h854', "B U L U' L' B' L U' R' U L' U' R"), # 13
        RootAlg.new('h1117', "R B' R U' B R B' U R2 B R' U' R"), # 13
        RootAlg.new('h1104', "R' U R2 B2 U R' B R U' B2 R2 U' R"), # 13
        RootAlg.new('h557', "R2 B U' L U R L' U R' B' R U' R"), # 13
        RootAlg.new('h682', "R2 U2 R2 B L U' L' B' R2 U2 R U' R"), # 13
        RootAlg.new('h103', "R' B' U2 F' B D L2 D' B2 U F B2 R"), # 13
        RootAlg.new('h433', "R B R2 D2 L F L' U L U' L' D2 R"), # 13
        RootAlg.new('h350', "R B U' L U R2 L' D2 L2 F L2 D2 R"), # 13
        RootAlg.new('h222', "B L U L' U' L U' L' B' U' R' U2 R"), # 13
        RootAlg.new('h602', "B U' L' B L2 U L' U' B2 U' R' U2 R"), # 13
        RootAlg.new('h1149', "R' U2 R' D' R U R' D R2 U' R' U2 R"), # 13
        RootAlg.new('h246', "B' R' U' R U B R' U' R U' R' U2 R"), # 13
        RootAlg.new('h398', "B L U' L' B' U' R' U R U' R' U2 R"), # 13
        RootAlg.new('h952', "R' U R B U' B' R' U' R U2 R' U2 R"), # 13
        RootAlg.new('h964', "R' U2 R B L U' L' U' B' U R' U2 R"), # 13
        RootAlg.new('h393', "B2 L2 U B' L' B U' L2 B2 U R' U2 R"), # 13
        RootAlg.new('h1130', "R' U2 B' U' B U B' R2 B' R2 B2 U2 R"), # 13
        RootAlg.new('h407c', "B' R B2 D2 L' B L B' D2 B' R2 U2 R"), # 13
        RootAlg.new('h1199', "R' U' R2 B U' B' U2 B U B' R2 U2 R"), # 13
        RootAlg.new('h192', "R U2 R' U2 B U B2 R B U' R2 U2 R"), # 13
        RootAlg.new('h339', "R B2 D B2 R' U' R B2 D' B2 R2 U2 R"), # 13
        RootAlg.new('h844', "R B2 R' B L' B L B' R B2 R2 U2 R"), # 13
        RootAlg.new('h456', "L U L' U R' U2 R B2 R B2 R2 U2 R"), # 13
        RootAlg.new('h1198', "R2 D' R U2 R' D R2 B' R B R2 U2 R"), # 13
        RootAlg.new('h257', "R' U2 R U R' U' R B' R B R2 U2 R"), # 13
        RootAlg.new('h966c', "L U2 L' U2 L' B2 L B R B R2 U2 R"), # 13
        RootAlg.new('h966d', "R B2 L' B2 R' B2 L B R B R2 U2 R"), # 13
        RootAlg.new('h966b', "R B2 R' U2 R' U2 R B R B R2 U2 R"), # 13
        RootAlg.new('h529b', "R' U2 B L U L' B2 D' R2 D B U2 R"), # 13
        RootAlg.new('h625', "R' U2 R B' U2 B U R' B' U B U2 R"), # 13
        RootAlg.new('h736', "B' R B R2 L D F2 D' L2 U L U2 R"), # 13
        RootAlg.new('h1088', "B' R' B U R B U' B' R2 U2 R U2 R"), # 13
        RootAlg.new('h902', "L' B L F' L2 B' L F R' F' L F R"), # 13
        RootAlg.new('h722', "R D L' B L D' R2 F' L' U' L F R"), # 13
        RootAlg.new('h916', "L U2 L' U2 L' B L2 U' L' B' R' U R"), # 13
        RootAlg.new('h916b', "R B2 L' B2 R' B L2 U' L' B' R' U R"), # 13
        RootAlg.new('h170', "B' U' R' U R B2 L U' L' B' R' U R"), # 13
        RootAlg.new('h69', "R' U2 R2 B2 L' B' L B' R' U' R' U R"), # 13
        RootAlg.new('h69b', "L U2 L2 B2 R B' L B' R' U' R' U R"), # 13
        RootAlg.new('h754c', "L U2 L2 B L B R B2 R' U' R' U R"), # 13
        RootAlg.new('h303c', "L' B' U R' U' R2 B R' L U' R' U R"), # 13
        RootAlg.new('h643', "L' U2 L B U' L' U' B L B2 R' U R"), # 13
        RootAlg.new('h713', "B2 L2 B' U L' U' B L2 B2 U2 R' U R"), # 13
        RootAlg.new('h1048b', "L2 B2 L B' U' B L' B2 L2 U2 R' U R"), # 13
        RootAlg.new('h119', "R' U' R2 U R2 U R2 U2 R' U R' U R"), # 13
        RootAlg.new('h1181', "R2 B2 R2 U2 R' U2 R' B2 R2 U R' U R"), # 13
        RootAlg.new('h68', "R U2 R' U' R U' R2 U2 R U R' U R"), # 13
        RootAlg.new('h102b', "R B L' B L B2 R2 U2 R U R' U R"), # 13
        RootAlg.new('h1141', "L' U R U' L U R2 U2 R U R' U R"), # 13
        RootAlg.new('h513', "R U R' U R' U' R2 B U' B' R2 U R"), # 13
        RootAlg.new('h906', "B' R B R' U2 R U B U' B' R2 U R"), # 13
        RootAlg.new('h110c', "R U2 D B' U2 B' U2 B U2 D' R2 U R"), # 13
        RootAlg.new('h1172b', "R2 D' L F L' D R2 B' R B R2 U R"), # 13
        RootAlg.new('h1058', "R B' R' B U2 B U' B2 R B R2 U R"), # 13
        RootAlg.new('h444', "B' U' R' U R B2 U B2 R B R2 U R"), # 13
        RootAlg.new('h305', "B L F' L F L2 B' R' F' U' F U R"), # 13
        RootAlg.new('h368b', "R L' D B2 D' R2 L U' F' U F U R"), # 13
        RootAlg.new('h379', "L U2 R' L' F' U B' U B U F U R"), # 13
        RootAlg.new('h1048', "L2 B2 L B' U' B R B2 R2 U2 L U R"), # 13
        RootAlg.new('h1163', "B' R' B U' R' U2 B' R B U R U R"), # 13

        RootAlg.new('h1208c', "B L' D F2 U2 R U R2 F' R F' U D' B'"), # 14
        RootAlg.new('h845c', "R' U' R U' L F' L' B L F2 U2 F' L' B'"), # 14
        RootAlg.new('h986', "B2 L2 F' L2 B' L F2 R U R' U F' L' B'"), # 14
        RootAlg.new('h202b', "R' U' R B L' U2 L2 U L2 U L2 U' L' B'"), # 14
        RootAlg.new('h1208', "R U2 R' B R B' U2 B R' U L U' L' B'"), # 14
        RootAlg.new('h1010', "B' R2 F R2 B R' F' R B U L U' L' B'"), # 14
        RootAlg.new('h1010b', "F' U2 F U2 F R' F' R B U L U' L' B'"), # 14
        RootAlg.new('h463', "B U B2 R B R2 U R B U L U' L' B'"), # 14
        RootAlg.new('h314', "B' U2 D2 F U2 F' U2 F R' F' D2 B2 L' B'"), # 14
        RootAlg.new('h1052c', "R U R F2 B2 L2 D' B R2 B2 L' F2 L' B'"), # 14
        RootAlg.new('h57', "R B2 U B' U' R' U2 L B U2 B' U2 L' B'"), # 14
        RootAlg.new('h532', "R L' B2 D' B' D2 L' D' L' B' R' B L' B'"), # 14
        RootAlg.new('h752', "R L' B D' R' B R D L2 B' R' B L' B'"), # 14
        RootAlg.new('h344', "B' R B2 L' B D' B D R' B2 L2 U L' B'"), # 14
        RootAlg.new('h220', "B' R' U' R U B R' U' R B L U L' B'"), # 14
        RootAlg.new('h622c', "B L U2 R U' L' D B' U2 B U D' R' B'"), # 14
        RootAlg.new('h329b', "B2 L' B' L B U2 B U2 B' U2 R B2 R' B'"), # 14
        RootAlg.new('h845b', "B R B2 D' B U B' R2 U R2 U2 D R' B'"), # 14
        RootAlg.new('h58', "R B U B' U' R' B U L' B L B' U' B'"), # 14
        RootAlg.new('h520b', "R L' B2 R' L U' R B R' B U B' U' B'"), # 14
        RootAlg.new('h858', "B' R B R' U2 B L F U F' U2 L' U' B'"), # 14
        RootAlg.new('h852', "B U2 B' U B R B' L' B L B R' U' B'"), # 14
        RootAlg.new('h286b', "B L' B' U R' U' R2 B2 L B R' B2 U' B'"), # 14
        RootAlg.new('h55c', "B' D' R U' R U2 R U' R' U' D B2 U' B'"), # 14
        RootAlg.new('h25', "B' U' B2 U R' U' R L U' L' U B2 U' B'"), # 14
        RootAlg.new('h700', "B L2 D L B2 R2 D' R2 B2 L' D' L2 U' B'"), # 14
        RootAlg.new('h389', "B' R' U' R U' B2 U L' D L' D' L2 U' B'"), # 14
        RootAlg.new('h877c', "R' U' R B L' B' L U2 L U2 L' B U' B'"), # 14
        RootAlg.new('h877d', "R' U' R B L' B' R B2 L B2 R' B U' B'"), # 14
        RootAlg.new('h980', "B' U2 B2 U B2 R' U R B' L' B' L U' B'"), # 14
        RootAlg.new('h316', "B L U R' U L' U' L U L' U' R U' B'"), # 14
        RootAlg.new('h91b', "B U2 D2 R B2 U B' U B2 U2 B2 R' D2 B'"), # 14
        RootAlg.new('h30', "R F' U2 F U2 R B D2 F' L U2 F D2 B'"), # 14
        RootAlg.new('h1183b', "R B' R' F2 B2 D' L2 F U2 F' L2 D F2 B'"), # 14
        RootAlg.new('h1106c', "L2 F2 B2 R' F R' B R F2 R F' B2 L2 B'"), # 14
        RootAlg.new('h986c', "F' B L2 D' B D2 F' D R' B' D2 F2 L2 B'"), # 14
        RootAlg.new('h419', "R B' R B R2 B U2 R2 B2 R' B2 R' U2 B'"), # 14
        RootAlg.new('h1017c', "B U R B' L' B R' L U R B R' U2 B'"), # 14
        RootAlg.new('h619', "R B2 R F2 L F L' F R' B R' B2 U2 B'"), # 14
        RootAlg.new('h705', "R' U' R B' R2 B U' R U B' R2 B2 U2 B'"), # 14
        RootAlg.new('h286', "R B' R' U B U R' U R B' U B2 U2 B'"), # 14
        RootAlg.new('h589c', "L U L2 B L2 U R' U2 R L' U B2 U2 B'"), # 14
        RootAlg.new('h1020', "B R2 U B' U' R2 U' R U' R B R2 U2 B'"), # 14
        RootAlg.new('h196b', "B' R' U' R U B2 U2 B2 R B R' B U2 B'"), # 14
        RootAlg.new('h51', "R' U2 R U' B U2 B' R' U2 R U' B U2 B'"), # 14
        RootAlg.new('h91', "R B2 R' U B' U R' U2 R B2 U2 B U2 B'"), # 14
        RootAlg.new('h572d', "R B2 L' D L' D' L2 B R' B U2 B U2 B'"), # 14
        RootAlg.new('h895b', "L' B2 L B' R B R' L' B' L U2 B U2 B'"), # 14
        RootAlg.new('h1052b', "B D' F' L F' R L' D' L D R' F2 D B'"), # 14
        RootAlg.new('h320b', "F2 U' F' U2 F' B' R' F R B2 D' L2 D B'"), # 14
        RootAlg.new('h400c', "B D' R' D2 R' U L U' R L' D2 R D B'"), # 14
        RootAlg.new('h980b', "F' U R' L' F' U F U' R L B U' F B'"), # 14
        RootAlg.new('h980c', "F' U L' U' R B' R' B U L B U' F B'"), # 14
        RootAlg.new('h1033', "B U' L' B2 D L' F2 L D2 R D B2 L B'"), # 14
        RootAlg.new('h235', "L2 D R' F2 R D' L' U' L' U' L' B L B'"), # 14
        RootAlg.new('h535', "R B U B' U' R' L U L' U' L' B L B'"), # 14
        RootAlg.new('h1017b', "L U' R L' U B U' B' R' U L' B L B'"), # 14
        RootAlg.new('h1142', "R2 B2 L' B' L B L' B R' B R' B L B'"), # 14
        RootAlg.new('h260', "B2 L' B' R' L B R2 U2 B' U2 R2 B' R B'"), # 14
        RootAlg.new('h845', "B R' B2 D B U B' D2 R2 D B2 U' R B'"), # 14
        RootAlg.new('h981', "B U R' U' R U' L U' R' U' L' U2 R B'"), # 14
        RootAlg.new('h541', "B U L' B L2 U' L' U' B' U' R' U2 R B'"), # 14
        RootAlg.new('h400b', "B R' D' R2 U D' L U' L' D R2 D R B'"), # 14
        RootAlg.new('h622', "B2 U' B2 R B R' B U' L U2 L' B' U B'"), # 14
        RootAlg.new('h334', "B R B R' U R' U' R2 B' R' U' B' U B'"), # 14
        RootAlg.new('h334b', "B2 U R2 U' R2 B' D B' D' B U' B' U B'"), # 14
        RootAlg.new('h1072', "B2 U2 B U' R' U R B2 U B U2 B' U B'"), # 14
        RootAlg.new('h337', "B R B' L' B' L B' U B' U' B2 R' U B'"), # 14
        RootAlg.new('h29', "R B' R' B2 U2 R B2 U B U' B2 R' U B'"), # 14
        RootAlg.new('h1120b', "B U R' U2 L U R L' U R' U R U B'"), # 14
        RootAlg.new('h898c', "L' F' B L F L2 B' U L2 D R' F R D'"), # 14
        RootAlg.new('h312c', "L2 B2 L' F' L B2 L2 F U F R U' R' F'"), # 14
        RootAlg.new('h737b', "F R F B U F2 D' L2 D F B' U2 R' F'"), # 14
        RootAlg.new('h956', "F' L F' L2 B L' B' L2 F' R U R' U' F'"), # 14
        RootAlg.new('h852c', "F' U2 F' D' B L2 B' D F' R U R' U' F'"), # 14
        RootAlg.new('h872b', "B L' B' L U2 L U2 L' F R U R' U' F'"), # 14
        RootAlg.new('h872', "B L' B' R B2 L B2 R' F R U R' U' F'"), # 14
        RootAlg.new('h223', "R B2 L' B' L B' R' F U2 F' U' F U' F'"), # 14
        RootAlg.new('h56', "L' B' U' B U L F U F R' F' R U' F'"), # 14
        RootAlg.new('h91d', "F' L' F U' B' U F B D2 B2 R' B2 D2 F'"), # 14
        RootAlg.new('h495b', "L' B L F2 L B' L' F' D2 B' R B D2 F'"), # 14
        RootAlg.new('h292', "L' B' L F2 R2 F' U2 L' B2 R B' L U2 F'"), # 14
        RootAlg.new('h424b', "F2 B L B' R2 B L' B2 R' B R2 F' R F'"), # 14
        RootAlg.new('h9', "R U R2 F2 D' R2 B L' B' R2 D F' R F'"), # 14
        RootAlg.new('h1160', "F R' U' B2 L U' F2 U L2 D L B2 U F'"), # 14
        RootAlg.new('h737c', "L B U D L D2 R' B2 R U' D L2 B' L'"), # 14
        RootAlg.new('h207', "B U2 B' U' B U' B' L F2 R' F' R F' L'"), # 14
        RootAlg.new('h378b', "L F2 R L2 B U' B' U R2 L2 F' R F' L'"), # 14
        RootAlg.new('h955b', "R2 B2 R' L' U' B2 U B2 L U L U2 R' L'"), # 14
        RootAlg.new('h280', "R U2 B' U2 B U L U' R' F U2 F' U' L'"), # 14
        RootAlg.new('h711b', "R U L B L' U' L B' R' F U F' U' L'"), # 14
        RootAlg.new('h378', "L' B' R B' R' B2 L2 U F' L F L' U' L'"), # 14
        RootAlg.new('h334c', "B U2 B2 R' U' R B2 L U L2 B' L2 U' L'"), # 14
        RootAlg.new('h233', "R' U L U' R U' L2 U' B' U B L2 U' L'"), # 14
        RootAlg.new('h882', "B' U2 R' U B L' B' R U' B U L2 U' L'"), # 14
        RootAlg.new('h634c', "B' U' R U2 F R F' U2 B' R' B2 L U' L'"), # 14
        RootAlg.new('h684', "B L' B' L U' B' R B' R' B2 U2 L U' L'"), # 14
        RootAlg.new('h1052', "R' U' F' U F R B L' B' L U L U' L'"), # 14
        RootAlg.new('h701', "L2 D' R' B2 R' B D B2 L' D2 R2 F' D2 L'"), # 14
        RootAlg.new('h291', "L' B' U2 L2 D2 L' U' R2 U L F' R2 D2 L'"), # 14
        RootAlg.new('h237', "B' R B L' B R' B' L2 D2 R' F R D2 L'"), # 14
        RootAlg.new('h572c', "F R2 B' D B' D' B2 R F' L F2 R F2 L'"), # 14
        RootAlg.new('h898b', "B' U' B L U L D R' F' R D' L' U2 L'"), # 14
        RootAlg.new('h706b', "R' L U' R U' B2 L B' L' B L' B2 U2 L'"), # 14
        RootAlg.new('h730b', "B L' B' R' L U' R U' B2 L' B2 L2 U2 L'"), # 14
        RootAlg.new('h733b', "B L U L' U' L' B2 R B' R' B2 L2 U2 L'"), # 14
        RootAlg.new('h390', "B' R B' R2 U R U B U' L' B L2 U2 L'"), # 14
        RootAlg.new('h691c', "F2 D R D' F2 U L' D' B2 U D L2 U2 L'"), # 14
        RootAlg.new('h413', "L F R' F R F2 U2 L2 B L B' L U2 L'"), # 14
        RootAlg.new('h516b', "R U B U' B U' B2 U B2 U R' L U2 L'"), # 14
        RootAlg.new('h785', "B' R' B L' B' R2 B L B2 R' B2 L U2 L'"), # 14
        RootAlg.new('h1180', "B' R' U2 F R' F2 U' F U R2 B L U2 L'"), # 14
        RootAlg.new('h1025', "B' R' U R2 B L B' R' B L' U L U2 L'"), # 14
        RootAlg.new('h582b', "B' U D2 F2 R B' R2 F2 B2 U' B' D2 B L'"), # 14
        RootAlg.new('h1115', "R L D' B D R' D' B R B R' B2 D L'"), # 14
        RootAlg.new('h1171b', "F' L2 B2 D2 F' R F B' D2 L B' L2 F L'"), # 14
        RootAlg.new('h1171c', "B L2 F2 D2 B R F B' D2 L B' L2 F L'"), # 14
        RootAlg.new('h62', "L' B L2 F R F2 R' L2 B2 R B L2 F L'"), # 14
        RootAlg.new('h1208b', "R' U2 R U B L F U F2 L' B' L F L'"), # 14
        RootAlg.new('h673', "R U B U' B' R' F U F' U' F' L F L'"), # 14
        RootAlg.new('h677', "R U' B U' B' R' U' L F' R' F2 R F L'"), # 14
        RootAlg.new('h1041', "B L B' R B L2 B' R2 L U L U' R L'"), # 14
        RootAlg.new('h673d', "R B U' L U L2 B' R2 L U L U' R L'"), # 14
        RootAlg.new('h287', "R B U D F' L F D' B' L U2 R' U L'"), # 14
        RootAlg.new('h1098b', "F' B L' B' U L F R U2 L U R' U L'"), # 14
        RootAlg.new('h691e', "B2 D' R' D B2 U' L B2 D2 F2 D2 B2 U L'"), # 14
        RootAlg.new('h691d', "B2 D' R' D B2 U' L F2 U2 F2 U2 F2 U L'"), # 14
        RootAlg.new('h51c', "F B' U R2 U' R' U R2 U' F' B L U L'"), # 14
        RootAlg.new('h925', "R B2 L' B' U2 L2 U L2 U L2 U L' B' R'"), # 14
        RootAlg.new('h1184', "R U B U' B2 D' B U B' D B2 U' B' R'"), # 14
        RootAlg.new('h589', "B U' R B' U R B R2 B2 R B2 U' B' R'"), # 14
        RootAlg.new('h601', "B' R' U' R2 B' R' B2 R B' U B2 U' B' R'"), # 14
        RootAlg.new('h675', "L F2 U' F2 U F2 U L' U' R B U' B' R'"), # 14
        RootAlg.new('h424', "B2 U' R2 B R' B' R' U B2 R B U' B' R'"), # 14
        RootAlg.new('h392', "R B R' L U L' U' R B' U B U' B' R'"), # 14
        RootAlg.new('h98', "R B2 R2 U2 B' U' B U' R2 L' B' L B' R'"), # 14
        RootAlg.new('h1142b', "R B' R' U' R U B2 U' B L' B' L B' R'"), # 14
        RootAlg.new('h1087b', "R2 B' L B D2 B D2 B' L2 D2 R' L B' R'"), # 14
        RootAlg.new('h502', "B2 R2 B' L2 B R2 B' L B' R B L B' R'"), # 14
        RootAlg.new('h1191', "B2 L U' L' U L U L2 B2 R B L B' R'"), # 14
        RootAlg.new('h254', "R B R' L U L' U B' U' B U' R B' R'"), # 14
        RootAlg.new('h903', "R U B U L' B L B' L U L' U B' R'"), # 14
        RootAlg.new('h652', "B L' B' R B L2 U' L' B' U' B U B' R'"), # 14
        RootAlg.new('h691', "R D B L' D2 R F' R' D2 L2 B' L' D' R'"), # 14
        RootAlg.new('h1092', "R B U B' R2 D L' D' R2 D L U' D' R'"), # 14
        RootAlg.new('h55b', "R U' D B2 U' B U' B U2 B U' B D' R'"), # 14
        RootAlg.new('h24', "R B U R L B U B' U' R' L' B' U' R'"), # 14
        RootAlg.new('h553', "L' U R U' R' L U2 R U B U' B' U' R'"), # 14
        RootAlg.new('h42', "R' B U L U' B' R2 B U' L' U2 B' U' R'"), # 14
        RootAlg.new('h874', "R B U' L U' L' U L U L' U2 B' U' R'"), # 14
        RootAlg.new('h96', "R B U' B2 U2 B U B' U B2 U2 B' U' R'"), # 14
        RootAlg.new('h567', "R U' B' R B2 U B' U' R' B U2 B' U' R'"), # 14
        RootAlg.new('h567b', "R B U' L U L' U' B' U B U2 B' U' R'"), # 14
        RootAlg.new('h877b', "R B L2 D' R D L2 D' R' U D B' U' R'"), # 14
        RootAlg.new('h196', "B2 U B' L B U' B2 R B L' U B' U' R'"), # 14
        RootAlg.new('h1092b', "R2 U2 R' B R L U' L' U2 R' U B' U' R'"), # 14
        RootAlg.new('h46', "R2 U R' B' R U' R2 U R B2 U B' U' R'"), # 14
        RootAlg.new('h673c', "R B U' B' U B U2 B' U' B U B' U' R'"), # 14
        RootAlg.new('h753b', "R2 F2 L F L' F2 R F' R2 B U B' U' R'"), # 14
        RootAlg.new('h467', "B U R B2 U B D' R2 D R' B' R' U' R'"), # 14
        RootAlg.new('h691b', "R U B R B2 D2 F L F' D2 B R' U' R'"), # 14
        RootAlg.new('h499b', "B L' B L2 U L2 B2 L U2 R U B2 U' R'"), # 14
        RootAlg.new('h572', "R U2 R2 U2 R' U B U' B' R U R2 U' R'"), # 14
        RootAlg.new('h558b', "R' U R B' R B U' F B' R2 F' B U' R'"), # 14
        RootAlg.new('h373', "R B U B' U' B U B' R B' R' B U' R'"), # 14
        RootAlg.new('h694', "R2 D L' B2 L D' R' U' R B' R' B U' R'"), # 14
        RootAlg.new('h1183', "R B L' B L B U' B2 U' B2 U2 B U' R'"), # 14
        RootAlg.new('h55', "B L' B' R B2 L B R' U' R U B U' R'"), # 14
        RootAlg.new('h757', "R B U B' U2 F' L2 D' B D L2 F U' R'"), # 14
        RootAlg.new('h840', "R B' U' B' U B2 U B' U2 L' B2 L U' R'"), # 14
        RootAlg.new('h520', "R U B U2 B2 R' B U2 B U2 B' R U' R'"), # 14
        RootAlg.new('h753', "R B U' B' U B U B' U2 R' U' R U' R'"), # 14
        RootAlg.new('h95', "L U L' U L U2 R L' U2 R' U' R U' R'"), # 14
        RootAlg.new('h323', "R L' U' L U' L' U' R' U' L U' R U' R'"), # 14
        RootAlg.new('h57b', "R U2 R2 U' R2 B' R' D' R2 D B R U' R'"), # 14
        RootAlg.new('h895c', "B' R B' R2 L2 U2 B L' B' U2 R2 L2 B2 R'"), # 14
        RootAlg.new('h734c', "B L' B R2 L2 F R F' U2 L' U2 R2 B2 R'"), # 14
        RootAlg.new('h1069', "R U B U' B R2 U2 R B R' U2 R2 B2 R'"), # 14
        RootAlg.new('h198', "R B2 U2 B R B2 R' B R B R' U2 B2 R'"), # 14
        RootAlg.new('h475b', "B U B' R' F' U' F R2 B L' B L B2 R'"), # 14
        RootAlg.new('h451c', "R2 L2 B' D' R' B L2 U D2 L' B2 L D2 R'"), # 14
        RootAlg.new('h408b', "R' B2 L' B' L B2 R2 B U B U B' U2 R'"), # 14
        RootAlg.new('h855', "L U F U' F' R B L' U2 L B' L' U2 R'"), # 14
        RootAlg.new('h567c', "R L' B L2 D2 R' F R' F R2 D2 L' U2 R'"), # 14
        RootAlg.new('h469', "R U B U2 B' R D L' B' L D' R' U2 R'"), # 14
        RootAlg.new('h898', "R B U' B' U' R D L' B' L D' R' U2 R'"), # 14
        RootAlg.new('h997', "R B U B' U' R D L' B2 L D' R' U2 R'"), # 14
        RootAlg.new('h377b', "R U' B L' B L U B' U B U2 B2 U2 R'"), # 14
        RootAlg.new('h22b', "R2 B2 R2 U' R L' D L2 U2 L D' L2 U2 R'"), # 14
        RootAlg.new('h696', "F2 D' L2 B L B' L D F' R' F' R2 U2 R'"), # 14
        RootAlg.new('h1133d', "D B D2 R U' R' U D2 B' U2 D' R U2 R'"), # 14
        RootAlg.new('h1133b', "B2 R' U' R' D' R U D R B2 U' R U2 R'"), # 14
        RootAlg.new('h333', "F2 L2 B L B' L F L' U L F R U2 R'"), # 14
        RootAlg.new('h1070', "L' U2 R U' B' U B R' U2 L U R U2 R'"), # 14
        RootAlg.new('h320', "L F' L2 U' L U' R2 B' L D2 R' L' B R'"), # 14
        RootAlg.new('h742', "R L' B L2 U2 L B R B' L2 B2 R' B R'"), # 14
        RootAlg.new('h634d', "L U2 R L' U R D B D' R' B' U' B R'"), # 14
        RootAlg.new('h416b', "B2 U' B L' U' B U D L' D' R L2 B R'"), # 14
        RootAlg.new('h1033b', "R2 B' D' R D2 B' L2 B D2 F D R2 B R'"), # 14
        RootAlg.new('h1087', "R2 B' L' B' R2 B' R2 B' R2 B2 R L B R'"), # 14
        RootAlg.new('h629', "L' U2 L U B L' U L B' U' B' R B R'"), # 14
        RootAlg.new('h665', "B' R B R' U' R B' R' B U' B' R B R'"), # 14
        RootAlg.new('h650b', "B L2 U L2 B D' B D B U' B' R B R'"), # 14
        RootAlg.new('h866', "R B2 R' U' B' R' U' R U2 B U2 R B R'"), # 14
        RootAlg.new('h891c', "B' U' B U' R B' L' B R' L U2 R B R'"), # 14
        RootAlg.new('h558', "R B U' B' U' B U2 B2 U' R' U R B R'"), # 14
        RootAlg.new('h740', "L2 U B L2 B' R L2 D' B2 U B' U' D R'"), # 14
        RootAlg.new('h1070b', "R' D B U2 B' U2 D2 B' D R2 D' B D R'"), # 14
        RootAlg.new('h768', "R F' R L2 B' L B R' B L' B L2 F R'"), # 14
        RootAlg.new('h623', "B L B' R B U L' B' U2 B U B' U R'"), # 14
        RootAlg.new('h227b', "L U' R D2 R' U R L' U' L D2 L' U R'"), # 14
        RootAlg.new('h622b', "R2 U2 B' R D' R D R2 B2 U2 B' R' U R'"), # 14
        RootAlg.new('h728', "R B2 U R2 B U2 B' U2 B' R2 U' B2 U R'"), # 14
        RootAlg.new('h414', "R B U B U2 B' R B2 R' B' U2 B2 U R'"), # 14
        RootAlg.new('h541b', "L' U R U' B U B2 U2 B2 U' B' L U R'"), # 14
        RootAlg.new('h260b', "R' D' L F' L' D R' L' B' R' B L U R'"), # 14
        RootAlg.new('h416', "B' R B2 U2 B' R' U' B U' B' U' R U R'"), # 14
        RootAlg.new('h697', "R2 B2 R' B2 U' L U' L' U R' U' R U R'"), # 14
        RootAlg.new('h469b', "L F U F2 L F L2 F B2 D' R' D F' B2"), # 14
        RootAlg.new('h1133e', "B2 U R B2 R' L U2 D2 L' U' L D2 L' B2"), # 14
        RootAlg.new('h227', "B2 U R2 U2 R2 B2 U R2 U R2 U2 B2 U' B2"), # 14
        RootAlg.new('h805', "B' R' B' U' B R B' R L' B2 R' L U' B2"), # 14
        RootAlg.new('h74', "B L' B' U B2 L2 B2 R' U R U B2 L2 B2"), # 14
        RootAlg.new('h451', "B U' B R2 U' R B R' B' U2 B U' R2 B2"), # 14
        RootAlg.new('h20', "B2 R2 B' U B2 R B R2 U R U2 B2 R2 B2"), # 14
        RootAlg.new('h1102', "R' L U L' U' R L' B2 R2 B' L B R2 B2"), # 14
        RootAlg.new('h1093', "L' U' L B L' B' U B2 R2 B' L B R2 B2"), # 14
        RootAlg.new('h757b', "L U' D R U R' U2 D' L' B2 D' R D B2"), # 14
        RootAlg.new('h981b', "L U' L' B2 D' B U' B' U' D R' U R B2"), # 14
        RootAlg.new('h413c', "F2 L' B L2 F B' L2 U2 F D2 B2 R' B2 D2"), # 14
        RootAlg.new('h413b', "B2 L' B2 D2 F U2 R2 F B' R2 B R' F2 D2"), # 14
        RootAlg.new('h478c', "B2 L' U2 B2 U L2 U' D L2 F2 D R' F2 D2"), # 14
        RootAlg.new('h907e', "F2 R2 L2 B' D2 B U F' R2 F U' R2 L2 F2"), # 14
        RootAlg.new('h488b', "R L' U R' U' R' L F2 R2 B' R B R2 F2"), # 14
        RootAlg.new('h1106', "R2 L' B R' B U2 R B2 R' B' L' B R' L2"), # 14
        RootAlg.new('h618', "L2 B2 R2 F' D' F R2 D R' F R D' B2 L2"), # 14
        RootAlg.new('h1191b', "L' U' B L U R L' B R' U' B L' B2 L2"), # 14
        RootAlg.new('h7', "B L' D' B' R B' R2 U2 B' R D L' B2 L2"), # 14
        RootAlg.new('h684c', "F U2 F2 L F L2 B' R B L' B2 R' B2 L2"), # 14
        RootAlg.new('h634', "L' B' R' U2 R2 U B U' B L' B R' B2 L2"), # 14
        RootAlg.new('h505', "L2 B' U R' U' R B' L2 B U' B' L2 B2 L2"), # 14
        RootAlg.new('h259', "R' L' U2 R' B D B' D' R2 L U' L2 B2 L2"), # 14
        RootAlg.new('h22', "R L' D' R2 U2 R' D R2 U2 L U' L2 B2 L2"), # 14
        RootAlg.new('h907d', "L2 F2 D L' U L D' F2 B2 R' D' R B2 L2"), # 14
        RootAlg.new('h1022b', "R2 L2 B' L B' R' U2 B2 L' B R B' R2 L2"), # 14
        RootAlg.new('h560', "R' L2 U L U' R U B' U' B U L' U2 L2"), # 14
        RootAlg.new('h1022c', "R B2 L2 B' L2 B' R' L2 D' L U2 L' D L2"), # 14
        RootAlg.new('h996', "F2 R2 B' R' B R' F2 L2 D' R B2 R' D L2"), # 14
        RootAlg.new('h670', "L' U D' R D B' L' B' D' B' R' B2 D L2"), # 14
        RootAlg.new('h1133c', "R' L2 D' L D' R' D B2 L' D2 R D' R L2"), # 14
        RootAlg.new('h1025d', "L' B2 R2 B R2 B R2 L D L' B2 L D' R2"), # 14
        RootAlg.new('h502b', "R D L' U D' R D' R' U' R D2 L D' R2"), # 14
        RootAlg.new('h572b', "R2 U2 B' R' B R U' R2 U2 R U2 R U' R2"), # 14
        RootAlg.new('h1033c', "F2 B L' B' U2 R' F2 R' B2 D' L2 D' B2 R2"), # 14
        RootAlg.new('h198c', "R2 U2 B' R B U2 F2 B2 L F L' F B2 R2"), # 14
        RootAlg.new('h988', "R B2 L' B R D2 R D R' D B' L B2 R2"), # 14
        RootAlg.new('h1142c', "R2 L2 B R' B' L B' L2 U2 L' B' R B2 R2"), # 14
        RootAlg.new('h77', "B R B2 R' B' R2 F2 R D' L2 D R' F2 R2"), # 14
        RootAlg.new('h1119b', "R2 F2 R' L B L' U L B' L' U' R F2 R2"), # 14
        RootAlg.new('h1133', "R' B U2 B' R' U' B' R B R U' R' U2 R2"), # 14
        RootAlg.new('h895', "R' U2 R' U2 B' R B R2 B' R' B R' U2 R2"), # 14
        RootAlg.new('h876', "B' R B' R' B2 U2 R B' R L' B' L B R2"), # 14
        RootAlg.new('h837', "R' B' U' R U B U2 R' U2 R U R2 U R2"), # 14
        RootAlg.new('h502c', "L F2 R2 F' R2 F' L' U2 F R B' R' F' B"), # 14
        RootAlg.new('h566', "L F U' R U R' L' B' L U F' U' L' B"), # 14
        RootAlg.new('h1168b', "B' L F2 R2 F2 U' R' U R F2 R F2 L' B"), # 14
        RootAlg.new('h772b', "B2 L U F U' L' B R' L F R F2 L' B"), # 14
        RootAlg.new('h1025e', "R U D' R2 B' R' B R' D R' U' B' R' B"), # 14
        RootAlg.new('h783', "R U B U' B' U R' B' R B U' B' R' B"), # 14
        RootAlg.new('h412b', "R2 D R' U R D' R2 B' R B U' B' R' B"), # 14
        RootAlg.new('h544', "B L' B L B2 R U R' U R U2 B' R' B"), # 14
        RootAlg.new('h874b', "F' L' U R' L U' R F U R U2 B' R' B"), # 14
        RootAlg.new('h810', "R U2 R2 U' R2 U' B' R' B U2 R B' R' B"), # 14
        RootAlg.new('h481', "F' B' U R U2 F2 R' L F L' F2 U' R' B"), # 14
        RootAlg.new('h1049', "L' U' B' U B' R2 D2 R' D2 B' L B2 R' B"), # 14
        RootAlg.new('h544b', "R U B U' B L2 D2 L D2 B' L B2 R' B"), # 14
        RootAlg.new('h278', "R2 D' R' U R' D B2 U' B U2 R' U2 R' B"), # 14
        RootAlg.new('h662c', "L2 B2 D R' F2 R D' B2 L2 B2 R B R' B"), # 14
        RootAlg.new('h1136', "B2 D' R D B U2 R U' R2 U2 R2 U R' B"), # 14
        RootAlg.new('h329c', "B L2 D' B D' R2 B' D2 L2 B2 U F' U' B"), # 14
        RootAlg.new('h479', "B' R U R2 U R' U' R U R' U2 R' U' B"), # 14
        RootAlg.new('h43', "B R U B2 U' R' B U2 R' U2 R B U' B"), # 14
        RootAlg.new('h331', "R B' R' U2 R B R' U' B' R' U' R U' B"), # 14
        RootAlg.new('h154', "B' R' U' R2 D R' U2 R D' R2 U R U' B"), # 14
        RootAlg.new('h382', "B' R2 B2 R' U R' B' R B U' R B2 R2 B"), # 14
        RootAlg.new('h826', "B' R2 B2 U B' R' B R U2 R' U B2 R2 B"), # 14
        RootAlg.new('h706', "R2 U B' U2 R' B R U R2 B' R U R2 B"), # 14
        RootAlg.new('h270', "L F U' R U R' U' F' U2 L' U' B' U2 B"), # 14
        RootAlg.new('h285', "R L' B L B U B2 U' B2 R' U' B' U2 B"), # 14
        RootAlg.new('h589b', "B2 D' B U' B' D R B R' B U' B' U2 B"), # 14
        RootAlg.new('h554', "R B' R' B U B U' B2 U' B U' B' U2 B"), # 14
        RootAlg.new('h270b', "L U2 L' U' B' R' U' R U' B U' B' U2 B"), # 14
        RootAlg.new('h893', "B' R' U R U' R' U' R U' B U' B' U2 B"), # 14
        RootAlg.new('h554b', "B' R' U R B' R B R' U2 B U' B' U2 B"), # 14
        RootAlg.new('h1085', "R U B U' B' R' L' B L B' U2 B' U2 B"), # 14
        RootAlg.new('h285d', "R L' D B2 D' R' B L U B' U2 B' U2 B"), # 14
        RootAlg.new('h1106b', "R' U2 R B2 L B U2 B' L2 B2 L B' U2 B"), # 14
        RootAlg.new('h554c', "B' L U L' U B2 R L' B' L B' R' U2 B"), # 14
        RootAlg.new('h278b', "L' D' R B R' D L2 U L2 B L B2 U2 B"), # 14
        RootAlg.new('h772', "B' U' R' U R B' D' B U2 B' D B U2 B"), # 14
        RootAlg.new('h717', "B' R2 U' R2 U' L' B R' B R B' L U2 B"), # 14
        RootAlg.new('h1196b', "B' U2 L' B2 U' B' U B R B R' L U2 B"), # 14
        RootAlg.new('h312e', "F U2 L F2 L' U2 F' B U B2 D' R2 D B"), # 14
        RootAlg.new('h651', "B2 D' F2 D2 L D L2 D' B D2 F2 R D B"), # 14
        RootAlg.new('h1119', "B2 R' B L' B' R2 B' R' U' B' U B2 L B"), # 14
        RootAlg.new('h129b', "L B' U2 L2 U R' U' L2 U2 B L' B' R B"), # 14
        RootAlg.new('h495', "R B2 L' D2 L B R2 B L F L' B' R B"), # 14
        RootAlg.new('h353', "L' U' L U' L' U2 L2 U L' B' R' U' R B"), # 14
        RootAlg.new('h126', "B' U' R' U R2 B' R' B2 U' B' R' U' R B"), # 14
        RootAlg.new('h582', "B' U' R' U R U' R' U2 R U' R' U' R B"), # 14
        RootAlg.new('h673b', "B U L U' L' B2 R' U R U' R' U' R B"), # 14
        RootAlg.new('h1140b', "R L' D' B D R' L U2 B' U' R' U2 R B"), # 14
        RootAlg.new('h1184b', "F B' U F2 L F L2 U2 R' U' L U2 R B"), # 14
        RootAlg.new('h495c', "B2 L B2 U2 R B L B D2 B R2 F R B"), # 14
        RootAlg.new('h224', "L' U' B L' B' L U L B' U' R' U R B"), # 14
        RootAlg.new('h475', "B' U L U L2 B L B2 U B R' U R B"), # 14
        RootAlg.new('h415b', "R L' D' B' D R' L U' B' U R' U R B"), # 14
        RootAlg.new('h475c', "F B' U F2 L F L2 U L U R' U R B"), # 14
        RootAlg.new('h1136b', "L' B' R L' D2 L D' B' D' R2 L U R B"), # 14
        RootAlg.new('h1136c', "L' B L B2 R L' D B' D' R2 L U R B"), # 14
        RootAlg.new('h1022', "R' U2 R U2 R2 U R' B' R U' R U R B"), # 14
        RootAlg.new('h153', "R B' R2 D2 R U' R' D2 R2 B R' B' U B"), # 14
        RootAlg.new('h955c', "R2 U B2 D B2 U' B D' B' R2 U2 B' U B"), # 14
        RootAlg.new('h499', "B' U2 R' B L' B' R B2 L B' U B' U B"), # 14
        RootAlg.new('h1081', "L2 F2 R' D F D' F2 R F' L2 U B' U B"), # 14
        RootAlg.new('h891', "R U' B' U2 B U R' B' U' B U B' U B"), # 14
        RootAlg.new('h688', "R B2 L' B2 R' B L B2 U2 B U B' U B"), # 14
        RootAlg.new('h575', "B' U' R' U R2 D B U B' U' D' R' U B"), # 14
        RootAlg.new('h248', "R U2 R2 U' R' U R2 U' R' B' U' R' U B"), # 14
        RootAlg.new('h548', "B2 R2 B2 U B' R2 B U' B2 R' B R' U B"), # 14
        RootAlg.new('h289', "B U2 B2 U' B2 U' B2 U B' R B R' U B"), # 14
        RootAlg.new('h1061', "L' U' B' U B2 L B' U' B2 R B R' U B"), # 14
        RootAlg.new('h312f', "F U2 R U2 R' U2 F' B D L2 D' B2 U B"), # 14
        RootAlg.new('h548b', "B L2 D R' L D' L' D R D' L2 B2 U B"), # 14
        RootAlg.new('h329', "L U2 L' B R' U R2 B R2 U' R B2 U B"), # 14
        RootAlg.new('h377', "B' R2 U R2 B' R B R2 U R' U2 R2 U B"), # 14
        RootAlg.new('h662', "B' U' B' R B2 R U2 R' B' R U2 R2 U B"), # 14
        RootAlg.new('h745', "B' R' U2 F R' F' D' L F L' D R2 U B"), # 14
        RootAlg.new('h1025b', "B' R' U' R U R2 D' R U' R' D R2 U B"), # 14
        RootAlg.new('h988b', "L2 D R' F' R D' L2 B' U R' U' R U B"), # 14
        RootAlg.new('h400', "B' R' U' R B' R B R' U R' U' R U B"), # 14
        RootAlg.new('h1002', "R U2 R' U' B' R B U' B' R2 U' R U B"), # 14
        RootAlg.new('h863', "R' U2 R2 U R' U R U2 B' R2 U' R U B"), # 14
        RootAlg.new('h1082', "L' U' B' U B' R B2 L B' R2 U' R U B"), # 14
        RootAlg.new('h893b', "L' U2 L B' L' B U2 B' R' L U' R U B"), # 14
        RootAlg.new('h475d', "B' R2 F2 B2 L F L' F B2 R U' R U B"), # 14
        RootAlg.new('h1072b', "B U B2 R D' R2 U R' D R U2 R U B"), # 14
        RootAlg.new('h1072c', "R B2 D B D2 R2 U R' D R U2 R U B"), # 14
        RootAlg.new('h1168', "L U L' U' F' B2 R F' D2 F R' B2 L' F"), # 14
        RootAlg.new('h634e', "F2 B2 R D2 R' B2 D F2 U F2 D' F L' F"), # 14
        RootAlg.new('h634f', "F2 B2 R D2 R' B2 U L2 U L2 U' F L' F"), # 14
        RootAlg.new('h601b', "F' R B L2 U D' R B2 R' D B' U' R' F"), # 14
        RootAlg.new('h285c', "R L' D B2 D' R' B L U F' L2 B' L2 F"), # 14
        RootAlg.new('h986b', "F' B L2 D' B D2 F' D R' F D2 B2 L2 F"), # 14
        RootAlg.new('h1211', "L' B' L F' L D2 F2 R' F2 D2 L B L2 F"), # 14
        RootAlg.new('h554d', "R L' U' L U R' U F' D' B L' B' D F"), # 14
        RootAlg.new('h1074', "R2 F D' F D L D2 F2 R2 F' L2 B L F"), # 14
        RootAlg.new('h451b', "R2 B2 D2 F L' B D2 F' R2 B R' F' R F"), # 14
        RootAlg.new('h1152', "L' B' R B' R' B L F' L' B U' L U F"), # 14
        RootAlg.new('h1098', "B' U2 B U B' R B' R' B2 U B L' B' L"), # 14
        RootAlg.new('h1068', "R L2 B L B' R' L' B L2 U L' U' B' L"), # 14
        RootAlg.new('h1171', "L2 B L B' R B2 R' U2 B U2 B' U2 B' L"), # 14
        RootAlg.new('h734', "F' L F L2 B2 R B2 L' B' R' B2 L B' L"), # 14
        RootAlg.new('h408', "R2 L' U2 R' B' R U2 R2 B U' B U B' L"), # 14
        RootAlg.new('h1196', "R B2 R' U' B' U B U R B2 L' B' R' L"), # 14
        RootAlg.new('h866c', "B U2 B2 U' R B R2 U R2 B L' B' R' L"), # 14
        RootAlg.new('h1108', "B' R' U' R2 B' R' B2 U R B L' B' R' L"), # 14
        RootAlg.new('h863b', "L' B U B' R D B' L U' L' U D' R' L"), # 14
        RootAlg.new('h285b', "R L2 B2 L B U B2 R B2 R' B' U' R' L"), # 14
        RootAlg.new('h220c', "L' U' B U2 B2 U2 B' R U B' U' B2 R' L"), # 14
        RootAlg.new('h126b', "R' U L' F' R2 D' F' D F D2 B' D2 R' L"), # 14
        RootAlg.new('h572f', "R2 L' D' B' D2 B' D2 B2 D B' R' B R' L"), # 14
        RootAlg.new('h866b', "L' U2 R B U B' U' B' R' U2 R B R' L"), # 14
        RootAlg.new('h572e', "L' B' U' B2 U B U' B2 U B R B R' L"), # 14
        RootAlg.new('h1120', "R U2 L' U B U B' U L U L' U R' L"), # 14
        RootAlg.new('h184', "R L' B' U' B2 U2 B U2 B' U2 B2 U R' L"), # 14
        RootAlg.new('h937', "R U L' U B U' B U2 B2 U2 B2 U R' L"), # 14
        RootAlg.new('h608b', "R B2 L' B' L B' L' U B U' B' R' U' L"), # 14
        RootAlg.new('h412', "R2 U R' B R U' R' B' U' L' U R' U' L"), # 14
        RootAlg.new('h1080', "R B U B' U' B U B' U2 L' U R' U' L"), # 14
        RootAlg.new('h807', "R L' U B2 U2 B2 U2 B U B U R' U' L"), # 14
        RootAlg.new('h312d', "R U2 L' U L' B' L2 U2 L2 B R' L U' L"), # 14
        RootAlg.new('h662b', "L D R' F R D' L2 B' U' R B' R' B2 L"), # 14
        RootAlg.new('h1085b', "F U R U' R' F' B' R B L' B2 R' B2 L"), # 14
        RootAlg.new('h734b', "B L' B R2 L2 F R F' U2 R U2 L2 B2 L"), # 14
        RootAlg.new('h382b', "L' B2 L2 U' R L' B R' B' L U L2 B2 L"), # 14
        RootAlg.new('h1020c', "B' U2 B U2 B L' B R D' R D R2 B2 L"), # 14
        RootAlg.new('h907c', "B2 R L' D B2 D2 L' D' L B2 R D R2 L"), # 14
        RootAlg.new('h907b', "B2 R L' D B' R D' R' D2 B R D R2 L"), # 14
        RootAlg.new('h378c', "R L' D B D' R2 U' R U B U2 B' U2 L"), # 14
        RootAlg.new('h410', "F2 R2 F2 R B' R' B L' U2 F R F' U2 L"), # 14
        RootAlg.new('h852b', "R B2 L B' L2 B' R' U2 B L2 B' L' U2 L"), # 14
        RootAlg.new('h83', "R U2 L' B U' B' U2 L U2 R' U' L' U2 L"), # 14
        RootAlg.new('h478b', "L' U R' U' R U' B2 L' B2 L2 U' L' U2 L"), # 14
        RootAlg.new('h314c', "L' U2 D2 R2 B' R2 D2 L2 F2 L' F L' U2 L"), # 14
        RootAlg.new('h684b', "B U2 B' R' L' U2 R B' U' R B R' U2 L"), # 14
        RootAlg.new('h72', "L' U' B' U B U2 R L U' L' U R' U2 L"), # 14
        RootAlg.new('h91c', "L U2 B R2 L2 U L' U' R2 B' U2 L2 U2 L"), # 14
        RootAlg.new('h616', "R' U' R U' B D' R' U2 R D B' L' B L"), # 14
        RootAlg.new('h650', "B' R' U' R L U' L' U' B' U2 B L' B L"), # 14
        RootAlg.new('h200', "L' B' L U' R' U R U' R' U R L' B L"), # 14
        RootAlg.new('h111', "L' B' R2 L U2 R2 U R2 U R2 U L' B L"), # 14
        RootAlg.new('h419b', "L' B2 R2 D2 R' D2 B' L B' L' B' R' B L"), # 14
        RootAlg.new('h419c', "R B2 L2 D2 L D2 B' L B' L' B' R' B L"), # 14
        RootAlg.new('h353b', "R' U' R U' B U' B' U' R L' B' R' B L"), # 14
        RootAlg.new('h207b', "B' U2 B U B' U B L' B2 R B R' B L"), # 14
        RootAlg.new('h224b', "B' U' B2 L' B' L2 U' L2 B2 R B R' B L"), # 14
        RootAlg.new('h224c', "R L' B' R' B U B U' B' U2 B' U B L"), # 14
        RootAlg.new('h783b', "R L' U D' B U' B' D R' U2 B' U B L"), # 14
        RootAlg.new('h810b', "L' B L U R L2 B2 R' L U B2 U B L"), # 14
        RootAlg.new('h907', "L' B U2 B U R' U R B U' B U B L"), # 14
        RootAlg.new('h871b', "L' B' U' B U2 B U2 R B' R' U2 B' U L"), # 14
        RootAlg.new('h111b', "L' U' R L2 B2 L2 B L2 B L2 B R' U L"), # 14
        RootAlg.new('h711', "L2 U L U2 L2 U R L' U' L2 U R' U L"), # 14
        RootAlg.new('h1025c', "B' R' U' R B2 L' D' B2 U' B' D B2 U L"), # 14
        RootAlg.new('h516', "B U B' U' B' R B R' L' B' U' B U L"), # 14
        RootAlg.new('h1140', "B' R B R' U' R' U R L' B' U' B U L"), # 14
        RootAlg.new('h488c', "L' U2 L' D' R B2 R' D L B' U' B U L"), # 14
        RootAlg.new('h829', "B' R' B L' B' R U' B U B' U' B U L"), # 14
        RootAlg.new('h1073', "L' B2 R B U2 R2 U' R2 U' R' U2 B U L"), # 14
        RootAlg.new('h900', "B L U L' U' L B' R' B U L' U' B' R"), # 14
        RootAlg.new('h154b', "B D F' L F D' B' L U2 R' U L' U' R"), # 14
        RootAlg.new('h669', "B U2 B2 R' L2 U' R U L2 B U2 R' U' R"), # 14
        RootAlg.new('h1196c', "L U' R' U R2 L' D L' B L D' R2 U' R"), # 14
        RootAlg.new('h478', "R' U R2 B2 U R2 U R2 U' B2 U' R2 U' R"), # 14
        RootAlg.new('h455', "B' R B R U' R U R U B' R' B U' R"), # 14
        RootAlg.new('h737', "R2 F R F2 L' B' U L F L' B L U' R"), # 14
        RootAlg.new('h493', "R L2 B L B' R' L U' R' L' U L U' R"), # 14
        RootAlg.new('h198b', "R' B2 U2 R2 B' R B R B' R B U2 B2 R"), # 14
        RootAlg.new('h416c', "R' F2 L D' L B' D' B2 D B D L2 F2 R"), # 14
        RootAlg.new('h1020b', "B' R2 F R2 B R' F L D' L D L2 F2 R"), # 14
        RootAlg.new('h871', "R B U2 R' U' R U' R2 U2 R B' R' U2 R"), # 14
        RootAlg.new('h144', "B2 L2 U B' L' B U' L2 B' U B' R' U2 R"), # 14
        RootAlg.new('h312', "R U B' R B R' U' R2 U' R U' R' U2 R"), # 14
        RootAlg.new('h314b', "R2 L2 D2 R F' R2 D2 L2 B2 R' B R' U2 R"), # 14
        RootAlg.new('h608', "B U2 B2 U' R' U R2 B2 U B' U' R2 U2 R"), # 14
        RootAlg.new('h8', "R2 D' R U' R' D R' B U B' U' R2 U2 R"), # 14
        RootAlg.new('h14', "L U' R' U L' U2 R2 B U B' U' R2 U2 R"), # 14
        RootAlg.new('h415', "R U2 L' U R' U' R' L U' R2 U' R2 U2 R"), # 14
        RootAlg.new('h733', "B L U L' U' L' B2 R B' L B2 R2 U2 R"), # 14
        RootAlg.new('h730', "B L' B' R' L U' R U' B2 R B2 R2 U2 R"), # 14
        RootAlg.new('h1061b', "B' U' R' U R2 B R' U2 B' R B R2 U2 R"), # 14
        RootAlg.new('h731', "L' B2 U B2 U' B2 U' L B' R B R2 U2 R"), # 14
        RootAlg.new('h1026', "R' U' R U' B L U' L' B2 R B R2 U2 R"), # 14
        RootAlg.new('h120', "R B2 D L2 D F L2 D' B D' R2 B U2 R"), # 14
        RootAlg.new('h663', "R D B' R' U B' U' R B R D' R U2 R"), # 14
        RootAlg.new('h663b', "R B U B' U2 R' U2 R' D' L F2 L' D R"), # 14
        RootAlg.new('h144b', "R L2 B' L2 B L2 B R2 F2 L' F L' F R"), # 14
        RootAlg.new('h898d', "D' L' F' B L F L2 B' U L2 D R' F R"), # 14
        RootAlg.new('h1211b', "F' U2 F U2 F2 R' F D2 B' L B D2 F R"), # 14
        RootAlg.new('h220b', "F' L' U' L U F B L U' L' B' R' U R"), # 14
        RootAlg.new('h1017', "R U2 R2 U' R2 U' R' U B U' B' R' U R"), # 14
        RootAlg.new('h202', "B U L U2 L' B U L U' L' B2 R' U R"), # 14
        RootAlg.new('h129', "B' R B R U L U' R2 U L' U2 R' U R"), # 14
        RootAlg.new('h955', "R' U R2 B2 R' U2 R' U2 R B2 U2 R' U R"), # 14
        RootAlg.new('h51b', "L B2 R2 B' L2 B R2 L2 B2 L' U R' U R"), # 14
        RootAlg.new('h634b', "L' U2 B U2 B U2 B' U2 B2 L U R' U R"), # 14
        RootAlg.new('h891b', "B U L U2 L' U' B' R' U' R U R' U R"), # 14
        RootAlg.new('h44', "B L2 F' L' F L' B' R' U2 R U R' U R"), # 14
        RootAlg.new('h488', "R' U R U2 R U B' R' B R U' R2 U R"), # 14
        RootAlg.new('h733c', "B L U L' U2 L' B' R B2 L B2 R2 U R"), # 14
        RootAlg.new('h1144', "L' U2 L U B L' U L B2 R B R2 U R"), # 14
        RootAlg.new('h877', "R U R2 U B' R' B R U R U R2 U R"), # 14
        RootAlg.new('h204', "B L U L' U B' U' R' U2 F' U2 F U R"), # 14
        RootAlg.new('h312b', "R B2 L' B' L B' R2 U' F R' F' R U R"), # 14

        RootAlg.new('h411b', "B U B R2 U2 R B2 R' U2 R2 B' L U' L' B'"), # 15
        RootAlg.new('h483b', "R B' R2 B U2 B U2 B' R B U L U' L' B'"), # 15
        RootAlg.new('h761i', "B L2 F2 R' D' F R' D' R D R L' F L' B'"), # 15
        RootAlg.new('h748', "B' R2 B R2 B U' R2 B2 R' U B U' B2 R' B'"), # 15
        RootAlg.new('h374', "R B R' U2 B2 R' U2 R2 B R' U2 R B2 R' B'"), # 15
        RootAlg.new('h271', "B L U L' B R2 U2 R B' R' U2 R2 B' U' B'"), # 15
        RootAlg.new('h761h', "R B' R' B2 L' U2 F' L' F U2 L2 U L' U' B'"), # 15
        RootAlg.new('h234', "R' U L' U R2 U' L U2 B U' B2 R' B2 U' B'"), # 15
        RootAlg.new('h761j', "R' F' L' U' B U2 B' U2 L F B' R B2 U' B'"), # 15
        RootAlg.new('h330d', "L' U R' U' R2 B R' B' R B' R' L B U' B'"), # 15
        RootAlg.new('h780b', "L' U R' U' R2 B R' L U2 L' B L B U' B'"), # 15
        RootAlg.new('h27b', "B' U2 B U2 B2 L' D' B' R B2 R' D L U' B'"), # 15
        RootAlg.new('h330b', "B R2 B R' B U' B U2 B' U B' R B' R2 B'"), # 15
        RootAlg.new('h158c', "B2 U' B2 U B R2 U2 B' R B' R2 B2 U2 R2 B'"), # 15
        RootAlg.new('h761', "R U B U2 B2 R' B U B U2 R U' R' U2 B'"), # 15
        RootAlg.new('h411g', "B U L U' L' U2 B2 R2 D' R' D R' B2 U2 B'"), # 15
        RootAlg.new('h27', "R' B U' R' B2 U2 R U2 B R' U B R2 U2 B'"), # 15
        RootAlg.new('h355', "R' U2 R U B L U2 L2 B L B2 U B U2 B'"), # 15
        RootAlg.new('h786', "R2 F2 L F L' F2 R F2 U F R U B U2 B'"), # 15
        RootAlg.new('h256b', "R B' R' B2 R' B R2 U2 B2 U2 R2 B' R U2 B'"), # 15
        RootAlg.new('h27c', "B2 D' R2 F D' F2 L2 U2 F' D F2 R2 U' D B'"), # 15
        RootAlg.new('h330e', "F' L' B' U B2 L' B' L2 F2 D B' R B D' F'"), # 15
        RootAlg.new('h483', "L F' L2 B L2 F L2 B' L F U R U' R' F'"), # 15
        RootAlg.new('h330k', "F R2 L2 B R D' R2 B2 R2 D R' B' R2 L2 F'"), # 15
        RootAlg.new('h613', "F2 L F L' F R U' B U' B' U' R2 F R F'"), # 15
        RootAlg.new('h338b', "F' B D L D2 F' D2 B R' D' F' R' B2 U F'"), # 15
        RootAlg.new('h10', "F' B D' L' D B' L2 F' R' F L2 F2 R U F'"), # 15
        RootAlg.new('h786b', "F B' U' B U F' U2 L F U' R U2 R' F' L'"), # 15
        RootAlg.new('h761b', "B L U L' B2 U' B L U F R' U R F' L'"), # 15
        RootAlg.new('h228c', "L' B' R B' L B2 R' B2 L' B2 L U' L U' L'"), # 15
        RootAlg.new('h228e', "L' B' R B' R D2 R' D2 R' B2 L U' L U' L'"), # 15
        RootAlg.new('h761d', "L B' U2 B U2 B' U F U' F' R B' R' B2 L'"), # 15
        RootAlg.new('h281c', "L B2 L2 B U' B2 R B2 R' B2 U B' L2 B2 L'"), # 15
        RootAlg.new('h761e', "F U R F' L2 D' B' D L' F R2 F R F2 L'"), # 15
        RootAlg.new('h732', "R2 L2 D2 R F L2 U' R B L U' R2 F R2 L'"), # 15
        RootAlg.new('h561b', "L' B U2 D2 L D2 R' B2 R L2 U2 B' L2 U2 L'"), # 15
        RootAlg.new('h236b', "B2 R B' U R' B2 R U' B' L B' R' B U2 L'"), # 15
        RootAlg.new('h761f', "L U R' U2 R U2 R' F U' F' R2 B' R' B L'"), # 15
        RootAlg.new('h231', "L F' U2 R B2 U' R' F2 R U B2 R' U2 F L'"), # 15
        RootAlg.new('h761c', "R B2 L2 D L2 U L' U' D' B' U L U' B' R'"), # 15
        RootAlg.new('h231b', "R B D2 R' B2 U L' B2 L U' B2 R D2 B' R'"), # 15
        RootAlg.new('h374b', "R L' B' R' L2 U2 L' B L' B' R B' L B' R'"), # 15
        RootAlg.new('h755b', "B2 L' U2 F' L' F U2 B' L2 U L' U' R B' R'"), # 15
        RootAlg.new('h256c', "R2 D L2 D' R' D2 L' U' L D' L' U L' D' R'"), # 15
        RootAlg.new('h767', "R2 B' L' B' R' B L B2 R B' R' U B' U' R'"), # 15
        RootAlg.new('h166', "R2 B R' U2 B U2 B' R' U R2 B2 R' B U' R'"), # 15
        RootAlg.new('h265', "R B2 R2 U' R U' B' R' U2 R2 B U B U' R'"), # 15
        RootAlg.new('h281', "R B2 L U' L2 B' L U2 L' B L2 U L' B2 R'"), # 15
        RootAlg.new('h281b', "R B2 R2 B U' B2 L U2 L' B2 U B' R2 B2 R'"), # 15
        RootAlg.new('h15', "L' B2 L2 U2 L2 B R B' L B R2 U2 R2 B2 R'"), # 15
        RootAlg.new('h158b', "R2 U R2 U' R B2 U2 R2 B2 R' B' R' U2 B2 R'"), # 15
        RootAlg.new('h366b', "R B2 R2 D' R D R2 U B2 U B R' U2 B2 R'"), # 15
        RootAlg.new('h338', "R B2 L U L2 U R U' L U B R' U2 B2 R'"), # 15
        RootAlg.new('h366', "R B2 R2 U2 R B' U' B2 U' R2 D' R' D B2 R'"), # 15
        RootAlg.new('h330g', "R B L' U2 F' L' F L2 U L2 U L B' U2 R'"), # 15
        RootAlg.new('h236c', "B2 D' R D B2 L U' R L' U2 B U B' U2 R'"), # 15
        RootAlg.new('h256', "R2 B' R' U' R U R B R U R2 U2 R' U2 R'"), # 15
        RootAlg.new('h802', "R L' B' L U R' U R B' U2 B' U2 B U2 R'"), # 15
        RootAlg.new('h366c', "R L' B L U' B2 D' F R2 F' U2 D B U2 R'"), # 15
        RootAlg.new('h265b', "R L' B' R' U2 R2 L' B' R' B2 L B L U2 R'"), # 15
        RootAlg.new('h748b', "R2 B2 R' U B U' D R D' B D R' D' B R'"), # 15
        RootAlg.new('h755', "R B' L' B L2 U L' U B U L U L' B R'"), # 15
        RootAlg.new('h236', "R2 D B2 U B' U' B' R' U R D' B' R' B R'"), # 15
        RootAlg.new('h166b', "R B U' L U' L' B' U' R' U R2 B' R' B R'"), # 15
        RootAlg.new('h1176b', "R2 B2 R' L' B' L U' B' R B' R2 U' R B R'"), # 15
        RootAlg.new('h1176', "R L U2 L2 B L U' B' R B' R2 U' R B R'"), # 15
        RootAlg.new('h330h', "B2 L2 F' L D' B D B2 L' F L2 B2 R B R'"), # 15
        RootAlg.new('h330i', "B2 L2 F' L2 B2 U B U' L2 F L2 B2 R B R'"), # 15
        RootAlg.new('h330j', "F2 R2 F' R2 F2 U B U' L2 F L2 B2 R B R'"), # 15
        RootAlg.new('h853d', "L2 B2 R' F D F' R B2 L' U' R U L' U R'"), # 15
        RootAlg.new('h330f', "R2 L' D2 F D' B' D F' D2 B' R' B L U R'"), # 15
        RootAlg.new('h761g', "L2 D L' U L2 D' L B2 U F D' R' D F' B2"), # 15
        RootAlg.new('h853b', "B' R L' B' D B2 D' R' B2 R B' L B' R' B2"), # 15
        RootAlg.new('h1176c', "L' B L B2 R2 B2 U L' B' L B U' B R2 B2"), # 15
        RootAlg.new('h802b', "F2 R2 D' B2 R F B' L F' B R' B2 D R2 F2"), # 15
        RootAlg.new('h802c', "F2 R2 U' L2 B R L' F R' L B' L2 U R2 F2"), # 15
        RootAlg.new('h755c', "R2 L2 D' F' D2 F2 D R' D' L2 B' L2 D' R' L2"), # 15
        RootAlg.new('h166c', "R B' U B U' R' L U F' L F2 U F' U' L2"), # 15
        RootAlg.new('h234b', "L2 B2 R' F D F' D' L' F2 R' L D' R2 B2 L2"), # 15
        RootAlg.new('h1110', "R L' B R2 B2 D' R D B2 U2 R B L' B L2"), # 15
        RootAlg.new('h613b', "B2 L' B' L B' R' U F' U F U2 F R' F' R2"), # 15
        RootAlg.new('h687', "R2 F' B2 L F' L B D B' L' D' L' F2 B2 R2"), # 15
        RootAlg.new('h158d', "R B U2 L' B2 R B' R' L U B2 U' R B2 R2"), # 15
        RootAlg.new('h158', "R B2 U2 R B R' U2 B2 R U R2 U R2 U2 R2"), # 15
        RootAlg.new('h411', "B U2 B2 U' R B R2 U2 R' B' R U' R' B R2"), # 15
        RootAlg.new('h853c', "B R L' B R2 L U2 R B2 U' B L U L' B"), # 15
        RootAlg.new('h853', "B' U B' R B' R2 B' U' B R2 B R' B U' B"), # 15
        RootAlg.new('h226', "B' R' U' R B U B U2 R B' R' U2 B2 U2 B"), # 15
        RootAlg.new('h330', "B' R' B U2 R U' R' U2 R U R' U2 B' R B"), # 15
        RootAlg.new('h228', "R2 U' B' R' B2 U B2 R B U R2 U B' R B"), # 15
        RootAlg.new('h158e', "R' L U L' U' R U2 B' R2 F R F' U2 R B"), # 15
        RootAlg.new('h330c', "B' U' B U2 R B' R' U2 R B R' U2 B' U B"), # 15
        RootAlg.new('h313', "B' R' U' R B2 U B2 U B2 U2 B' U B' U B"), # 15
        RootAlg.new('h228d', "R B' L' B2 R' L B U L' B L U' B2 U B"), # 15
        RootAlg.new('h28', "R U B U' B D B D2 R D R U' R U B"), # 15
        RootAlg.new('h271b', "R B L U' L' U L U' L' B' R' U' F' U2 F"), # 15
        RootAlg.new('h749b', "R U' L' U R' U' R L B U' B' R' F' U F"), # 15
        RootAlg.new('h749c', "R U D' B U' B2 D R' B D L2 D' L B' L"), # 15
        RootAlg.new('h28c', "L2 U B R2 L2 B' L2 B D L2 D' R2 L B' L"), # 15
        RootAlg.new('h174', "L' B2 L2 U2 B U B' U L2 B R B' R' B2 L"), # 15
        RootAlg.new('h561', "L' U B' U2 B U' B' U R' U2 R U' B U2 L"), # 15
        RootAlg.new('h411c', "L' B' U' B U B' R B2 R' B2 L U2 L' B L"), # 15
        RootAlg.new('h411d', "L' B' U' B U B' L U2 R' U2 R U2 L' B L"), # 15
        RootAlg.new('h411e', "L' B' U' B U B' L U2 L' B2 R B2 R' B L"), # 15
        RootAlg.new('h780', "L' B' U R' U' R B2 U B2 U B2 U2 B' U L"), # 15
        RootAlg.new('h483c', "F' L' U' L U F R B' R2 B U2 B U2 B' R"), # 15
        RootAlg.new('h28b', "L' B L U R2 L F L D2 R L' F L' U' R"), # 15
        RootAlg.new('h749', "L' B' U B L F U' F' L U' R' U L' U' R"), # 15
        RootAlg.new('h228b', "R' U R B U2 B' U B U2 B2 R B R2 U' R"), # 15
        RootAlg.new('h411f', "B L2 F B2 U F' U' B2 L B L B2 R' U2 R"), # 15
        RootAlg.new('h174b', "L' B' R B R' L U B U B2 R B R2 U2 R"), # 15
        RootAlg.new('h374c', "F' B D' L2 D F2 U' F' U2 B' R' F' U' F R"), # 15

        RootAlg.new('h693', "F' L2 B L B' U2 B L' B' L2 U F U' R U2 R'"), # 16
    ]
  end
end