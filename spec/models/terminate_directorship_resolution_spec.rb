require 'spec_helper'

describe TerminateDirectorshipResolution do

  describe 'director_id attribute' do
    it 'can be written to and read from' do
      organisation = Coop.make!
      director = organisation.directors.make!(:director)

      resolution = organisation.terminate_directorship_resolutions.make

      expect{resolution.director_id = director.id}.to_not raise_error
      resolution.save!
      resolution.reload
      expect(resolution.director_id).to eq(director.id)
    end

    it 'returns nil when no directorship_id has been set yet' do
      expect(TerminateDirectorshipResolution.new.director_id).to be_nil
    end
  end

  it 'has a directorship attribute' do
    organisation = Coop.make!
    director = organisation.directors.make!(:director)
    directorship = director.directorship

    resolution = organisation.terminate_directorship_resolutions.make

    expect{resolution.directorship = directorship}.to_not raise_error
    resolution.save!
    resolution.reload
    expect(resolution.directorship).to eq(directorship)
  end

  describe 'enacting' do
    it 'ends the directorship' do
      organisation = Coop.make!
      director = organisation.directors.make!(:director)
      directorship = director.directorship

      resolution = organisation.terminate_directorship_resolutions.make(directorship_id: directorship.id)
      resolution.force_passed = true

      resolution.close!

      directorship.reload
      expect(directorship).to be_ended
    end
  end

end
