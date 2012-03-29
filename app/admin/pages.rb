ActiveAdmin.register Page do
  index do |post|
    column :title do |page|
      link_to(page.title, edit_admin_page_path(page))
    end
    column :slug
    column 'Actions' do |page|
      ul do
        li link_to('View', page_path(page.slug))
        li link_to('Edit', edit_admin_page_path(page))
        li link_to('Delete', admin_page_path(page), method: :delete, confirm: 'Really delete?')
      end
    end
  end

  form partial: 'form'

  controller do
    cache_sweeper :page_sweeper
  end

  sidebar :help do
    ul do
      li link_to('Textile Reference', 'http://redcloth.org/hobix.com/textile/')
    end
  end
end
