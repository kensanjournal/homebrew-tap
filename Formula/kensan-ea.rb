class KensanEa < Formula
  desc "Kensan EA connector for MetaTrader 5"
  homepage "https://kensanjournal.com"
  url "https://github.com/kensanjournal/homebrew-tap/releases/download/v2.0.0/kensan-ea-2.0.0.tar.gz"
  sha256 "c5259694c08ca8a0ef1cd947c28f991142a5005bb4fdd7188bac16ee804e6276"
  version "2.0.0"
  license "Proprietary"

  def install
    libexec.install "kensan-mt-connector-v2.0.0.mq5"

    (bin/"kensan-ea").write <<~SH
      #!/bin/bash
      EA_FILE="#{libexec}/kensan-mt-connector-v2.0.0.mq5"
      EXPERTS_DIR=$(find "$HOME/Library" -name "Experts" -type d 2>/dev/null | grep -v ".Trash" | head -1)

      if [ -z "$EXPERTS_DIR" ]; then
        echo "MetaTrader 5 not found. Install MT5 first: metatrader5.com/en/download"
        exit 1
      fi

      cp "$EA_FILE" "$EXPERTS_DIR/"
      echo "Done! EA installed to: $EXPERTS_DIR"
      echo "In MetaTrader 5: press F5 in Navigator to refresh."
    SH
    chmod 0755, bin/"kensan-ea"

    system bin/"kensan-ea"
  end

  def caveats
    <<~EOS
      If MetaTrader 5 was not installed yet, run after installing it:
        kensan-ea
    EOS
  end

  test do
    assert_predicate libexec/"kensan-mt-connector-v2.0.0.mq5", :exist?
  end
end
