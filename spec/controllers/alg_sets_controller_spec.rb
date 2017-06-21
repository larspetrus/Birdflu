require 'rails_helper'

RSpec.describe AlgSetsController do

  describe 'update' do
    let (:algset) { AlgSet.create!(name: "test", algs: "F1.F3 G1.G6", subset: "all", description: "No big", predefined: false, wca_user_id: 13, alg_set_fact_id: 99) }

    it 'normal update' do
      allow(controller).to receive(:can_change) { true }

      expect(algset.alg_set_fact_id).to eq(1)

      post :update, params: {id: algset.id, add_algs: 'H1', remove_algs: '', alg_set: {name: 'Ziggy', description: 'small'}}
      algset.reload

      expect(algset.subset).to eq('all')
      expect(algset.algs).to eq('F1.F3 G1.G6 H1.H25')
      expect(algset.name).to eq('Ziggy')
      expect(algset.description).to eq('small')
      expect(algset.alg_set_fact_id).to eq(2)
    end

    it 'ignores unpermitted fields' do
      allow(controller).to receive(:can_change) { true }

      post :update, params:  {id: algset.id, add_algs: '', remove_algs: '', alg_set: {subset: 'eo'} }
      algset.reload

      expect(algset.subset).to eq('all')
    end

    it 'handles invalid fields' do
      allow(controller).to receive(:can_change) { true }

      post :update, params: {id: algset.id, alg_set: {name: ''}, add_algs: '', remove_algs: ''}

      expect(response).to render_template(:edit)
    end

    it 'handles add/remove errors' do
      allow(controller).to receive(:can_change) { true }

      post :update, params: {id: algset.id, add_algs: 'BadName', remove_algs: '', alg_set: {}}

      expect(response).to render_template(:edit)
    end

    it 'raises exception when not allowed to edit' do
      allow(controller).to receive(:can_change) { false}

      expect {post :update, params: {id: algset.id, add_algs: 'BadName', remove_algs: ''} }.to raise_error(RuntimeError)
    end
  end

  describe 'alter_algs' do

    let(:algset) { AlgSet.make(algs: 'G1.G6 H19.H38') }

    it 'No change' do
      expect(controller.alter_algs(algset, "", "")).to eq({})
    end

    it 'Add algs' do
      expect(controller.alter_algs(algset, "F1.F3 H4.H26", "")[:replacement_algs]).to eq("F1.F3 G1.G6 H19.H38 H4.H26")
    end

    it 'Add invalid alg' do
      expect(controller.alter_algs(algset, "X14.X42", "")).to eq({errors: ["'X14.X42' is not combinable (yet)"]})
    end

    it 'Remove alg' do
      expect(controller.alter_algs(algset, "", "H19.H38")[:replacement_algs]).to eq("G1.G6")
    end

    it 'Remove alg not in set' do
      expect(controller.alter_algs(algset, "", "H4.H26")).to eq({errors: ["'H4.H26' is not in this algset"]})
    end

    it 'Remove invalid alg' do
      expect(controller.alter_algs(algset, "", "X99.Z00")).to eq({errors: ["'X99.Z00' is not combinable (yet)"]})
    end

    it 'Both add and remove algs' do
      expect(controller.alter_algs(algset, "F1.F3", "H19.H38")[:replacement_algs]).to eq("F1.F3 G1.G6")
    end

    it 'converts lower case' do
      expect(controller.alter_algs(algset, "f1.f3", "H19.H38")[:replacement_algs]).to eq("F1.F3 G1.G6")
    end

    it 'expands single alg names' do
      expect(controller.alter_algs(algset, "F3", "H19")[:replacement_algs]).to eq("F1.F3 G1.G6")
    end
  end

end