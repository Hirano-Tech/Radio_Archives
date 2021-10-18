class Piston2438 < ApplicationRecord
  def self.repeat_shuffle(client, object, object_client, play_method, already_play)
    program = object_client.metadata['program']
    broadcast_date = object_client.metadata['date']

    if play_method == 'shuffle_play'
      while program != 'Piston2438_DJ-MIX' || already_play.include?(object.key)
        object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
        object_client = Aws::S3::Object.new(
          access_key_id: Rails.application.credentials.AWS_S3[:Access_Key_ID],
          secret_access_key: Rails.application.credentials.AWS_S3[:Secret_Access_Key],
          region: Rails.application.credentials.AWS_S3[:Region],
          bucket_name: Rails.application.credentials.AWS_S3[:Bucket],
          key: object.key
        )
      end
    elsif play_method == 'one_month'
      while program != 'Piston2438_DJ-MIX' || Date.parse(broadcast_date) < Date.today.months_ago(1) || already_play.include?(object.key)
        object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
        object_client = Aws::S3::Object.new(
          access_key_id: Rails.application.credentials.AWS_S3[:Access_Key_ID],
          secret_access_key: Rails.application.credentials.AWS_S3[:Secret_Access_Key],
          region: Rails.application.credentials.AWS_S3[:Region],
          bucket_name: Rails.application.credentials.AWS_S3[:Bucket],
          key: object.key
        )      end
    elsif play_method == 'three_months'
      while program != 'Piston2438_DJ-MIX' || Date.parse(broadcast_date) < Date.today.months_ago(3) || already_play.include?(object.key)
        object = client.list_objects_v2({bucket: Rails.application.credentials.AWS_S3[:Bucket]}).contents.sample
        object_client = Aws::S3::Object.new(
          access_key_id: Rails.application.credentials.AWS_S3[:Access_Key_ID],
          secret_access_key: Rails.application.credentials.AWS_S3[:Secret_Access_Key],
          region: Rails.application.credentials.AWS_S3[:Region],
          bucket_name: Rails.application.credentials.AWS_S3[:Bucket],
          key: object.key
        )      end
    end

    return {object: object, object_client: object_client}
  end
end
