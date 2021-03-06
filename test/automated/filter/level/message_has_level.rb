require_relative '../../automated_init'

context "Log" do
  context "Filter" do
    context "Level" do
      context "Message Has a Level" do
        context "Logger's Level Isn't Set" do
          logger = Log::Controls::Log::Levels.example

          refute(logger.level?)

          message = SecureRandom.hex

          logger.(message, logger.level_names.first)

          sink = logger.telemetry_sink

          test "Doesn't log the message" do
            logged = sink.recorded_logged? do |record|
              record.data.message == message
            end

            refute(logged)
          end
        end

        context "Logger's Level Is Set to the Message's Level" do
          logger = Log::Controls::Log::Levels.example

          logger.level = logger.level_names.first

          message = SecureRandom.hex

          logger.(message, logger.level_names.first)

          sink = logger.telemetry_sink

          test "Logs the message" do
            logged = sink.recorded_logged? do |record|
              record.data.message == message
            end

            assert(logged)
          end
        end
      end
    end
  end
end
