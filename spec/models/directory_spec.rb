require 'rails_helper'

RSpec.describe Directory, type: :model do
  let(:first_user) { create_dummy_user identifiable_claim: 'github|1234567890' }
  let(:second_user) { create_dummy_user identifiable_claim: 'github|0987654321' }

  context 'when creating directory' do

    context 'no user' do
      it 'fails if missing' do
        dir = Directory.create(name: '', parent: nil)
        expect(dir.valid?).to eq(false)
        expect(dir.errors.messages[:user]).to(
            match_array ['must exist']
        )
      end
    end

    context 'root Directory' do
      it 'fails if non-empty \'name\'' do
        dir = first_user.build_directory(
            name: 'non-empty',
            parent: nil
        )
        expect(dir.valid?).to eq(false)
        expect(dir.errors.messages[:name]).to(
            match_array ['value must be empty for root directory']
        )
      end
    end

    context 'empty \'name\'' do
      it 'fails if non-root Directory' do
        dir = first_user.build_directory(
            name: '',
            parent: first_user.directory
        )
        expect(dir.valid?).to eq(false)
        expect(dir.errors.messages[:name]).to(
            match_array ['value must be a valid directory name']
        )
      end
    end
  end

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
          match_array ['directory must have a parent that is part of the same user\'s tree']
      )
    end

    it 'does not show error about duplicate sibling names' do
      first_user.build_directory(
          name: 'subdirectory',
          parent: first_user.directory
      )
      second_user_directory = second_user.build_directory(
          name: 'subdirectory',
          parent: first_user.directory
      )
      expect(second_user_directory.valid?).to eq(false)
      expect(second_user_directory.errors.messages[:parent]).to(
          match_array ['directory must have a parent that is part of the same user\'s tree']
      )
      # We expect there to be NO name errors
      expect(second_user_directory.errors.messages[:name]).to(
          match_array []
      )
    end
  end
end