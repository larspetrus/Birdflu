# frozen_string_literal: true

class AlgSetsController < ApplicationController
  def index
    setup_leftbar
    @list_classes = "algset-list size-#{@text_size}"
    @all_sets = AlgSet.all.map(&:data_only).sort_by {|as| [as.predefined ? 0 : 1, as.subset, as.algs.length] }
    @all_sets.each { |as| as.editable_by_this_user = can_change(as) }
    @to_compute = @all_sets.reject(&:has_facts).map(&:id).join(',')
  end

  def new
    raise "Not allowed to create Algset" unless can_create

    setup_leftbar
    @algset = AlgSet.new
  end

  def create
    raise "Not allowed to create Algset" unless can_create

    setup_leftbar

    params[:alg_set][:algs] = params[:alg_set][:algs].split(' ').map{|alg| MirrorAlgs.combined_name_for(alg) || alg}.join(' ')
    @algset = AlgSet.new(algset_params(@login ? {wca_user_id: @login.db_id} : {predefined: true}))
    if @algset.save
      flash[:success] = "Alg set created"
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
    @algset = AlgSet.find(params[:id]).data_only
  end

  def edit
    setup_leftbar
    @algset = AlgSet.find(params[:id])
    raise "Not allowed to edit Algset #{@algset.id}" unless can_change(@algset)
  end

  def update
    setup_leftbar
    @algset = AlgSet.find(params[:id]).data_only
    raise "Not allowed to update Algset #{@algset.id}" unless can_change(@algset)

    alterations = AlgSetsController::alter_algs(@algset, params[:add_algs], params[:remove_algs])
    if alterations[:replacement_algs]
      @algset.replace_algs(alterations[:replacement_algs]).save!
    end

    if @algset.errors.blank?
      flash[:success] = alterations[:summary] || "Algset updated"
      redirect_to alg_sets_path
    else
      render 'edit'
    end
  end

  def algs
    setup_leftbar
    @algset = AlgSet.find(params[:id])
    @mirror_algs = @algset.mirror_algs.sort_by{|ma| ma.algs[0].position.cop }
    @list_classes = "bflist mirroralg-list size-#{@text_size}-wc"
    @columns = Column.named([:name_link, :cop, :eop, :alg, :show])
    use_svgs
  end


  def can_create
    @login || AlgSet::ARE_WE_ADMIN
  end

  def can_change(algset)
    is_owned_by_user = @login&.db_id && (@login.db_id == algset.wca_user_id)
    is_owned_by_user || AlgSet::ARE_WE_ADMIN
  end

  def compute
    params[:ids].split(',').each { |id| AlgSet.find(id).fact.compute.save! }
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
      summary = (add_malgs.present? ? "Added "+add_malgs.join(', ') : "") + (remove_malgs.present? ? " Removed "+remove_malgs.join(', ') : "")
      return { replacement_algs: (old_malgs + add_malgs - remove_malgs).sort.join(' '), summary: summary }
    else
      errors.each { |error| algset.errors.add(:base, error)}
      return { errors: algset.errors.full_messages}
    end
  end
end
