require 'rails_helper'

RSpec.describe WcaUser, :type => :model do

  it 'create_or_update' do
    create_result = WcaUser.create_or_update(14, '2016XYZU14', 'Xavier Zoom')

    data = WcaUser.find_by!(wca_db_id: 14)
    expect(data.wca_id).to eq('2016XYZU14')
    expect(data.full_name).to eq('Xavier Zoom')

    update_result = WcaUser.create_or_update(14, '2016ABCU14', 'Anders Carlsson')

    data = WcaUser.find_by!(wca_db_id: 14)
    expect(data.wca_id).to eq('2016ABCU14')
    expect(data.full_name).to eq('Anders Carlsson')

    expect(create_result).to eq(update_result)
  end
end