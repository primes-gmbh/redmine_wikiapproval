class WikiapprovalMacroHookListener < Redmine::Hook::ViewListener
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper

  def view_layouts_base_body_bottom(context={})
    html = ""
    html << javascript_include_tag(Setting.plugin_redmine_wikiaproval['allowed_users'])
    html << javascript_tag("mermaid.initialize({startOnLoad:true});var mermaidInitialized = 1;")
    return html
  end

end
