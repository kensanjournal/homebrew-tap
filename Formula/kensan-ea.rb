class KensanEa < Formula
  desc "Kensan EA connector for MetaTrader 5"
  homepage "https://kensanjournal.com"
  url "https://github.com/kensanjournal/homebrew-tap/releases/download/v2.1.0/kensan-ea-2.1.0.tar.gz"
  sha256 "fdbbcae7466d0760e4b2ed3acf1855342149f6b0104fbc7b8a2348ce28597c16"
  version "2.1.0"
  license "Proprietary"

  def install
    libexec.install "kensan-mt-connector-v2.1.0.ex5"

    (bin/"kensan-ea").write <<~SH
      #!/bin/bash
      EA_FILE="#{libexec}/kensan-mt-connector-v2.1.0.ex5"
      EXPERTS_DIR=""
      CANDIDATES=(
        "$HOME/Library/Application Support/net.metaquotes.wine.metatrader5/drive_c/Program Files/MetaTrader 5/MQL5/Experts"
        "$HOME/Library/Containers/com.metaquotes.metatrader5/Data/Library/Application Support/MetaTrader 5/MQL5/Experts"
        "$HOME/Library/Application Support/MetaTrader 5/MQL5/Experts"
        "$HOME/Library/Application Support/net.metaquotes.metatrader5/MQL5/Experts"
      )

      for p in "${CANDIDATES[@]}"; do
        if [ -d "$p" ]; then
          EXPERTS_DIR="$p"
          break
        fi
      done

      if [ -z "$EXPERTS_DIR" ]; then
        EXPERTS_DIR=$(find "$HOME/Library" -name "Experts" -type d 2>/dev/null | grep -Ev ".Trash|Recycle" | head -1)
      fi

      if [ -z "$EXPERTS_DIR" ]; then
        echo "MetaTrader 5 not found."
        echo "Install MT5: metatrader5.com/en/download, then run: kensan-ea"
        exit 1
      fi

      cp "$EA_FILE" "$EXPERTS_DIR/"
      echo "Done! Installed to: $EXPERTS_DIR"
      echo "In MetaTrader 5: press F5 in Navigator to refresh."
    SH
    chmod 0755, bin/"kensan-ea"
  end

  def caveats
    <<~EOS
      Run to install the EA into MetaTrader 5:
        kensan-ea
    EOS
  end

  test do
    assert_predicate libexec/"kensan-mt-connector-v2.1.0.ex5", :exist?
  end
end
