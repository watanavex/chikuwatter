# frozen_string_literal: true

module Danger
  # Lint markdown files inside your projects.
  # This is done using the [proselint](http://proselint.com) python egg.
  # Results are passed out as a table in markdown.
  #
  # @example Output analyze results with inline comments
  #
  #          (You must run `flutter analyze` before using this plugin.)
  #          ($ flutter analize > result.log)
  #
  #          chikuwatter.inline_mode = true
  #          chikuwatter.report = result.log
  #
  class DangerChikuwatter < Plugin
    attr_accessor :project_root, :inline_mode, :analyze_log, :riverpod_lint_log

    # Project root directory
    def _project_root
      root = @project_root || Dir.pwd
      root += "/" unless root.end_with? "/"
      root
    end

    # Inline mode
    def _inline_mode
      @inline_mode || false
    end

    # Analyze log file path
    def _analyze_log
      @analyze_log
    end

    # Riverpod lint log file path
    def _riverpod_lint_log
      @riverpod_lint_log
    end

    # Report analyze results
    def report
      results = []
      if !_analyze_log && !_riverpod_lint_log
        fail "You must set report file path."
      end

      if _analyze_log
        if File.exist?(_analyze_log)
          results += parse_analyze_log(_analyze_log)
        else
          fail "File not found: #{_analyze_log}"
        end
      end

      if _riverpod_lint_log
        if File.exist?(_riverpod_lint_log)
          results += parse_riverpod_lint_log(_riverpod_lint_log)
        else
          fail "File not found: #{_riverpod_lint_log}"
        end
      end

      send_reports(results)
    end

    # Output level
    module Type
      INFO = "info"
      WARN = "warning"
      ERROR = "error"

      def self.from_string(str)
        case str.downcase
        when INFO then INFO
        when WARN then WARN
        when ERROR then ERROR
        else
          raise ArgumentError, "Invalid type: #{str}"
        end
      end
    end

    # Report data
    class ReportData
      attr_accessor :message, :type, :file, :line

      def initialize(message, type, file, line)
        self.message = message
        self.type = type
        self.file = file
        self.line = line
      end
    end

    # Parse analyze log
    def parse_analyze_log(file_path)
      _project_root = Dir.pwd
      report_data = []
      File.foreach(file_path) do |line|
        logs = line.split("•")
        if logs.length < 4
          next
        end

        type_str = logs[0].strip!
        type = Type.from_string(type_str)
        file, line_num = logs[2].strip!.split(":")

        message = "#{type_str} • `#{logs[3].strip!}`\n#{logs[1].strip!}"

        report_data.push(
          ReportData.new(message, type, file, line_num.to_i)
        )
      end

      return report_data
    end

    # Parse riverpod_lint log
    def parse_riverpod_lint_log(file_path)
      _project_root = Dir.pwd
      report_data = []
      File.foreach(file_path) do |line|
        logs = line.split("•")
        # lib/presentation/screens/favorite_contents/favorite_contents_screen_view_model.dart:135:20 • Generated providers should only depend on other generated providers. Failing to do so may break rules such as "provider_dependencies". • avoid_manual_providers_as_generated_provider_dependency
        if logs.length < 3
          next
        end

        file, line_num = logs[0].strip!.split(":")
        message = "riverpod_lint • `#{logs[2].strip!}`\n#{logs[1].strip!}"

        report_data.push(
          ReportData.new(message, Type::WARN, file, line_num.to_i)
        )
      end

      return report_data
    end

    # Send analyze results
    def send_reports(results)
      results.each do |data|
        case data.type
        when Type::INFO
          if _inline_mode
            warn(data.message, file: data.file, line: data.line)
          else
            warn(data.message)
          end
        when Type::WARN
          if _inline_mode
            warn(data.message, file: data.file, line: data.line)
          else
            warn(data.message)
          end
        when Type::ERROR
          if _inline_mode
            failure(data.message, file: data.file, line: data.line)
          else
            failure(data.message)
          end
        end
      end
    end
  end
end
