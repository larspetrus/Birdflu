require 'rails_helper'

RSpec.describe AlgSetsController do

  describe 'alter_algs' do
    before(:each) do
      allow(MirrorAlgs).to receive(:_combined_data) do
        {
            'Nothing.--' => double(name: 'Nothing.--', ids: [1]),
            'F1.F3' => double(name: 'F1.F3', ids: [6, 11]),
            'G1.G6' => double(name: 'G1.G6', ids: [30, 48]),
            'H4.H26' => double(name: 'H4.H26', ids: [66, 88]),
            'J18.--' => double(name: 'J18.--', ids: [215]),
        }
      end
    end

    let(:algset) { AlgSet.new(algs: 'G1.G6 J18.--') }

    it 'No change' do
      expect(AlgSetsController::alter_algs(algset, "", "")).to eq({})
    end

    it 'Add algs' do
      expect(AlgSetsController::alter_algs(algset, "F1.F3 H4.H26", "")).to eq({new_algs: "F1.F3 G1.G6 H4.H26 J18.--"})
    end

    it 'Add invalid alg' do
      expect(AlgSetsController::alter_algs(algset, "X14.X42", "")).to eq({errors: ["Bad alg 'X14.X42'"]})
    end

    it 'Remove alg' do
      expect(AlgSetsController::alter_algs(algset, "", "J18.--")).to eq({new_algs: "G1.G6"})
    end

    it 'Remove alg not in set' do
      expect(AlgSetsController::alter_algs(algset, "", "H4.H26")).to eq({errors: ["H4.H26 is not in this algset"]})
    end

    it 'Remove invalid alg' do
      expect(AlgSetsController::alter_algs(algset, "", "X99.Z00")).to eq({errors: ["Bad alg 'X99.Z00'"]})
    end

    it 'Both add and remove algs' do
      expect(AlgSetsController::alter_algs(algset, "F1.F3", "J18.--")).to eq({new_algs: "F1.F3 G1.G6"})
    end

    it 'converts lower case' do
      expect(AlgSetsController::alter_algs(algset, "f1.f3", "j18.--")).to eq({new_algs: "F1.F3 G1.G6"})
    end

    # "Add and remove the same alg"
    # "Add/remove single alg ('autocomplete')"
  end

  describe 'computing_off' do
    before(:each) do
      allow(ComboAlg).to receive(:where) { double(includes: double(map: [66, 77]))}
      allow(algset).to receive(:ids) { [1,2,5]}
    end

    let (:algset) { AlgSet.new(name: "test", algs: "F1.F3", subset: "all") }

    it 'computes by default, ad returns alrady cached data when compute is off' do
      expect(algset.coverage).to eq(2)

      algset.computing_off

      expect(algset.coverage).to eq(2)
    end

    it 'respects computing_off' do
      algset.computing_off
      expect(algset.coverage).to eq(nil)
    end
  end

end