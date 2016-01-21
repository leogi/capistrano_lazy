require "spec_helper"

RSpec.describe CapistranoLazy::TemplateRenderer do
  let (:source_file) { "./spec/fixtures/deploy.rb.erb" }
  let (:destination_file) { "./spec/config/deploy.rb" }
  let (:options) {
    {
      application: "capistrano_lazy",
      repo_url: "https://bitbucket.org/nghialv/capistrano_lazy",
      deploy_directory: "/var/www/capistrano_lazy"
    }
  }
  let (:renderer) { 
    CapistranoLazy::TemplateRenderer.new source_file, options
  }

  describe "#initialize" do
    subject { renderer }

    it { expect(renderer.template).to eq File.open(source_file).read }
    it { expect(renderer.instance_variable_get(:@application)).to eq "capistrano_lazy" }
    it { 
      expect(renderer.instance_variable_get(:@repo_url))
        .to eq "https://bitbucket.org/nghialv/capistrano_lazy"
    }
    it { 
      expect(renderer.instance_variable_get(:@deploy_directory))
        .to eq "/var/www/capistrano_lazy"
    }
  end

  describe "#render" do
    subject { renderer.render }

    it { expect(subject.include?("capistrano_lazy")).to eq true }
    it { expect(subject.include?("https://bitbucket.org/nghialv/capistrano_lazy")).to eq true }
    it { expect(subject.include?("/var/www/capistrano_lazy")).to eq true }
  end

  describe "#export" do
    before { renderer.export destination_file }
    after { FileUtils.rm_rf "./spec/config" }

    it { expect(File.exist?(destination_file)).to eq true }
  end

  describe "#load" do
    subject { renderer.send(:load, source_file) }

    it { expect(subject).to eq File.open(source_file).read }
  end

  describe "#prepare_dir" do
    before { renderer.send(:prepare_dir, destination_file) }
    after { FileUtils.rm_rf "./spec/config" }
    
    it { expect(File.directory? "./spec/config").to eq true }
  end
end