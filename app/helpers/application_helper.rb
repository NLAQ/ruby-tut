module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title title = ""
    @base_title = "Ruby on Rails Tuturial Sample App"
    title.empty? ? @base_title : @base_title + " | " + title
  end
end
