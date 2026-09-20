require "spec"
require "../src/crystal_crypto_samples"

describe CrystalCryptoSamples do
  it "defines VERSION" do
    CrystalCryptoSamples::VERSION.should eq("0.1.1")
  end

  it "executes run_samples without errors" do
    CrystalCryptoSamples.run_samples
  end
end
