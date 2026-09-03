module ApplicationHelper
  # 入力フォームの並び順に沿ってエラーメッセージを返す。
  # order に含まれない属性（:base など）は末尾に元の順序のまま並ぶ。
  def error_messages_in_form_order(record, order)
    keys = order.map(&:to_s)
    record.errors.each_with_index
          .sort_by { |error, i| [keys.index(error.attribute.to_s) || keys.size, i] }
          .map { |error, _| error.full_message }
  end
end
