require 'pp'

module Jekyll
    # Création de menu principale
    class CollectionMenu < Jekyll::Generator

      def debug(message)
        puts message
      end

      def generate(site)

        debug("plugin - génération de menu principale")

        # chaque élément site.collections est un tableau de deux élément : 0 : label, 1 : collection
        chapters_collection  = site.collections.detect { |collection| collection[0] == "chapters" }[1]
        parts_collection  = site.collections.detect { |collection| collection[0] == "parts" }[1]
 
       
        # Add data to chaptyer 
        chapters_collection.docs.each do |chapter|
          chapter.data["next_chapter"]  = "next chapter php"
          chapter.data["previous_chapter"]  = "next chapter php"
        end


        # Array of menu items
        menu_items = chapters_collection.docs.map do |doc|
          {
            "label" => doc.data["title"],
            "part_reference" => doc.data["part_reference"],
            "order" => doc.data["order"],
            "url" => doc.url,
            "doc" => doc
          }
        end

        part_items = parts_collection.docs.map do |part|
          {
            "reference" => part.data["reference"],
            "title" => part.data["title"],
            "order" => part.data["order"],
            "url" => part.url
          }
        end
        part_items.sort_by! {|item| item["order"]}

        # Add menu_items to part_items
        part_items.each do |part|
          part_menu_items = menu_items.select { |menu_item| menu_item["part_reference"] == part["reference"] }
          part_menu_items.sort_by! { |menu_item| menu_item["order"] }
          part["menu_items"] = part_menu_items
        end
        
        # pp part_items


        # Calculate : previous_chapter
        previous_chapter = nil
        part_items.each_with_index do |part, part_index|
          part["menu_items"].each do |menu_item|
            menu_item["doc"].data["previous_chapter"] = previous_chapter
            previous_chapter = menu_item
          end
        end

        next_chapter = nil
        part_items.reverse_each do |part|
          part["menu_items"].reverse_each do |menu_item|
            menu_item["doc"].data["next_chapter"] = next_chapter
            next_chapter = menu_item
          end
        end

         


        # enregistrement de menu dans site.data
        site.data["part_items"] ||= {}
        site.data["part_items"] = part_items
      end
    end
  end
  


# pp menu_items 
# meu_item = {
#   "introduction" => [
#     { "label" => "Introduction", "part_reference" => "introduction", "order" => 5, "url" => "/index.html" },
#     { "label" => "Présentation du formateur", "part_reference" => "introduction", "order" => 2, "url" => "/présentation-formateur.html" },
#     { "label" => "Déroulement de la formation", "part_reference" => "introduction", "order" => 3, "url" => "/déroulement-formation.html" },
#     { "label" => "Plan du formation", "part_reference" => "introduction", "order" => 4, "url" => "/plan-formation.html" }
  #   ],
#   "découvrir-langages-web" => [
#     { "label" => "découvrir-langages-web", "part_reference" => "découvrir-langages-web", "order" => 1, "url" => "/découvrir-langages-web.html" },
#     { "label" => "Planning", "part_reference" => "découvrir-langages-web", "order" => 2, "url" => "/planning.html" },
#     { "label" => "Mini-projet", "part_reference" => "découvrir-langages-web", "order" => 3, "url" => "/mini-projet-créer-portfolio-personnel.html" }
#   ],
#   # ... (autres sections du hash)
# }