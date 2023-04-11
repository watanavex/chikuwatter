# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerChikuwatter do
    it "should be a plugin" do
      expect(Danger::DangerChikuwatter.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.chikuwatter

        # mock the PR data
        # you can then use this, eg. github.pr_author, later in the spec
        # json = File.read("#{File.dirname(__FILE__)}/support/fixtures/github_pr.json") # example json: `curl https://api.github.com/repos/danger/danger-plugin-template/pulls/18 > github_pr.json`
        # allow(@my_plugin.github).to receive(:pr_json).and_return(json)
      end

      # Some examples for writing tests
      # You should replace these with your own.

      it "Errors on file not found" do
        @my_plugin.report "no file"
        expect(@dangerfile.status_report[:errors]).to eq(["analyze log file not found"])
      end

      it "Report" do
        file_path = "#{File.dirname(__FILE__)}/fixtures/analyze.log"
        @my_plugin.inline_mode = true
        @my_plugin.report file_path
        expect(@dangerfile.status_report[:warnings]).to eq(["warning • invalid_null_aware_operator: The receiver can't be null, so the null-aware operator '?.' is unnecessary", "info • deprecated_member_use: 'headline1' is deprecated and shouldn't be used. Use displayLarge instead. This feature was deprecated after v3.1.0-0.0.pre"])
        expect(@dangerfile.status_report[:errors]).to eq(["error • argument_type_not_assignable: The argument type 'String?' can't be assigned to the parameter type 'String'"])
      end
    end
  end
end
