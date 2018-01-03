# frozen_string_literal: true

module Decidim
  module Module
    module Sortitions
      # Model that encapsulates the parameters of a sortion
      class Sortition < ApplicationRecord
        include Decidim::HasCategory
        include Decidim::Authorable
        include Decidim::HasFeature
        include Decidim::HasReference

        feature_manifest_name "sortitions"

        belongs_to :decidim_proposals_feature,
                   foreign_key: "decidim_proposals_feature_id",
                   class_name: "Decidim::Feature"

        before_validation :initialize_reference

        def proposals
          Decidim::Proposals::Proposal.where(id: selected_proposals)
        end

        def similar_count
          Sortition.where(feature: feature)
                   .where(decidim_proposals_feature: decidim_proposals_feature)
                   .where(category: category)
                   .where(target_items: target_items)
                   .count
        end

        def seed
          request_timestamp.to_i * dice
        end

        def author_name
          author&.name
        end

        def author_avatar_url
          author&.avatar&.url || ActionController::Base.helpers.asset_path("decidim/default-avatar.svg")
        end

        def self.order_randomly(seed)
          transaction do
            connection.execute("SELECT setseed(#{connection.quote(seed)})")
            order("RANDOM()").load
          end
        end

        private

        def initialize_reference
          self[:reference] ||= calculate_reference
        end
      end
    end
  end
end
