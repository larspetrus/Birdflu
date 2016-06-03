# frozen_string_literal: true

class WcaUserData < ActiveRecord::Base

  def self.create_or_update(wca_db_id, wca_id, full_name)
    db_record = self.find_by(wca_db_id: wca_db_id)
    if db_record
      db_record.update(wca_id: wca_id, full_name: full_name)
    else
      self.create(wca_db_id: wca_db_id, wca_id: wca_id, full_name: full_name)
    end
  end
end