# encoding: utf-8

require 'redmine'
#require 'uri'

Redmine::Plugin.register :redmine_wikiapproval do

  name 'Redmine wiki aproval plugin'
  author '5inf'
  description 'This macro provides means for propperly formatting windows file links'
  version '0.0.0'
  url 'https://github.com/5inf/redmine_wikiapproval'
  author_url 'https://github.com/5inf/'

  Redmine::WikiFormatting::Macros.register do
  desc <<-DESCRIPTION
        This macro provides means for

  DESCRIPTION

macro :approvepage do |obj, args, text|
args, options = extract_macro_options(args, :approved)

        if obj.is_a?(WikiContent) # || obj.is_a?(WikiContent::Version)

                page=obj

                out = "".html_safe

                lastapproved=""

        #       out << page.to_s

        ##      out << page.title
        #       out << page.page ##this it the actual wiki page ojbect. the "page" is only the inner wiki content object.
        #       out << page.page.title
        #       out << page.text
        #       out << page.project

        #       out << page.versions.last.text
        #       out << page.versions.last.version.to_s
        #       out << page.versions.last.comments
        #       out << page.versions.last.author
        #       out << page.versions.last.updated_on.to_s
        #       out << page.versions[page.versions.size-3].version.to_s

                if page.versions.last.comments.starts_with?('Freigegeben:')
                        out <<content_tag(:p, safe_join(["Status der Arbeitsanweisung: ", content_tag(:span, "Freigegeben", :style=>"color:green"), " by ",content_tag(:span,safe_jo$
                else
                        out <<content_tag(:p, safe_join(["Status der Arbeitsanweisung: ", content_tag(:span, "Nicht freigegeben", :style=>"color:red"), " by ",content_tag(:span,saf$

                        for i in (page.versions.size-1).downto(0)
#                               out << content_tag(:p, page.versions[i].version.to_s+", "+page.versions[i].comments)
                                if page.versions[i].comments.starts_with?('Freigegeben:')
#                                       lastapproved=(i+1).to_s
                                        lastapproved=page.versions[i].version.to_s
                                        break
                                end
                        end
                        if lastapproved != ""
                                out << "Letzte Freigegebene Version ist: "
                                out << link_to(lastapproved+' von author, geändert an datum.', :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version =$
                                #https://github.com/redmine/redmine/blob/master/app/views/wiki/history.html.erb
                                #               out << link_to(page.page.version, :action => 'show', :id=>page.page.title, :project_id => page.page.project, :version => page.page.v$

                        #link_to ver.version, :action => 'show', :id => @page.title, :project_id => @page.project, :version => ver.version
                        else
                                out << "Es gibt noch keine Freigegebene Version."
                        end
                end
                #out << content_tag(:span,safe_join([avatar(obj.author, size: 14), ' ', link_to_user(obj.author)]),class: 'last-updated-by')
                #out << content_tag(:span,l(:label_updated_time, time_tag(page.updated_on)).html_safe, class: 'last-updated-at')
                out

        elsif  obj.is_a?(WikiContent::Version)
                out = "".html_safe
                 out << "Dies ist möglicherweise nicht die neuste freigebene Version."
                out
        else
                 raise 'This macro can be called from wiki pages only.'
        end

    end
#Plugin end
  end
end

