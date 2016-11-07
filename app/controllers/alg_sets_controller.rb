# frozen_string_literal: true

class AlgSetsController < ApplicationController
  def index
    @all_sets = AlgSet.all.map(&:computing_off).sort_by {|as| [as.subset, as.algs.length] }
    @to_compute = @all_sets.reject(&:computed).map(&:id).join(',')
  end

  def new
    @algset = AlgSet.new
  end

  def create
    @algset = AlgSet.new(algset_params)
    if @algset.save
      flash[:success] = "Alg set created!"
      redirect_to @algset
    else
      render 'new'
    end
  end

  def show
    @algset = AlgSet.find(params[:id]).computing_off
  end

  def edit
    @algset = AlgSet.find(params[:id])
  end

  def update
    @algset = AlgSet.find(params[:id]).computing_off

    algs_result = AlgSetsController::alter_algs(@algset, params[:add_algs], params[:remove_algs])
    unless algs_result[:errors].present?
      generated_params = (algs_result[:new_algs] ? {algs: algs_result[:new_algs], _cached_data: nil} : {})
      @algset.update_attributes(algset_params(generated_params))
    end

    if @algset.errors.blank?
      flash[:success] = "Alg set updated"
      redirect_to @algset
    else
      params[:alg_set][:add_algs] = params[:add_algs]
      render 'edit'
    end
  end

  def compute
    params[:ids].split(',').each { |id| AlgSet.find(id).save_cache }
    render json: { success: :true }
  rescue  Exception => e
    render json: { error: e.message }
  end

  def algset_params(generated_params = {})
    params.require(:alg_set).permit(:name, :description, :subset, :algs).merge(generated_params)
  end

  def self.alter_algs(algset, adds, removes)
    return {} if adds.blank? && removes.blank?

    old_malgs = algset.algs.split(' ')
    add_malgs = adds.upcase.split(' ')
    remove_malgs = removes.upcase.split(' ')
    errors = []

    add_malgs.each do |user_ma|
      errors << "Bad alg '#{user_ma}'" unless MirrorAlgs.all_names.include?(user_ma)
    end

    remove_malgs.each do |user_ma|
      if MirrorAlgs.all_names.include?(user_ma)
        errors << "#{user_ma} is not in this algset" unless old_malgs.include?(user_ma)
      else
        errors << "Bad alg '#{user_ma}'"
      end
    end

    if errors.empty?
      return { new_algs: (old_malgs + add_malgs - remove_malgs).sort.join(' ') }
    else
      errors.each { |error| algset.errors.add(:base, error)}
      return { errors: algset.errors.full_messages}
    end
  end
end
