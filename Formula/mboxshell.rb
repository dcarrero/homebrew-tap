# Written by the release workflow of dcarrero/mboxshell. Do not edit by hand.
class Mboxshell < Formula
  desc "Fast terminal viewer for MBOX files of any size"
  homepage "https://github.com/dcarrero/mboxshell"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.2.2/mboxshell-macos-aarch64"
      sha256 "1f2ec709957a4be392a41db17812f4a337961f68c67982b61facf7e0f4bea1fc"
    end
    on_intel do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.2.2/mboxshell-macos-x86_64"
      sha256 "94b6a9114042c2489c2f360625e70bd7c3d26c6cde67b45ec2439bdef4a20620"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.2.2/mboxshell-linux-aarch64"
      sha256 "94ec271882238c8fbc5f34847ecc5aa8c272084d16489730e7d9378a7ce23aac"
    end
    on_intel do
      url "https://github.com/dcarrero/mboxshell/releases/download/v1.2.2/mboxshell-linux-x86_64"
      sha256 "e57c0b2b0083a8e2b87eed756c323fe3bbe19f601615e2930c4036f3fa0370f7"
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
