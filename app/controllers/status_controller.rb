# frozen_string_literal: true

class StatusController < ApplicationController
  def index
    @body_css = 'status-page' + (Rails.env.development? ? '-dev' : '')

    @ruby_version = "#{RUBY_VERSION} patch #{RUBY_PATCHLEVEL} platform #{RUBY_PLATFORM}"
    @raw_alg_count ||= @@raw_alg_count ||= RawAlg.count
    @combo_alg_count ||= @@combo_alg_count ||= ComboAlg.count

    @troubles = @@trouble_list
    @requests = @@request_count.keys.sort.map{|k| [k, @@request_count[k]] }
    @user_agents = @@user_agent_count.keys.sort.map{|k| [k, @@user_agent_count[k]] }
  end
end
