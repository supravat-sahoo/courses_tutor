# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 10.freeze
  DEFAULT_PAGE_NUMBER = 1.freeze

  def paginate(scope)
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    page_number = params[:page_no] || DEFAULT_PAGE_NUMBER

    scope.offset(Integer(page_size) * (Integer(page_number) - 1)).limit(Integer(page_size))
  end
end
