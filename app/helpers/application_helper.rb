module ApplicationHelper

# Returns the full title on a per-page basis.
 def full_title(page_title)
  base_title = "La Fleche du Temps"
  if page_title.empty?
   base_title
  else
   "#{base_title} | #{page_title}"
  end
 end

def approve_link_text(approvable)
	approvable.approved ? 'Un-approve' : 'Approve'
end


end
