# -*- coding: utf-8 -*-

Plugin.create :hide_msg_sec do
  class Gdk::MiraclePainter
    def timestamp_label_ex
      now = Time.now
      if message[:created].year == now.year && message[:created].month == now.month && message[:created].day == now.day
        if (message[:created].hour * 60 + message[:created].min) > (now.hour * 60 + now.min - 5)
          Pango.escape(message[:created].strftime(UserConfig[:date_format_now]))
        else
          Pango.escape(message[:created].strftime(UserConfig[:date_format_day]))
        end
      elsif message[:created].year != now.year
        Pango.escape(message[:created].strftime(UserConfig[:date_format_last_year]))
      else
        Pango.escape(message[:created].strftime(UserConfig[:date_format_yesterday]))
      end
    end

    alias_method :timestamp_label_org, :timestamp_label
    alias_method :timestamp_label, :timestamp_label_ex
  end

  settings "日付時刻フォーマット" do
    settings "フォーマット（strftime形式)" do
      input("5分以内", :date_format_now)
      input("今日", :date_format_day)
      input("昨日以前", :date_format_yesterday)
      input("去年以前", :date_format_last_year)
    end
  end

  on_boot do |service|
    UserConfig[:date_format_now] ||= ""
    UserConfig[:date_format_day] ||= "%H:%M"
    UserConfig[:date_format_yesterday] ||= "%m/%d %H:%M"
    UserConfig[:date_format_last_year] ||= "%y/%m/%d %H:%M"
  end
end
