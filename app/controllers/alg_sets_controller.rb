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
    @algset = AlgSet.find(params[:id])

    # recompute_cache = (@algset.algs != algset_params[:algs])

    if @algset.update_attributes(algset_params)
      flash[:success] = "Profile updated"
      redirect_to @algset
    else
      render 'edit'
    end
  end


  private

  def algset_params
    params.require(:alg_set).permit(:name, :algs)
  end
end
