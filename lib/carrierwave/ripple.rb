require 'carrierwave/ripple/version'
require 'carrierwave/validations/active_model'
require 'ripple/document'

module CarrierWave
  module Ripple
    include CarrierWave::Mount

    def mount_uploader(column, uploader=nil, options={}, &block)
      property column, String

      super

      alias_method :read_uploader, :[]
      alias_method :write_uploader, :[]=

      include CarrierWave::Validations::ActiveModel

      if uploader_option(column.to_sym, :validate_integrity)
        validates_integrity_of column
      end

      if uploader_option(column.to_sym, :validate_processing)
        validates_processing_of column
      end

      after_save :"store_#{column}!"
      before_save :"write_#{column}_identifier"
      after_destroy :"remove_#{column}!"
      before_update :"store_previous_model_for_#{column}"
      after_save :"remove_previously_stored_#{column}"

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{column}=(new_file)
          column = _mounter(:#{column}).serialization_column

          if new_file.is_a?(String)
            write_uploader(column, new_file)
          else
            send(:"\#{column}_will_change!")
            super
          end
        end
      RUBY
    end
  end
end

Ripple::Document::ClassMethods.send(:include, CarrierWave::Ripple)
