module ApplicationHelper
  # Return the full title on the per-page
  def full_title page_title
    base_title = I18n.t "title_web"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
