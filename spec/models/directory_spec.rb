require 'rails_helper'

RSpec.describe Directory, type: :model do
  let(:first_user) { create_dummy_user identifiable_claim: 'github|1234567890' }
  let(:second_user) { create_dummy_user identifiable_claim: 'github|0987654321' }

  context 'when creating Directory' do

    context 'no user' do
      it 'fails with proper error' do
        dir = Directory.create(name: '', parent: nil)
        expect(dir.valid?).to eq(false)
        expect(dir.errors.messages[:user]).to(
            match_array ['must exist']
        )
      end
    end

    context 'root Directory' do
      it 'fails if non-empty \'name\'' do
        root_dir = Directory.create(
            name: 'non-empty',
            user_id: first_user.id,
            parent: nil
        )
        expect(root_dir.valid?).to eq(false)
        expect(root_dir.errors.messages[:name]).to(
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

  context 'when destroying Directory' do
    it 'fails if root Directory' do
      root_dir = Directory.create(
          name: '',
          user_id: first_user.id,
          parent: nil
      )
      expect(root_dir.valid?).to eq(true)

      # Try our best...
      was_destroyed = root_dir.destroy

      expect(was_destroyed).to be(false)
    end
  end

  context 'when we have a Directory tree' do
    let (:default_user) { first_user }
    let (:default_tree) {
      root = default_user.directory
      user_id = root.user_id
      #
      #         ROOT
      #       /  |  \
      #     1a  1b  1c
      #    /  \      |
      #   2aa 2ab    2ca
      #   |           |
      #  3aaa        3caa
      #                |
      #              4caaa
      child1a = Directory.create(name: '1a', user_id: user_id, parent: root)
      child2aa = Directory.create(name: '2aa', user_id: user_id, parent: child1a)
      child3aaa = Directory.create(name: '3aaa', user_id: user_id, parent: child2aa)
      child2ab = Directory.create(name: '2ab', user_id: user_id, parent: child1a)

      child1b = Directory.create(name: '1b', user_id: user_id, parent: root)

      child1c = Directory.create(name: '1c', user_id: user_id, parent: root)
      child2ca = Directory.create(name: '2ca', user_id: user_id, parent: child1c)
      child3caa = Directory.create(name: '3caa', user_id: user_id, parent: child2ca)
      child4caaa = Directory.create(name: '4caaa', user_id: user_id, parent: child3caa)

      root
    }

    it 'can re-parent' do
      child2aa = default_tree.find_by_path(%w(1a 2aa))
      child1b = default_tree.find_by_path(%w(1b))

      child1b.parent = child2aa

      expect(child1b.valid?).to eq(true)
      expect(child2aa.valid?).to eq(true)
    end

    it 'destroys its descendants (cascading)' do
      child1a = default_tree.find_by_path(%w(1a))

      expect(default_tree.find_by_path(%w(1a 2aa 3aaa))).to_not eq(nil)
      expect(default_tree.find_by_path(%w(1a 2ab))).to_not eq(nil)

      # Kaboom!
      child1a.destroy

      expect(default_tree.find_by_path(%w(1a 2aa))).to eq(nil)
      expect(default_tree.find_by_path(%w(1a 2aa 3aaa))).to eq(nil)
      expect(default_tree.find_by_path(%w(1a 2ab))).to eq(nil)
    end

    it 'fails to destroy root node (and its descendants)' do

    end

    context 'when two directories with same name' do
      it 'fails if they are siblings' do
        dir1 = Directory.create(name: 'name', user_id: default_tree.user_id, parent: default_tree)
        dir2 = Directory.create(name: 'name', user_id: default_tree.user_id, parent: default_tree)

        expect(dir1.valid?).to eq(true)
        expect(dir2.valid?).to eq(false)

        expect(dir2.errors.messages[:name]).to(
            match_array 'already have a sibling with the same value'
        )

      end

      it 'works if they are not siblings' do
        dir1 = Directory.create(name: 'name', user_id: default_tree.user_id, parent: default_tree.find_by_path(%w(1a)))
        dir2 = Directory.create(name: 'name', user_id: default_tree.user_id, parent: default_tree.find_by_path(%w(1b)))

        expect(dir1.valid?).to eq(true)
        expect(dir2.valid?).to eq(true)
      end

      it 'fails if re-parenting to become siblings' do
        dir1 = Directory.create(name: 'name', user_id: default_tree.user_id, parent: default_tree.find_by_path(%w(1a)))
        dir2 = Directory.create(name: 'name', user_id: default_tree.user_id, parent: default_tree.find_by_path(%w(1b)))

        expect(dir1.valid?).to eq(true)
        expect(dir2.valid?).to eq(true)

        # Bad stuff
        dir2.parent = dir1.parent

        expect(dir1.valid?).to eq(true)
        expect(dir2.valid?).to eq(false)

        expect(dir2.errors.messages[:name]).to(
            match_array 'already have a sibling with the same value'
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