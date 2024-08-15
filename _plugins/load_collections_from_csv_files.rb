require 'open-uri'
require 'csv'
require 'pp'
require 'jekyll'
require 'psych'

module Jekyll
  module LoadCollectionFromCsvFile

    class FromCsvFile
      
      def initialize()
        @data_directory = "_data/collections"
        @google_sheet_id = "1z_kyk6ZUFuHoEvKAxw-Vrk6oRQjj-q4OkgapUAbgA4o"
        @base_url_sheet = "https://docs.google.com/spreadsheets/d/#{@google_sheet_id}/gviz/tq?tqx=out:csv&sheet="
      end

      # Conversion d'une chaîne de caractère au hash table
      def convert_strings_to_arrays(hash)
   
        hash.each do |key, value|
          if value.is_a?(String) && value.start_with?('[') 
              # pp value
              cleaned_string = value.gsub('[', '').gsub(']', '')
              array = cleaned_string.split(',')
              hash[key] = array
          end
          if value.is_a?(String) && value.start_with?('*') 

              array = value.split('*')
              array.shift
              array = array.map(&:strip)
              hash[key] = array
          end
          if value.is_a?(String) && value == 'TRUE'
            hash[key] = true
          end
          if value.is_a?(String) && value == 'FALSE'
            hash[key] = false
          end
        end
        hash
      end

      # Convert csv file to hash table
      def csv_to_hash(filename)
        data = []
        CSV.foreach(filename, headers: true) do |row|
          row_hash = row.to_h
          row_hash = convert_strings_to_arrays(row_hash)
          # Convert order clone to integer
          row_hash["order"] = row_hash["order"].to_i if row_hash.has_key?("order")
          data << row_hash
         end
        data
      end


      # Téléchargement de tous les fichier csv et mettre à jour les collections
      def populate(site)
        puts "plugin : mettre à jour des collections"
        menu_csv_data = download_all_collection_csv_files_if_notexist
        menu_csv_data.each do |item|
          collection_name = item[0]
          csv_file_name = "#{@data_directory}/#{collection_name}.csv"
          data = csv_to_hash(csv_file_name)
          update_data_to_files(site,data,collection_name)
        end
      end

      # Mettre à jour une collection
      def  update_data_to_files(site,data,collection_name)

        data.each do |item|

          # Chemin de l'enregistrement de fichier
          directory = item["directory"] || ""

          # # Solution de problème de lien Hypertexte
          # # Convert Roo::Link to string
          # item.each do |key, value|
          #   if value.is_a?(Roo::Link)
          #     item[key] = value.href  # Access and store the link's href (URL)
          #   end
          # end
          
        
          # Chemin de fichier
          path = file_path(site,collection_name,directory,item)

          # Création des dossiers s'il n'exist pas 
          full_directory = File.join(site.source, "_#{collection_name}", directory)
          create_directory_path(full_directory)
        
          # Détermination de layout
          # Par défaut le layout  = collection_name
          # Add layout attribut if collection layout exist
          if site.layouts.key?(collection_name)
            item = item.merge({'layout' => collection_name})
          end
          # Si le chapitre avoir une concept, layout = chapter_concept
       
          if collection_name == "chapters"
            

     
            if item['concept_reference'] != ""
              
              item['layout'] = 'chapter_with_concept'
            end 
          end



          # Création ou mettre de fichier
          if File.exist?(path) 
            update_data_if_not_updated(path,item)
          else
            create_file_if_not_exist(path,item)
          end

        end
      end

      def file_path(site,collection_name,directory,item)

        order = item.fetch("order",nil)
        
        file_name = item["slug"] || item["reference"]
        file_name = "#{Jekyll::Utils.slugify(file_name)}.md"

        # if order
        #   file_name =  "#{order}.#{Jekyll::Utils.slugify(item["reference"])}.md" 
        # else 
        #   file_name = "#{Jekyll::Utils.slugify(item["reference"])}.md"
        # end 

        path = File.join(site.source, "_#{collection_name}", directory, "#{file_name}")
        path
      end

      def create_file_if_not_exist(path,data)
        yaml_string = Psych.dump(data)

        if ! File.exist?(path)
          File.open(path, "w") do |file|
            # file.write("---\n")  # Add YAML delimiters
            file.write(yaml_string)
            file.write("---\n")  # Add delimiters after content
          end
        end
      end

      def create_directory_path(path)
        # Convert path to Pathname object for easier manipulation
        pathname = Pathname.new(path)
      
        # Check if the directory already exists
        if !pathname.exist?
          # Create the directory structure using mkpath (creates all missing parent directories)
          pathname.mkpath
        end
      end

      def update_data_if_not_updated(markdown_file_path, data)

        if File.exist?(markdown_file_path)
          # Read the entire file content
          content = File.read(markdown_file_path)
      
          # Split content at YAML delimiters (assuming `---\n`)
          splided = content.split("---\n")
          # pp splided
          
          front_matter_str = splided[1]
          document = splided[2]

          # Parse existing front matter (if present)
          existing_front_matter = Psych.load(front_matter_str) if front_matter_str
          # pp "existing_front_matter"
          # pp existing_front_matter
          # Update front matter data
          updated_front_matter = existing_front_matter ? existing_front_matter.merge(data) : data

          # Check if there are actual changes
          changes_made = updated_front_matter != existing_front_matter
          # pp updated_front_matter
          # pp existing_front_matter
          #  pp "changes_made:" + changes_made.to_s

          if changes_made


            # pp "change mode"

            # pp data
            # pp updated_front_matter
            # pp existing_front_matter

            # Combine updated front matter and document
            updated_content = Psych.dump(updated_front_matter) + "---\n" + (document ? document.to_s : "")
            

            # Write the updated content to the file
            File.open(markdown_file_path, 'w') { |f| f.write(updated_content) }
            puts "Updated YAML front matter in #{markdown_file_path}"
          end
        else
          puts "Error: Markdown file #{markdown_file_path} does not exist."
        end
      end


      def get_collection_csv_file(collection_name)
        
        sheet_name = collection_name
       
        url_sheet = @base_url_sheet + sheet_name
        csv_file_name = "#{@data_directory}/#{sheet_name}.csv"
        return if File.exist?(csv_file_name)
        begin
          URI.open(url_sheet) do |f|
            File.open(csv_file_name, 'wb') do |local_file|
              csv_string = f.read
              local_file.write(csv_string)
            end
          end
        rescue OpenURI::HTTPError => e
          puts "Error downloading #{collection_name} CSV: #{e.message}"
        rescue CSV::MalformedCSVError => e
          puts "Error parsing #{collection_name} CSV: #{e.message}"
        end
      
      end
      
      def download_all_collection_csv_files_if_notexist
       
        menu_csv_data = nil
        sheet_name = "menu"
        url_sheet = @base_url_sheet + sheet_name
        csv_file_name = "#{@data_directory}/#{sheet_name}.csv"
      
        csv_string = ""
        if File.exist?(csv_file_name)
          File.open(csv_file_name, "r") do |file|
            csv_string = file.read
          end
        else
          URI.open(url_sheet) do |f|
            File.open(csv_file_name, 'wb') do |local_file|
              csv_string = f.read
              local_file.write(csv_string)
            end
          end
        end
      
       
        menu_csv_data = CSV.parse(csv_string)
        menu_csv_data.shift
        menu_csv_data.each do |row|
          collection_name =  row[0]
          get_collection_csv_file(collection_name)
        end
        return menu_csv_data
      end

    end

    class Generator < ::Jekyll::Generator
      priority :low
      def generate(site)

        # Return si le fichier excel n'existe pas dans la configuration
        # return unless site.config['csv']

        FromCsvFile.new().populate(site)

      end
    end
  end
end
