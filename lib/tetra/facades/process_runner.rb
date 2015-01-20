# encoding: UTF-8

module Tetra
  # runs programs in subprocesses
  module ProcessRunner
    include Logging

    # runs an external executable and returns its output as a string
    # raises ExecutionFailed if the exit status is not 0 (override with fail_on_error)
    # optionally echoes the executable's output/error to standard output/error
    def run(commandline, echo = false, fail_on_error = true)
      log.debug "running `#{commandline}`"

      out_recorder = echo ? RecordingIO.new(STDOUT) : RecordingIO.new
      err_recorder = echo ? RecordingIO.new(STDERR) : RecordingIO.new

      status = Open4.spawn(commandline, stdout: out_recorder, stderr: err_recorder, quiet: true).exitstatus

      log.debug "`#{commandline}` exited with status #{status}"

      if status != 0
        if fail_on_error
          log.error("`#{commandline}` failed, status #{status}")
          log.error("standard output follows")
          log.error(out_recorder.record)
          log.error("standard error follows")
          log.error(err_recorder.record)
          fail ExecutionFailed.new(commandline, status)
        end
      end

      out_recorder.record
    end

    # records bytes sent via "<<" for later use
    # optionally echoes to another IO object
    class RecordingIO
      attr_reader :record

      def initialize(io = nil)
        @io = io
        @record = ""
      end

      def <<(*args)
        if @io
          @io.<<(*args)
          @io.flush
        end
        @record.<<(*args)
      end
    end
  end

  # raised when a command returns a non-zero status
  class ExecutionFailed < Exception
    attr_reader :commandline
    attr_reader :status

    def initialize(commandline, status)
      @commandline = commandline
      @status = status
    end
  end
end
