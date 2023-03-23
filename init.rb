# encoding: utf-8

require 'redmine'
#require 'uri'
#require wikiapproval_macro_hook
 
Redmine::Plugin.register :redmine_wikiapproval do

	name 'Redmine wiki aproval plugin'
	author '5inf'
	description 'This plugin provides a macro for marking revisions of wiki pages as approved and displaying the status.'
	version '0.0.0'
	url 'https://github.com/5inf/redmine_wikiapproval'
	author_url 'https://github.com/5inf/'

	Redmine::WikiFormatting::Macros.register do
	desc <<-DESCRIPTION
This macro displays the approval status of the currently displayed revision of a wiki page.
DESCRIPTION

# settings :default => { 'allowed_users' => '1' },	:partial => 'settings/redmine_wikiapproval_settings'

	macro :approvepage do |obj, args, text|
		args, options = extract_macro_options(args, :date)

		if obj.is_a?(WikiContent) # || obj.is_a?(WikiContent::Version)

			page=obj

			out = "".html_safe

			lastapprovedindex=""

			#out << page.to_s

			##out << page.title ## no title object
			#out << page.page ##this it the actual wiki page ojbect. the "page" is only the inner wiki content object.
			#out << page.page.title
			#out << page.text
			#out << page.project

			#out << page.versions.last.text
			#out << page.versions.last.version.to_s
			#out << page.versions.last.comments
			#out << page.versions.last.author
			#out << page.versions.last.updated_on.to_s
			#out << page.versions[page.versions.size-3].version.to_s

			if page.versions.last.comments.starts_with?('Freigegeben:')
				out <<content_tag(:p, safe_join(["Status der Arbeitsanweisung: ", content_tag(:span, "Freigegeben", :style=>"color:green"), " von ",link_to_user(obj.author) , " vor ", time_tag(page.updated_on), ". " ]))
			else
				out <<content_tag(:p, safe_join(["Status der Arbeitsanweisung: ", content_tag(:span, "Nicht freigegeben.", :style=>"color:red"), " Zuletzt geändert von ",link_to_user(obj.author) , " vor ", time_tag(page.updated_on), ". " ]))

				for i in (page.versions.size-1).downto(0)
					#out << content_tag(:p, page.versions[i].version.to_s+", "+page.versions[i].comments)
					if page.versions[i].comments.starts_with?('Freigegeben:')
						#lastapproved=(i+1).to_s
						lastapprovedindex=i#page.versions[i].version.to_s
						break
					end
				end
				if lastapprovedindex != ""
                                        out << "Die letzte freigegebene Revision ist: "
                                        out << link_to('Revision '+page.versions[lastapprovedindex].version.to_s, :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version => page.versions[lastapprovedindex].version.to_s)
                                        out << " von ".html_safe
                                        out << link_to_user(page.versions[lastapprovedindex].author)
                                        out << " vor ".html_safe
                                        out << time_tag(page.versions[lastapprovedindex].updated_on)
                                        out << ". ".html_safe
                                        out << content_tag(:p, safe_join(["Für produktive Arbeiten unbedingt die letzte freigegebene Revision verwenden! Dazu hier klicken: ", link_to('Revision '+page.versions[lastapprovedindex].version.to_s, :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version => page.versions[lastapprovedindex].version.to_s), ". " ]), :style=>"color:red")
                                        #https://github.com/redmine/redmine/blob/master/app/views/wiki/history.html.erb
                                        #out << link_to(page.page.version, :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version => page.page.v

                                        #link_to ver.version, :action => 'show', :id => @page.title, :project_id => @page.project, :version => ver.version
                                else
                                        out << content_tag(:p, "Es gibt noch keine freigegebene Revision. Diese Seite darf nicht produktiv verwendet werden!", :style=>"color:red")
                                end
			end
			#out << content_tag(:span,safe_join([avatar(obj.author, size: 14), ' ', link_to_user(obj.author)]),class: 'last-updated-by')
			#out << content_tag(:span,l(:label_updated_time, time_tag(page.updated_on)).html_safe, class: 'last-updated-at')
			out

			elsif	 obj.is_a?(WikiContent::Version)
				out = "".html_safe
				#out << "Dies ist die neuste freigegebene Revision." # if freigegeben und neuste
				#out << "Die ist eine veraltete Revision. Die neuste freigegebene Revision ist ??." # if freigegeben aber nicht neuste
				#out << "Diese Revision ist nicht freigegeben. Die neuste freigegebene Revision ist ??." #if nicht freigegeben aber neuere freigegeben revision vorhanden
				out << "Diese Revision ist möglicherweise nicht die neuste freigegebene Revision."
				out
			else
				raise 'This macro can be called from wiki pages only.'
			end
		end
#Plugin end
	end
end

