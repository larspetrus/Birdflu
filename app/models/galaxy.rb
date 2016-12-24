# frozen_string_literal: true

class Galaxy < ActiveRecord::Base
  belongs_to :wca_user
  has_many :stars

  validates :starred_type, inclusion: { in: %w(raw_alg combo_alg)}

  def self.make(wca_user_id, style, alg_ids, type = 'raw_alg')
    self.create!(wca_user_id: wca_user_id, style: style, starred_type: type).tap do |new_galaxy|
      alg_ids.each { |alg_id| new_galaxy.add(alg_id) }
    end
  end

  def self.star_styles_for(wca_user_id, alg_id, type)
    Galaxy.joins(:stars).where(wca_user_id: wca_user_id, starred_type: type, stars: {starred_id: alg_id}).pluck(:style).sort
  end

  def self.star_styles_by_alg(wca_user_id, alg_ids, type)
    Hash.new { |hash, key| hash[key] = []}.tap do |result|
      pairs = Galaxy.joins(:stars).where(wca_user_id: wca_user_id, starred_type: type, stars: {starred_id: alg_ids}).pluck(:starred_id, :style)
      pairs.sort.each{|pair| result[pair.first] << pair.last }
    end
  end

  def alg_ids
    stars.pluck(:starred_id)
  end

  def toggle(alg_id)
    if include?(alg_id)
      remove(alg_id)
    else
      add(alg_id)
    end
  end

  def add(alg_id)
    stars.create!(starred_id: alg_id)
  end

  def remove(alg_id)
    Star.delete_all(galaxy_id: id, starred_id: alg_id)
  end

  def include?(id)
    stars.exists?(starred_id: id)
  end

  def css_class
    prefix = (starred_type == 'raw_alg' ? 'star' : 'cstar')
    prefix+style.to_s
  end

  def to_s
    "Galaxy: user: #{wca_user_id} style: #{style} #{starred_type}"
  end
end