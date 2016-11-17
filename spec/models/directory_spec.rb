require 'rails_helper'

RSpec.describe Directory, type: :model do
  let(:first_user) { create_dummy_user identifiable_claim: 'github|1234567890' }
  let(:second_user) { create_dummy_user identifiable_claim: 'github|0987654321' }

  context 'when mixing directories from two users' do
    it 'fails validation' do
      first_user_directory = first_user.build_directory(
          name: 'subdirectory',
          parent: first_user.directory
      )
      second_user_directory = second_user.build_directory(
          name: 'subdirectory',
          parent: first_user_directory
      )
      expect(second_user_directory.valid?).to eq(false)
      expect(second_user_directory.errors.messages[:parent]).to(
          match_array(['directory must have a parent that is part of the same user\'s tree'])
      )
    end
  end
end