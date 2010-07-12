Paperclip.interpolates :sharded_id do |attachment, style|
  id_to_shard = attachment.instance.id.to_s.rjust(3, '0')
  "#{id_to_shard.mb_chars[0].wrapped_string}/#{id_to_shard.mb_chars[1].wrapped_string}/#{id_to_shard.mb_chars[2].wrapped_string}/#{id_to_shard}"
end