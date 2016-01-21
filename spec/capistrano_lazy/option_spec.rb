require "spec_helper"

RSpec.describe CapistranoLazy::Option do
  describe ".load" do
    let (:filepath) { File.expand_path("../../fixtures/sample.yml", __FILE__) }

    subject { CapistranoLazy::Option.load filepath }

    it { expect(subject).to be_a CapistranoLazy::Option }
    it { expect(subject.environment).to eq "production" }
    it { expect(subject.application).to eq "capistrano_lazy" }
    it { expect(subject.deploy.directory).to eq "/var/www/capistrano_lazy" }
    it { expect(subject.deploy.hosts).to eq ["localhost"] }
    it { expect(subject.nginx.domains).to eq nil }
  end

  describe ".parse" do
    let (:hash) { nil }

    subject { CapistranoLazy::Option.parse hash }

    context "argument isn't hash" do
      let (:hash) { "test" }
      it { expect(subject).to eq "test" }
    end

    context "argument is hash" do
      context "argument is simple hash" do
        let (:hash) do
          {
            key1: nil,
            key2: 1,
            key3: [],
            key4: [1,2,3],
            key5: "string",
            key6: true,
            key7: {}
          }
        end
        
        it { expect(subject).to be_a CapistranoLazy::Option }
        it { expect(subject.key1).to eq nil }
        it { expect(subject.key2).to eq 1 }
        it { expect(subject.key3).to eq [] }
        it { expect(subject.key4).to eq [1,2,3] }
        it { expect(subject.key5).to eq "string" }
        it { expect(subject.key6).to eq true }
        it { expect(subject.key7).to be_a CapistranoLazy::Option }
        it { expect(subject.key7.to_h).to eq({}) }
      end

      context "argument is nested hash" do
        let (:hash) do
          {
            key2: {
              key21: nil,
              key22: [1, 2, {key221: "test"}],
              },
          }
        end

        it { expect(subject).to be_a CapistranoLazy::Option }
        it { expect(subject.key2).to be_a CapistranoLazy::Option }
        it { expect(subject.key2.key21).to eq nil }
        it { expect(subject.key2.key22).to be_a Array }
        it { expect(subject.key2.key22[2]).to be_a CapistranoLazy::Option }
        it { expect(subject.key2.key22[2].key221).to eq "test" }
      end

      context "argument is deep nested hash" do
        let (:hash) do
          {
            key1: {
              key2: {
                key3: {
                  key4: {
                    key5: {
                      key6: nil
                    }
                  }
                }
              }
            }
          }
        end

        it { expect(subject).to be_a CapistranoLazy::Option }
        it { expect(subject.key1.key2.key3.key4.key5.key6).to eq nil }
      end
    end
  end
end