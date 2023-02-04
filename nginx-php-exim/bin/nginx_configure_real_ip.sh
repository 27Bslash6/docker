#!/bin/bash

#  (The MIT License)
#
#  Copyright (c) 2013 M.S. Babaei
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

# Configure pagespeed to support downstream caching
# See: https://modpagespeed.com/doc/downstream-caching
# FIXME This is not implemented properly yet

if [[ ${CLOUDFLARE_ENABLED} = "true" ]]; then
  REAL_IP_HEADER=CF-Connecting-IP
else
  REAL_IP_HEADER=X-Forwarded-For
fi

export REAL_IP_HEADER

f=/etc/nginx/conf.d/10_real_ip.conf

_good "$(printf "%-10s " "openresty:")" "REAL_IP_HEADER ${REAL_IP_HEADER}"

dockerize -template "/app/templates$f.tmpl:$f"
