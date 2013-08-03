module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def get_all_pages
		StaticPage.footer	
  end

  def previous_experiences(experiences)
    i = 1
    arr_exp = []
    experiences.each do |f|
      if i != 1
        arr_exp << f[:company_name]
      end  
      i = i + 1
    end
    arr_exp.join(',')  	
  end
    
end
