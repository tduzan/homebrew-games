require "language/go"

class SpaceinvadersGo < Formula
  desc "Space Invaders in your terminal written in Go."
  homepage "https://github.com/asib/spaceinvaders"
  url "https://github.com/asib/spaceinvaders/archive/v1.1.tar.gz"
  sha256 "af8edccec60db68f1a5c293cbd610f9b5eb66ba4c81ed10222f42eea2971001d"

  depends_on "go" => :build

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "5890272cd41c5103531cd7b79e428d99c9e97f76"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "785b5546a97f27460cfbc4c77132a46b90beb834"
  end

  def install
    # This builds with Go.
    ENV["GOPATH"] = buildpath
    sipath = buildpath/"src/github.com/asib/spaceinvaders"
    sipath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/asib/spaceinvaders/" do
      system "go", "build"
      bin.install "spaceinvaders"
    end
  end

  test do
    IO.popen("#{bin}/spaceinvaders", "r+") do |pipe|
      pipe.puts "q"
      pipe.close_write
      pipe.close
    end
  end
end
