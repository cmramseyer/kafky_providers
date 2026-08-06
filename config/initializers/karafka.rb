require "karafka"
require_dependency Rails.root.join("app/consumers/application_consumer").to_s
require_dependency Rails.root.join("app/consumers/inventory_events_consumer").to_s

class KarafkaApp < Karafka::App
  setup do |config|
    config.client_id = "kafky_providers"
    config.kafka = {
      "bootstrap.servers": ENV.fetch("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
    }
    config.consumer_persistence = !Rails.env.development?
  end

  routes.draw do
    consumer_group :kafky_providers do
      topic "inventory.events" do
        consumer InventoryEventsConsumer
      end
    end
  end
end
