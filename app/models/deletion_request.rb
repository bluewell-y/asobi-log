class DeletionRequest < ApplicationRecord
  STATUS_LABELS = {
    "pending" => "承認待ち",
    "approved" => "承認済み",
    "rejected" => "却下"
  }.freeze

  belongs_to :place
  belongs_to :user

  enum :status, {
    pending: 0,  # 承認待ち
    approved: 1, # 承認済み
    rejected: 2  # 却下
  }

  validates :reason, presence: true
  validate :only_one_pending_request_per_place, on: :create

  def status_label
    STATUS_LABELS[status]
  end

  private

  # 同じ遊び場に対して、承認待ちの申請は同時に1件までにする
  def only_one_pending_request_per_place
    if place && place.deletion_requests.pending.exists?
      errors.add(:base, "この遊び場にはすでに削除申請が出されています")
    end
  end
end
