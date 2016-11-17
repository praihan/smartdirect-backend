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
        dir = Directory.create(
            name: 'non-empty',
            user_id: first_user.id,
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
        dir = Directory.create(
            name: '',
            user_id: first_user.id,
            parent: first_user.directory
        )
        expect(dir.valid?).to eq(false)
        expect(dir.errors.messages[:name]).to(
            match_array ['value must be a valid directory name']
        )
      end
    end
  end

  context 'when cyclical tree' do
    it 'fails if cycling on own parent' do
      dir1 = Directory.create(
          name: 'a',
          user_id: first_user.id,
          parent: first_user.directory
      )
      dir2 = Directory.create(
          name: 'b',
          user_id: first_user.id,
          parent: dir1
      )
      expect(dir1.valid?).to be true
      expect(dir2.valid?).to be true

      # Bad stuff
      dir1.parent = dir2

      expect(dir1.valid?).to be false
      expect(dir1.errors.messages[:parent_id]).to(
          match_array ['You cannot add an ancestor as a descendant']
      )
    end

    it 'fails if cycling on grand parent' do
      dir1 = Directory.create(
          name: 'a',
          user_id: first_user.id,
          parent: first_user.directory
      )
      dir2 = Directory.create(
          name: 'b',
          user_id: first_user.id,
          parent: dir1
      )
      dir3 = Directory.create(
          name: 'c',
          user_id: first_user.id,
          parent: dir2
      )
      expect(dir1.valid?).to be true
      expect(dir2.valid?).to be true
      expect(dir3.valid?).to be true

      # Bad stuff
      dir1.parent = dir3

      expect(dir1.valid?).to be false
      expect(dir1.errors.messages[:parent_id]).to(
          match_array ['You cannot add an ancestor as a descendant']
      )
    end
  end

  context 'when mixing directories from two users' do
    it 'fails validation' do
      first_user_directory = Directory.create(
          name: 'subdirectory',
          user_id: first_user.id,
          parent: first_user.directory
      )
      second_user_directory = Directory.create(
          name: 'subdirectory',
          user_id: second_user.id,
          parent: first_user_directory
      )
      expect(second_user_directory.valid?).to eq(false)
      expect(second_user_directory.errors.messages[:parent]).to(
          match_array ['directory must have a parent that is part of the same user\'s tree']
      )
    end

    it 'does not show error about duplicate sibling names' do
      Directory.create(
          name: 'subdirectory',
          user_id: first_user.id,
          parent: first_user.directory
      )
      second_user_directory = Directory.create(
          name: 'subdirectory',
          user_id: second_user.id,
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