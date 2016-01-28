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

def sanitize_filename(filename)
  filename.strip.tap do |name|
    # NOTE: File.basename doesn't work right with Windows paths on Unix
    # get only the filename, not the whole path
    name.sub! /\A.*(\\|\/)/, ''
    # Finally, replace all non alphanumeric, underscore
    # or periods with underscore
    name.gsub! /[^\w\.\-]/, '_'
  end
end


end
