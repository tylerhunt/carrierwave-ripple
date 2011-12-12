module CarrierWave
  module Storage
    class Riak < Abstract
      class File
        attr_reader :path

        def initialize(uploader, path)
          @uploader = uploader
          @path = path
        end

        def write(file)
          robject = bucket.new(key)
          robject.content_type = file.content_type
          robject.raw_data = file.read
          robject.store
        end

        def read
          @read ||= robject.raw_data
        end

        def delete
          robject.delete
        end

        def content_type
          robject.content_type
        end

        def size
          read.length
        end

        def url
          robject.url
        end

        def riak
          @uploader.riak_client
        end
        private :riak

        def bucket
          riak.bucket(@uploader.riak_bucket_name)
        end
        private :bucket

        def key
          CGI.escape(path)
        end
        private :key

        def robject
          @robject ||= bucket.get(key)
        end
        private :robject
      end

      def store!(file)
        File.new(uploader, uploader.store_path).tap do |stored|
          stored.write(file)
        end
      end

      def retrieve!(identifier)
        File.new(uploader, uploader.store_path(identifier))
      end
    end
  end

  Uploader::Base.add_config :riak_client
  Uploader::Base.add_config :riak_bucket_name

  configure do |config|
    config.storage_engines[:riak] = 'CarrierWave::Storage::Riak'
    config.riak_bucket_name = 'uploads'
  end
end
