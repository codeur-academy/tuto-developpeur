require 'open-uri'
require 'csv'
require 'pp'
require 'jekyll'
require 'psych'
require 'roo'
# require 'roo-xls'

module Jekyll
  module Csv1

    class CollectionFilesGenerator
      attr_reader :conf

      def initialize(conf)
        @conf = conf
      end

      def populate(site)

        file_name = '_data/collections.xlsx'
        workbook = Roo::Spreadsheet.open(file_name)

        # Loop through worksheets
        workbook.each_with_pagename  do |sheet_name, worksheet|

  
        collection_name = sheet_name
        titles = worksheet.row(1).compact 
        data = worksheet.parse(headers: true)
        # Delete titles
        data.shift

        data.each do |item|

          # Convert Roo::Link to string
          item.each do |key, value|
            if value.is_a?(Roo::Link)
              item[key] = value.href  # Access and store the link's href (URL)
            end
          end
          pp item["reference"].class
          pp item["link"].class

          
          path = File.join(site.source, "_#{collection_name}", "#{Jekyll::Utils.slugify(item["reference"])}.md")
        
          # Add layout attribut if collection layout exist
          if site.layouts.key?(collection_name)
            item = item.merge({'layout' => collection_name})
          end


          if File.exist?(path) 
            update_data_if_not_updated(path,item)
          else
            create_file_if_not_exist(path,item)
          end
        end
        end

        # csv_data.each do |item|

        #   path = File.join(site.source, "_#{collection_name}", "#{Jekyll::Utils.slugify(item[slug_field])}.md")
        
        #   # Add layout attribut if collection layout exist
        #   if site.layouts.key?(collection_name)
        #     item = item.merge({'layout' => collection_name})
        #   end

        #   if File.exist?(path) 
        #     update_data_if_not_updated(path,item)
        #   else
        #     create_file_if_not_exist(path,item)
        #   end
      
        # end

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

      def update_data_if_not_updated(markdown_file_path, data)

        if File.exist?(markdown_file_path)
          # Read the entire file content
          content = File.read(markdown_file_path)
      
          # Split content at YAML delimiters (assuming `---\n`)
          splided = content.split("---\n")
          # pp splided
          
          front_matter_str = splided[1]
          document = splided[2]

          # puts "front_matter_str"
          # puts front_matter_str

          # puts "document"
          # puts document

          # # puts "document"
          # # puts document


   
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


    end

    class Generator < ::Jekyll::Generator
      priority :low
      def generate(site)

        # Return si le fichier excel n'existe pas dans la configuration
        # return unless site.config['csv']

        CollectionFilesGenerator.new(nil).populate(site)

      end
    end
  end
end
