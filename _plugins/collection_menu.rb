=begin

Commande : gemini 

donner le code ruby pour créer un plugin jekyll qui permet d'afficher 
un menu des page d'une collection

=end

require 'pp'


module Jekyll
    class CollectionMenu < Jekyll::Generator
      def generate(site)

        #  collection = ["posts", #<Jekyll::Collection @label=posts docs=[]>]
        # pp site.collections
        chapitres_collection  = site.collections.detect { |collection| collection[0] == "chapitres" }
        parties_collection  = site.collections.detect { |collection| collection[0] == "parties" }
 

       

        menu_items = chapitres_collection[1].docs.map do |doc|
          {
            "label" => doc.data["title"],
            "url" => doc.url,
            "partie" => doc.data["partie"] 
          }
        end
  

        menu_items = menu_items.group_by { |item| item["partie"] }



        site.data["collection_menus"] ||= {}
        site.data["collection_menus"] = menu_items

      end
    end
  end
  