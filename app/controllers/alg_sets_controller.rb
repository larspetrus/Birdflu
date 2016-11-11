# frozen_string_literal: true

class AlgSetsController < ApplicationController
  def index
    @all_sets = AlgSet.all.map(&:computing_off).sort_by {|as| [as.subset, as.algs.length] }
    @all_sets.each { |as| as.editable_by_this_user = can_change(as) }
    @to_compute = @all_sets.reject(&:computed).map(&:id).join(',')
  end

  def new
    raise "Not allowed to create Algset" unless can_create

    @algset = AlgSet.new
  end

  def create
    raise "Not allowed to create Algset" unless can_create

    more_params = @login ? {wca_user_data_id: @login.db_id} : {predefined: true}
    @algset = AlgSet.new(algset_params(more_params))
    if @algset.save
      flash[:success] = "Alg set created!"
      redirect_to @algset
    else
      render 'new'
    end
  end

  def destroy
    algset = AlgSet.find(params[:id])
    raise "Not allowed to edit Algset #{algset.id}" unless can_change(algset)

    flash[:success] = "Algset '#{algset.name}' deleted"
    algset.destroy
    redirect_to alg_sets_url
  end

  def show
    @algset = AlgSet.find(params[:id]).computing_off
  end

  def edit
    @algset = AlgSet.find(params[:id])
    raise "Not allowed to edit Algset #{@algset.id}" unless can_change(@algset)
  end

  def update
    @algset = AlgSet.find(params[:id]).computing_off
    raise "Not allowed to update Algset #{@algset.id}" unless can_change(@algset)

    algs_result = AlgSetsController::alter_algs(@algset, params[:add_algs], params[:remove_algs])
    unless algs_result[:errors].present?
      more_params = (algs_result[:new_algs] ? {algs: algs_result[:new_algs], _cached_data: nil} : {})
      @algset.update_attributes(algset_params(more_params))
    end

    if @algset.errors.blank?
      flash[:success] = "Alg set updated"
      redirect_to @algset
    else
      params[:alg_set][:add_algs] = params[:add_algs]
      render 'edit'
    end
  end

  def can_create
    @login || AlgSet::ARE_WE_ADMIN
  end

  def can_change(algset)
    owned_by_user = @login&.db_id && (@login.db_id == algset.wca_user_data_id)
    owned_by_user || AlgSet::ARE_WE_ADMIN
  end

  def compute
    params[:ids].split(',').each { |id| AlgSet.find(id).save_cache }
    render json: { success: :true }
  rescue  Exception => e
    render json: { error: e.message }
  end

  def algset_params(more_params = {})
    params.require(:alg_set).permit(:name, :description, :subset, :algs).merge(more_params)
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
