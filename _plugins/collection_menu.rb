
# Il permet d'afficher la strcutre d'un objet dans la console : pp objet
require 'pp'

module Jekyll
    class CollectionMenu < Jekyll::Generator

      def generate(site)

        puts "Generate menu_items"
        #  collection = ["posts", #<Jekyll::Collection @label=posts docs=[]>]
        # pp site.collections

        # Les collection de l'application
        # chaque élément site.collections est un tableau de deux élément : 0 : label, 1 : collection
        chapters_collection  = site.collections.detect { |collection| collection[0] == "chapters" }[1]
        parts_collection  = site.collections.detect { |collection| collection[0] == "parts" }[1]
 
        # Array of menu items
        menu_items = chapters_collection.docs.map do |doc|
          {
            "label" => doc.data["title"],
            "part" => doc.data["part"],
            "order" => doc.data["order"],
            "url" => doc.url
          }
        end
  


        # Groupe by menu items par part
        menu_items = menu_items.group_by { |item| item["part"] }

        # pp menu_items 

        # # Ajouter les chapter depuis chapters.json
        # menu_items.each do |reference_part, elements|
        #   josn_chapters_part = site.data[reference_part] || {} 
        #   josn_chapters_part.each do |element|
        #       element["label"] ||= element["title"]
        #       element["part"] ||= reference_part
        #       element["order"] ||= 100
        #       element["url"] ||= "/" + element["reference"]
        #   end
        #   if !josn_chapters_part.nil? && !josn_chapters_part.empty?
        #     elements = elements.concat(josn_chapters_part)
        #   end
        # end

        # pp menu_items 

        # Trier les éléments de chaque part par ordre croissant
        menu_items.each do |part, elements|
          elements.sort_by! { |element| element["order"] }
        end


        # enregistrement de menu dans site.data
        site.data["collection_menus"] ||= {}
        site.data["collection_menus"] = menu_items
      end
    end
  end
  


# pp menu_items 
# meu_item = {
#   "introduction" => [
#     { "label" => "Introduction", "part" => "introduction", "order" => 5, "url" => "/index.html" },
#     { "label" => "Présentation du formateur", "part" => "introduction", "order" => 2, "url" => "/présentation-formateur.html" },
#     { "label" => "Déroulement de la formation", "part" => "introduction", "order" => 3, "url" => "/déroulement-formation.html" },
#     { "label" => "Plan du formation", "part" => "introduction", "order" => 4, "url" => "/plan-formation.html" }
  #   ],
#   "découvrir-langages-web" => [
#     { "label" => "découvrir-langages-web", "part" => "découvrir-langages-web", "order" => 1, "url" => "/découvrir-langages-web.html" },
#     { "label" => "Planning", "part" => "découvrir-langages-web", "order" => 2, "url" => "/planning.html" },
#     { "label" => "Mini-projet", "part" => "découvrir-langages-web", "order" => 3, "url" => "/mini-projet-créer-portfolio-personnel.html" }
#   ],
#   # ... (autres sections du hash)
# }