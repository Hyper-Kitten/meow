module Models
  module Sluggable
    RSpec.shared_examples "a sluggable" do
      it "must have a slug" do
        expect(subject).to_not be_valid
      end
    end
  end
end
