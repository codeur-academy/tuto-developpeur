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
        chapter_items = chapters_collection.docs
        part_items = parts_collection.docs
        part_items = part_items.select { |part| part.data["published"] == true}
        part_items.sort_by! {|item| item.data["order"]}

        # Add chapter_items to part_items
        part_items.each do |part|
          
          part_chapter_items = chapter_items.select { |chapter_item| chapter_item.data["part_reference"] == part.data["reference"] }
          part_chapter_items.sort_by! { |chapter_item| chapter_item.data["order"] }

          first_chapter_in_part = part_chapter_items[0]
          part_chapter_items.each do |chapter_item|
            chapter_item.data["part"] = part
            chapter_item.data["first_chapter_in_part"] = first_chapter_in_part
          end
          part.data["chapter_items"] = part_chapter_items
        end
        
     

        # Calculate : previous_chapter
        previous_chapter = nil
        part_items.each_with_index do |part, part_index|
          part.data["chapter_items"].each do |chapter_item|
            chapter_item.data["previous_chapter"] = previous_chapter
            previous_chapter = chapter_item
          end
        end

        # Calculate : next_chapter
        next_chapter = nil
        part_items.reverse_each do |part|
          part.data["chapter_items"].reverse_each do |chapter_item|
            chapter_item.data["next_chapter"] = next_chapter
            next_chapter = chapter_item
          end
        end

         


        # enregistrement de menu dans site.data
        site.data["part_items"] ||= {}
        site.data["part_items"] = part_items
        # pp part_items
      end
    end
  end
  


# pp chapter_items 
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