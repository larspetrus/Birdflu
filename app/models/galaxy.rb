# frozen_string_literal: true

class Galaxy < ActiveRecord::Base
  belongs_to :wca_user
  has_many :stars

  def self.make(wca_user_id, style, alg_ids)
    self.create(wca_user_id: wca_user_id, style: style).tap do |new_galaxy|
      alg_ids.each { |alg_id| new_galaxy.add(alg_id) }
    end
  end

  def self.star_styles_for(wca_user_id, alg_id)
    Galaxy.joins(:stars).where(wca_user_id: wca_user_id, stars: {raw_alg_id: alg_id}).pluck(:style).sort
  end

  def self.star_styles_by_alg(wca_user_id, alg_ids)
    Hash.new { |hash, key| hash[key] = []}.tap do |result|
      pairs = Galaxy.joins(:stars).where(wca_user_id: wca_user_id, stars: {raw_alg_id: alg_ids}).pluck(:raw_alg_id, :style)
      pairs.sort.each{|pair| result[pair.first] << pair.last }
    end
  end

  def alg_ids
    stars.pluck(:raw_alg_id)
  end

  def toggle(alg_id)
    if include?(alg_id)
      remove(alg_id)
    else
      add(alg_id)
    end
  end

  def add(alg_id)
    stars.create(raw_alg_id: alg_id)
  end

  def remove(alg_id)
    Star.delete_all(galaxy_id: id, raw_alg_id: alg_id)
  end

  def include?(id)
    stars.exists?(raw_alg_id: id)
  end
end