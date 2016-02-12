require 'rails_helper'

RSpec.describe WcaUserData, :type => :model do

  it 'create_or_update' do
    WcaUserData.create_or_update(14, '2016XYZU14', 'Xavier Zoom')

    data = WcaUserData.find_by!(wca_db_id: 14)
    expect(data.wca_id).to eq('2016XYZU14')
    expect(data.full_name).to eq('Xavier Zoom')

    WcaUserData.create_or_update(14, '2016ABCU14', 'Anders Carlsson')

    data = WcaUserData.find_by!(wca_db_id: 14)
    expect(data.wca_id).to eq('2016ABCU14')
    expect(data.full_name).to eq('Anders Carlsson')
  end
end