module ShowcaseHelper

  def create_favorite_action(image_id)
    "/showcase/favorite_photo?img_id=#{image_id}"
  end
end
