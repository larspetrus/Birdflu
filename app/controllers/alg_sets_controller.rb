# frozen_string_literal: true

class AlgSetsController < ApplicationController
  def index
    @all_sets = AlgSet.all.to_a.sort_by {|as| [as.subset, as.algs.length] }
  end

  def new
  end

  def create
  end

  def show
    @algset = AlgSet.find(params[:id])
  end

  def edit
    @algset = AlgSet.find(params[:id])
  end

  def update
    #TODO forbid :algs and :_cached_data from posting
    @algset = AlgSet.find(params[:id])

    algs_result = AlgSetsController::alter_algs(@algset, params[:add_algs], params[:remove_algs])
    unless algs_result[:errors].present?
      if algs_result[:new_algs]
        params[:alg_set][:algs] = algs_result[:new_algs]
        params[:alg_set][:_cached_data] = nil
      end
      @algset.update_attributes(algset_params)
    end

    if @algset.errors.blank?
      flash[:success] = "Alg set updated"
      redirect_to @algset
    else
      params[:alg_set][:add_algs] = params[:add_algs]
      render 'edit'
    end
  end

  def algset_params
    params.require(:alg_set).permit(:name, :description, :subset, :algs, :_cached_data)
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
