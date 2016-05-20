module ApplicationHelper
  def profile_img(user)
        return image_tag(user.avatar) if user.avatar?
# , alt: user.name
    if user.provider
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url)   
    # , alt: user.name
  end
end
