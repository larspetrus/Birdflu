# frozen_string_literal: true

class WcaUser < ActiveRecord::Base

  def self.create_or_update(wca_db_id, wca_id, full_name)
    db_record = self.find_by(wca_db_id: wca_db_id)
    if db_record
      db_record.update(wca_id: wca_id, full_name: full_name)
    else
      db_record = self.create!(wca_db_id: wca_db_id, wca_id: wca_id, full_name: full_name)
    end

    db_record.id
  end
end