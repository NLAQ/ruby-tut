class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    byebug
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.paginate page: params[:page]
    byebug
  end

  def help; end
end
