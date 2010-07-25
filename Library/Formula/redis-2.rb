require 'formula'

class Redis2 <Formula
  url 'http://redis.googlecode.com/files/redis-2.0.0-rc3.tar.gz'
  head 'git://github.com/antirez/redis.git'
  homepage 'http://code.google.com/p/redis/'
  sha1 '4db50c01997c0de50345b52aeb0e20bc4ab1c253'

  def install
    ENV.gcc_4_2 # Breaks with LLVM
    system "make"

    %w( redis-benchmark redis-cli redis-server redis-stat redis-check-dump ).each { |p|
      # Some of these commands are only in 1.2.x, some only in head
      bin.install p rescue nil
    }

    %w( run db/redis log ).each do |path|
      (var+path).mkpath
    end

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
    end
    
    etc.install "redis.conf"
  end

  def caveats
    <<-EOS.undent
      To start redis:
        redis-server #{etc}/redis.conf

      To access the server:
        redis-cli
    EOS
  end
end
