#!/usr/bin/env ruby

require 'qiniu'

Qiniu.establish_connection! :access_key => SiteConfig.qiniu_access_key,
                            :secret_key => SiteConfig.qiniu_secret_key
                            
# require 'qiniu'
# ::Qiniu.establish_connection! :access_key => 'hsFmU-AeAxLxZJyZJL1YnQwbTVMd7KuBbMdEjlO1',
#                               :secret_key => "t_daAXEEFEuFYcYaXRhQ4EXnm00fWXDXVyHxfLAd"