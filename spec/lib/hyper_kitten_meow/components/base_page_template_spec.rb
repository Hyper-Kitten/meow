require "rails_helper"

RSpec.describe HyperKittenMeow::BasePageTemplate do
  describe ".content_blocks" do
    it "is empty for a template that registers none" do
      template = described_class.find_template("BlocklessTestTemplate")

      expect(template.content_blocks).to eq([])
    end

    it "is the registered blocks otherwise" do
      template = described_class.find_template("TestTemplate")

      expect(template.content_blocks).to eq([:test_block, :test_block_two])
    end
  end

  describe ".all_templates_and_blocks" do
    it "includes templates that register no content blocks" do
      expect(described_class.all_templates_and_blocks)
        .to include("BlocklessTestTemplate" => {"blocksInfo" => []})
    end
  end
end
