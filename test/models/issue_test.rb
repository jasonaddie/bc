# == Schema Information
#
# Table name: issues
#
#  id               :integer          not null, primary key
#  publication_id   :integer
#  issue_number     :string
#  date_publication :date
#  is_public        :boolean          default(FALSE)
#  date_publish     :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
