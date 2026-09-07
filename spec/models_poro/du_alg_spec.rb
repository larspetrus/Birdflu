describe 'DuAlg' do
  it 'can be string based' do
    da = DuAlg.new("F B' U2")
    expect(da.as_str).to eq("F B' U2")
    expect(da.as_list).to eq(%w[F B' U2])
  end

  it 'can be Array based' do
    da = DuAlg.new(%w[F B' U2])
    expect(da.as_str).to eq("F B' U2")
    expect(da.as_list).to eq(%w[F B' U2])
  end

  it 'can be DuAlg based' do
    da1 = DuAlg.new(%w[F B' U2])
    da2 = DuAlg.new(da1)
    expect(da2.as_str).to eq("F B' U2")
    expect(da2.as_list).to eq(%w[F B' U2])

    expect(da1.equal?(da2))  # They are the same object!
  end

  it "is smart about equality" do
    da = DuAlg.new("F B' x2")

    # Can compare to strings, Arrays and DuAlg objects
    expect(da).to eq(DuAlg.new("F B' x2"))
    expect(da).to eq("F B' x2")
    expect(da).to eq(%w(F B' x2))
  end

  it "does validation" do
    expect { DuAlg.new("F B' x2") }.not_to raise_error
    expect { DuAlg.new("F B' x2", MoveSet::BRDFLU) }.to raise_error "Invalid move: x2"
    expect { DuAlg.new("F B' x2 E'", MoveSet::XYZ) }.to raise_error "Invalid move: E'"
    expect { DuAlg.new("F B' x7") }.to raise_error "Invalid move: x7"
    expect { DuAlg.new("F B' x''") }.to raise_error "Invalid move: x''"
  end
end
