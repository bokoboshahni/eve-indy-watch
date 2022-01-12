# frozen_string_literal: true

class Fitting < ApplicationRecord
  module KillmailStatistics
    extend ActiveSupport::Concern

    included do
      has_many :killmail_fittings, inverse_of: :fitting, dependent: :destroy

      has_many :killmails, through: :killmail_fittings do
        def likely_matching
          where('killmail_fittings.similarity >= 0.95 AND killmail_fittings.similarity < 1.0')
        end
      end
    end

    def killmail_losses(period)
      killmails.where(id: killmail_fittings.matching.pluck(:killmail_id), time: build_period(period))
    end

    def killmail_losses_daily_avg(period = nil)
      range = build_period(period)
      days = (range.first.to_date...range.last.to_date).count
      killmail_losses(period).group_by_day(:time).count.values.sum / days.to_d
    end
  end
end
