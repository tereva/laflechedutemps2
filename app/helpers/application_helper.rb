module ApplicationHelper

# Returns the full title on a per-page basis.
 def full_title(title)
  base_title = "KRONOFIL"
  if title.empty?
   base_title
  else
   "#{base_title} | #{title}"
  end
 end

def full_meta_desc(meta_desc)
  base_desc = "KRONOFIL: la fleche du temps"
  if meta_desc.empty?
   base_desc
  else
   "#{base_desc} | #{meta_desc}"
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
