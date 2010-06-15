require 'formula'

class Riak <Formula
  depends_on 'erlang'
  
  url 'http://downloads.basho.com/riak/riak-0.11/riak-0.11.0.tar.gz'
  homepage 'http://riak.basho.com'
  sha1 "7fd74f79bceee0d3aa73fd0b261f5d9922275a15"
  
  skip_clean 'libexec/log'
  skip_clean 'libexec/log/sasl'
  skip_clean 'libexec/data'
  skip_clean 'libexec/data/dets'
  skip_clean 'libexec/data/ring'
  
  def install
    ENV.deparallelize
    system "make all rel"
    %w(riak riak-admin).each do |file|
      inreplace "rel/riak/bin/#{file}", /^RUNNER_SCRIPT_DIR.+$/, ""
      inreplace "rel/riak/bin/#{file}", /^RUNNER_BASE_DIR=.+$/, "RUNNER_BASE_DIR=#{libexec}"
    end

    # Install most files to private libexec, and link in the binaries.
    libexec.install Dir["rel/riak/*"]
    bin.mkpath
    ln_s libexec+'bin/riak', bin
    ln_s libexec+'bin/riak-admin', bin

    (prefix + 'data/ring').mkpath
    (prefix + 'data/dets').mkpath
  end
end
