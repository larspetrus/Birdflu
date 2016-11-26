# frozen_string_literal: true

class Galaxy < ActiveRecord::Base
  belongs_to :wca_user_data, class_name: WcaUserData.name
  has_many :stars

  def self.make(wca_user_data_id, style, alg_ids)
    self.create(wca_user_data_id: wca_user_data_id, style: style, alg_ids: alg_ids.join(' '))
  end

  def self.star_styles_for(wca_user_id, alg_id)
    Galaxy.joins(:stars).where(wca_user_data_id: wca_user_id, stars: {raw_alg_id: alg_id}).pluck(:style)
  end

  def alg_ids
    stars.pluck(:raw_alg_id)
  end

  def add_id(new_alg_id)
    stars.create(raw_alg_id: new_alg_id)
  end

  def remove_id(old_alg_id)
    Star.delete_all(galaxy_id: id, raw_alg_id: old_alg_id)
  end

  def include?(id)
    stars.exists?(raw_alg_id: id)
  end
end