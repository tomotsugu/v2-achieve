require 'rails_helper'

  describe Blog do
    # タイトルがあれば有効な状態であること
    it "is valid with title" do
      blog = Blog.new(title: 'Aaron')
      expect(blog).to be_valid
    end

    #タイトルがなければ無効であること
    it "is invalid without a title" do
      blog = Blog.new
      expect(blog).not_to be_valid
      blog.valid?
      expect(blog.errors[:title]).to include("を入力してください")
    end
  end