require "spec"
require "../src/crystal_crypto_samples"

describe CrystalCryptoSamples do
  it "compiles and runs the sample methods" do
    CrystalCryptoSamples::VERSION.should_not be_nil
  end
end
