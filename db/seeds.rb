require 'mime/types'
# All we're doing here is iterating through the YAML files in `db/seeds/*.yml`
# and creating objects based on the definitions there. If you'd like to add
# some seed data, either edit an existing file there or add a new one
# corresponding to the class of the objects you're creating.

module Seed
  class Collection
    attr_accessor :jobs

    def initialize(files = nil)
      self.jobs = (files || all_files).map do |file|
        Job.class_for_file(file).new(file, self)
      end
    end

    def import
      jobs.each(&:run)
    end

    private

    def all_files
      dir = File.dirname(__FILE__)

      # First, we'll get seeds for all environments.
      files = Dir[File.join(dir, 'seeds/*.*')]

      # Then, we'll see if any environment-specific seed files exist and add them to
      # the bunch.
      env_dir = File.join(dir, "seeds/#{Rails.env}")
      files += Dir[File.join(env_dir, '*')] if Dir.exist?(env_dir)

      files
    end
  end

  class Job
    attr_accessor :file, :collection, :executed

    def initialize(file, collection = [])
      self.file = file
      self.collection = collection
      self.executed = false
    end

    def name
      File.basename(file, '.*')
    end

    def executed?
      executed.present?
    end

    def run
      return if executed?
      process_dependencies
      do_import
      print "Imported #{name}\n"
      self.executed = true
    end

    def self.class_for_file(file)
      case mime = ::MIME::Types.of(file).first
      when 'text/yaml'
      when 'text/x-yaml' then YamlJob
      when 'application/ruby'
      when 'application/x-ruby'
        require file
        "Seed::#{File.basename(file, '.rb').sub(/.*\./, '').camelize}".to_constant
      else fail "Unrecognized file type #{mime.preferred_extension}"
      end
    end

    private

    def dependencies
      []
    end

    def process_dependencies
      dependencies.each do |name|
        dependency = collection.jobs.find { |job| job.name == name }
        dependency ? dependency.run : fail("Could not find job with name #{name} (called as a dependency of #{self.name})")
      end
    end

    def do_import
      fail NotImplementedError
    end
  end

  class YamlJob < Job
    private

    def do_import
      klass = yaml[:class_name].to_constant
      associations = klass.reflect_on_all_associations
      association_names = associations.map(&:name)

      yaml[:objects].each do |attributes|
        association_attributes = attributes.extract!(*association_names)
        object = klass.new(attributes)
        association_attributes.each_pair do |key, value|
          association = associations.find { |a| a.name.to_s == key.to_s }

          if association.is_a?(ActiveRecord::Reflection::BelongsToReflection) || association.is_a?(ActiveRecord::Reflection::HasOneReflection)
            object.send("build_#{key}", value)
          else
            object.send(key).build(value)
          end
        end

        begin
          object.save! unless object.class.exists?(object.id)
        rescue ActiveRecord::RecordInvalid => invalid
          raise invalid.record.errors
        end
      end
    end

    def dependencies
      yaml[:dependencies] || super
    end

    def yaml
      @yaml ||= YAML.load_file(file).with_indifferent_access
    end
  end
end

Seed::Collection.new.import
