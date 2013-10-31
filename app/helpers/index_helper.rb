module IndexHelper
	def is_active?(page_name)
    'class=active' if params[:controller] == page_name
  end
end
