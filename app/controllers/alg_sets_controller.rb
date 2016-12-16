# frozen_string_literal: true

class AlgSetsController < ApplicationController
  def index
    setup_leftbar
    @list_classes = "algset-list size-#{@text_size}"
    @all_sets = AlgSet.all.map(&:computing_off).sort_by {|as| [as.predefined ? 0 : 1, as.subset, as.algs.length] }
    @all_sets.each { |as| as.editable_by_this_user = can_change(as) }
    @to_compute = @all_sets.reject(&:computed).map(&:id).join(',')
  end

  def new
    raise "Not allowed to create Algset" unless can_create

    setup_leftbar
    @algset = AlgSet.new
  end

  def create
    raise "Not allowed to create Algset" unless can_create

    setup_leftbar
    more_params = @login ? {wca_user_id: @login.db_id} : {predefined: true}
    @algset = AlgSet.new(algset_params(more_params))
    if @algset.save
      flash[:success] = "Alg set created!"
      redirect_to alg_sets_path
    else
      render new_alg_set_path
    end
  end

  def destroy
    algset = AlgSet.find(params[:id])
    raise "Not allowed to delete Algset #{algset.id}" unless can_change(algset)

    flash[:success] = "Algset '#{algset.name}' deleted"
    algset.destroy
    redirect_to alg_sets_url
  end

  def show
    @algset = AlgSet.find(params[:id]).computing_off
  end

  def edit
    setup_leftbar
    @algset = AlgSet.find(params[:id])
    raise "Not allowed to edit Algset #{@algset.id}" unless can_change(@algset)
  end

  def update
    setup_leftbar
    @algset = AlgSet.find(params[:id]).computing_off
    raise "Not allowed to update Algset #{@algset.id}" unless can_change(@algset)

    algs_result = AlgSetsController::alter_algs(@algset, params[:add_algs], params[:remove_algs])
    unless algs_result[:errors].present?
      more_params = (algs_result[:new_algs] ? {algs: algs_result[:new_algs], _cached_data: nil} : {})
      @algset.update_attributes(algset_params(more_params))
    end

    if @algset.errors.blank?
      flash[:success] = algs_result[:summary] ||  "Algset updated"
      redirect_to alg_sets_path
    else
      params[:alg_set][:add_algs] = params[:add_algs]
      render 'edit'
    end
  end

  def can_create
    @login || AlgSet::ARE_WE_ADMIN
  end

  def can_change(algset)
    owned_by_user = @login&.db_id && (@login.db_id == algset.wca_user_id)
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

    (add_malgs + remove_malgs).each do |user_ma|
      errors << "Bad alg '#{user_ma}'" unless MirrorAlgs.combined_name_for(user_ma)
    end

    add_malgs = add_malgs.map{|ma| MirrorAlgs.combined_name_for(ma)}
    remove_malgs = remove_malgs.map{|ma| MirrorAlgs.combined_name_for(ma)}

    remove_malgs.each do |user_ma|
      errors << "'#{user_ma}' is not in this algset" unless old_malgs.include?(user_ma) || user_ma.blank?
    end

    if errors.empty?
      summary = (add_malgs.present? ? "Added #{add_malgs.join(', ')}" : "") +(remove_malgs.present? ? " Removed #{remove_malgs.join(', ')}" : "")
      return { new_algs: (old_malgs + add_malgs - remove_malgs).sort.join(' '), summary: summary }
    else
      errors.each { |error| algset.errors.add(:base, error)}
      return { errors: algset.errors.full_messages}
    end
  end
end
