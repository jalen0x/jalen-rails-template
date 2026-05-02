module TestSupport
  module WithClues
    def with_clues(&block)
      block.call
    rescue Minitest::Assertion, StandardError => error
      puts "[ with_clues ] Test failed: #{error.message}"
      dump_browser_logs
      dump_page_html
      raise
    end

    private

    def dump_browser_logs
      unless respond_to?(:page) && page.driver.respond_to?(:browser)
        puts "[ with_clues ] NO BROWSER LOGS: page driver has no browser"
        return
      end

      browser = page.driver.browser
      unless browser.respond_to?(:logs)
        puts "[ with_clues ] NO BROWSER LOGS: #{browser.class} has no logs"
        return
      end

      puts "[ with_clues ] Browser Logs {"
      browser.logs.get(:browser).each { |log| puts log.message }
      puts "[ with_clues ] } END Browser Logs"
    rescue StandardError => error
      puts "[ with_clues ] Browser logs unavailable: #{error.class}: #{error.message}"
    end

    def dump_page_html
      return unless respond_to?(:page)

      puts "[ with_clues ] HTML {"
      puts
      puts page.html
      puts
      puts "[ with_clues ] } END HTML"
    rescue StandardError => error
      puts "[ with_clues ] HTML unavailable: #{error.class}: #{error.message}"
    end
  end
end
