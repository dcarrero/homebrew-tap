# Written by the release workflow of dcarrero/mboxshell. Do not edit by hand.
class Mboxshell < Formula
  desc "Fast terminal viewer for MBOX files of any size"
  homepage "https://github.com/dcarrero/mboxshell"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.3.0/mboxshell-macos-aarch64"
      sha256 "1246c046718553d86db72f1da739c664860ca590a16c8f004500d4d90a286c85"
    end
    on_intel do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.3.0/mboxshell-macos-x86_64"
      sha256 "817a592e976525131dd0be8493e3c0188984f60a43824f4ea742dac706d6ccb7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.3.0/mboxshell-linux-aarch64"
      sha256 "c2640ad6e0331564c05d9135f1de18aca04e10139f02ef8683f14fbf6df04ea2"
    end
    on_intel do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.3.0/mboxshell-linux-x86_64"
      sha256 "0d1cbec386936174591f8cdb4e899a7795f25f215b48e5ca1c5975d090e2ca12"
    end
  end

  def install
    bin.install Dir["mboxshell-*"].first => "mboxshell"
    chmod 0755, bin/"mboxshell"
    with_env(MBOXSHELL_LANG: "en") do
      generate_completions_from_executable(bin/"mboxshell", "completions")
      (man1/"mboxshell.1").write Utils.safe_popen_read(bin/"mboxshell", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mboxshell --version")
    (testpath/"test.mbox").write <<~MBOX
      From sender@example.com Mon Jan  1 00:00:00 2024
      From: Sender <sender@example.com>
      To: rcpt@example.com
      Subject: Hello
      Date: Mon, 1 Jan 2024 00:00:00 +0000

      Body
    MBOX
    assert_match "\"message_count\": 1", shell_output("#{bin}/mboxshell stats #{testpath}/test.mbox --json")
  end
end
