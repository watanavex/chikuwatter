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

      it "Errors on analyze file not found" do
        @my_plugin.analyze_log = "no file"
        @my_plugin.report
        expect(@dangerfile.status_report[:errors]).to eq(["File not found: no file"])
      end

      it "Errors on riverpod_lint file not found" do
        @my_plugin.riverpod_lint_log = "no file"
        @my_plugin.report
        expect(@dangerfile.status_report[:errors]).to eq(["File not found: no file"])
      end

      it "Errors on missing parameters" do
        @my_plugin.report
        expect(@dangerfile.status_report[:errors]).to eq(["You must set report file path."])
      end

      it "Report Analyze results" do
        file_path = "#{File.dirname(__FILE__)}/fixtures/analyze.log"
        @my_plugin.inline_mode = true
        @my_plugin.analyze_log = file_path
        @my_plugin.report
        expect(@dangerfile.status_report[:warnings]).to eq(["warning • `invalid_null_aware_operator`\nThe receiver can't be null, so the null-aware operator '?.' is unnecessary", "info • `deprecated_member_use`\n'headline1' is deprecated and shouldn't be used. Use displayLarge instead. This feature was deprecated after v3.1.0-0.0.pre"])
        expect(@dangerfile.status_report[:errors]).to eq(["error • `argument_type_not_assignable`\nThe argument type 'String?' can't be assigned to the parameter type 'String'"])
      end

      it "Report Riverpod lint results" do
        file_path = "#{File.dirname(__FILE__)}/fixtures/riverpod_lint.log"
        @my_plugin.inline_mode = true
        @my_plugin.riverpod_lint_log = file_path
        @my_plugin.report
        expect(@dangerfile.status_report[:warnings]).to eq(["riverpod_lint • `avoid_manual_providers_as_generated_provider_dependency`\nGenerated providers should only depend on other generated providers. Failing to do so may break rules such as \"provider_dependencies\"."])
      end
    end
  end
end
