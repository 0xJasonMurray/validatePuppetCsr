#!/bin/sh

if [ ! -d /etc/puppet ]; then
   mkdir /etc/puppet
fi
erb > /etc/puppet/csr_attributes.yaml <<END
custom_attributes:
  1.2.840.113549.1.9.7: MySuperSecretPasswordGoesHere
extension_requests:
  pp_instance_id: <%= %x{/usr/bin/ec2metadata --instance-id}.sub(/instance-id: (.*)/,'\1').chomp %>
  pp_image_name:  <%= %x{/usr/bin/ec2metadata --ami-id}.sub(/ami-id: (.*)/,'\1').chomp %>
END
