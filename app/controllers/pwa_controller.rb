# frozen_string_literal: true

class PwaController < ApplicationController
  def manifest
    respond_to do |format|
      format.json { render template: 'pwa/manifest', content_type: 'application/manifest+json' }
    end
  end

  def service_worker
    respond_to do |format|
      format.js { render template: 'pwa/service-worker', content_type: 'application/javascript' }
    end
  end
end
