local helper = require("misclib.test.helper")

describe("logger", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can output to file", function()
    local output, file, file_path = require("misclib.logger.file").output("test.log", helper.test_data.full_path)
    local logger = require("misclib.logger").new(output)
    logger:info("test")

    file:flush()

    local f = io.open(file_path, "r")
    local content = f:read("*a")
    assert.equal("[INFO] test\n", content)
  end)
end)
