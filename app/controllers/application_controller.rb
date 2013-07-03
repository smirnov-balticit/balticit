class ApplicationController < ActionController::Base
  protect_from_forgery
   
  before_filter :export_i18n_messages,:menu_main 

  def export_i18n_messages
    SimplesIdeias::I18n.export! if Rails.env.development?
  end

  def menu_main
    @menu = [] 
    page= Page.find_by_slug(params['slug'])
    top_menu = page.root.siblings.where(hidden: false) 
    @menu.push(top_menu) if top_menu.any? 
    unless page.root?
      page.ancestors.where(hidden: false).each do |p| 
       @menu.push(p) unless (p == page.root)
      end
    @menu.push(page.siblings.where(hidden: false)) if page.sibling_ids 
    end
    @menu.push(page.children.where(hidden: false)) if page.child_ids 
  end 
end
