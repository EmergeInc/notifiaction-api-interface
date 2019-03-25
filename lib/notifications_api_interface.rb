require "notifications_api_interface/version"

module NotificationsApiInterface
  def self.create_notifications(user_id, module_id="", title="", message="",
                                  urgent=0, image_url="", image_alt_tag="",
                                  link_word="", link_url="", start_display_on=DateTime.now.strftime("%F")  )
    require 'uri'
    require 'net/http'
    url = URI("http://notificationsapi.emergeinc.com/api/message")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url)
    request["Accept"] = 'application/json'
    request["Content-Type"] = 'application/json'
    request["Authorization"] = set_authorization
    request["Cache-Control"] = 'no-cache'
    request.body = "{\n\t\"user_id\": \"#{user_id}\",\n\t\"module_id\": \"#{module_id}\",
                    \n\t\"title\": \"#{title}\",\n\t\"message\": \"#{message}\",\n\t\"urgent\": #{urgent},
                    \n\t\"image_url\": \"#{image_url}\",\n\t\"image_alt_tag\": \"#{image_alt_tag}\",
                    \n\t\"link_word\": \"#{link_word}\",\n\t\"link_url\": \"#{link_url}\",
                    \n\t\"start_display_on\": \"#{start_display_on}\"\n}"
    response = http.request(request)
  end

  def self.retrieve_notifications
    require 'uri'
    require 'net/http'
    url = URI("http://notificationsapi.emergeinc.com/api/message")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = set_authorization
    request["Cache-Control"] = 'no-cache'
    response = http.request(request)
    ret = JSON.parse response.read_body
  end

  def self.retrieve_user_notifications(user_id)
    require 'uri'
    require 'net/http'
    url = URI("http://notificationsapi.emergeinc.com/api/message/user/#{user_id}")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = set_authorization
    request["Cache-Control"] = 'no-cache'
    response = http.request(request)
    ret = JSON.parse response.read_body
  end

  private

  def self.set_authorization
    "Bearer #{ENV['EMERGE_NOTIFICATIONS_TOKEN']}"
  end

end
