# encoding: utf-8

require 'redmine'
#require 'uri'
#require wikiapproval_macro_hook
 
Redmine::Plugin.register :redmine_wikiapproval do

	name 'Redmine wiki aproval plugin'
	author '5inf'
	description 'This plugin provides a macro for marking revisions of wiki pages as approved and displaying the status.'
	version '0.0.0'
	url 'https://github.com/primes-gmbh/redmine_wikiapproval'
	author_url 'https://github.com/5inf/'

	Redmine::WikiFormatting::Macros.register do
	desc <<-DESCRIPTION
This macro displays the approval status of the currently displayed revision of a wiki page.
DESCRIPTION

# settings :default => { 'allowed_users' => '1' },	:partial => 'settings/redmine_wikiapproval_settings'

	macro :approvepage do |obj, args, text|
		args, options = extract_macro_options(args, :date)

		if obj.is_a?(WikiContent) # || obj.is_a?(WikiContentVersion)

			page=obj

			out = "".html_safe

			lastapprovedindex=""
			lastapprovedversion=-1

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
					if page.versions[i].comments.starts_with?('Freigegeben:') && page.versions[i].version > lastapprovedversion
						lastapprovedindex=i
						lastapprovedversion=page.versions[i].version
					end
				end
				if lastapprovedindex != ""
                                        out << "Die letzte freigegebene Revision ist: "
                                        out << link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version => lastapprovedversion.to_s)
                                        out << " von ".html_safe
                                        out << link_to_user(page.versions[lastapprovedindex].author)
                                        out << " vor ".html_safe
                                        out << time_tag(page.versions[lastapprovedindex].updated_on)
                                        out << ". ".html_safe
                                        out << content_tag(:p, safe_join(["Für produktive Arbeiten unbedingt die letzte freigegebene Revision verwenden! Dazu hier klicken: ", link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version => lastapprovedversion.to_s), ". " ]), :style=>"color:red")
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

			elsif    obj.is_a?(WikiContentVersion)
                                out = "".html_safe
                               #out << "Revision "
                               #out << obj.version.to_s
                               #out << obj.previous.to_s
                               #out << obj.next.to_s
                               #out << obj.comments
                               #out << obj.page.content.versions


                               #out << obj.page.content.versions[0].version.to_s
                               #out << obj.page.title
                               #out << obj.page.content.project

                               lastapprovedindex=""
                               lastapprovedversion=-1


                               for i in (obj.page.content.versions.size-1).downto(0)
                                       #out << content_tag(:p, obj.page.content.versions[i].version.to_s+", "+obj.page.content.versions[i].comments)
                                       if obj.page.content.versions[i].comments.starts_with?('Freigegeben:') && obj.page.content.versions[i].version > lastapprovedversion
                                               lastapprovedindex=i
                                               lastapprovedversion=obj.page.content.versions[i].version
                                       end
                               end

                               #out << " ÄÄÄÄ lastapprovedindex: " << lastapprovedindex.to_s
                               #out << " obj.version" << obj.version.to_s <<  "ÄÄÄÄ"

                               if obj.comments.starts_with?('Freigegeben:')
                                       if (obj.version - 1) == lastapprovedindex
                                               out << content_tag(:p, "Dies ist die neueste freigegebene Revision.", :style=>"color:green")
                                       else
                                               out << content_tag(:p, safe_join(["Dies ist eine veraltete freigegebene Revision! Die neueste freigegebene Revision ist ", link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>obj.page.title, :project_id => obj.page.content.project, :version => lastapprovedversion.to_s)]), :style=>"color:red")
                                               out << content_tag(:p, safe_join(["Für produktive Arbeiten unbedingt die letzte freigegebene Revision verwenden! Dazu hier klicken: ", link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>obj.page.title, :project_id => obj.page.content.project, :version => lastapprovedversion.to_s), ". " ]), :style=>"color:red")
                                               #out << content_tag(:p, "Dies ist eine veraltete freigegebene Revision! Die neueste freigegebene Revision ist ", :style=>"color:red")
                                               #out << link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>obj.page.title, :project_id => obj.page.content.project, :version => lastapprovedversion.to_s)
                                       end
                               else
                                       if lastapprovedindex != ""
                                               out << content_tag(:p, safe_join(["Diese Revision ist nicht freigegeben! Die neueste freigegebene Revision ist ", link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>obj.page.title, :project_id => obj.page.content.project, :version => lastapprovedversion.to_s)]), :style=>"color:red")
                                               out << content_tag(:p, safe_join(["Für produktive Arbeiten unbedingt die letzte freigegebene Revision verwenden! Dazu hier klicken: ", link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>obj.page.title, :project_id => obj.page.content.project, :version => lastapprovedversion.to_s), ". " ]), :style=>"color:red")
                                                #out << link_to('Revision '+lastapprovedversion.to_s, :action => 'show', :id=>obj.page.title, :project_id => obj.page.content.project, :version => lastapprovedversion.to_s)
                                       else
                                               out << content_tag(:p, "Diese Revision ist nicht freigegeben! Es gibt noch keine freigegebene Revision. Diese Seite darf nicht produktiv verwendet werden!", :style=>"color:red")
                                       end
                               end

                        else
				raise 'This macro can be called from wiki pages only.'
			end
		end
#Plugin end
	end
end

