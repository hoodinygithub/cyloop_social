module PopupHelper

  class Popup < BlockHelpers::Base

    def initialize(html_id)
      @html_id = html_id
    end

    def display(body)
      %(
      <div class="popup" id="#{@html_id}">
          <div class="top_shadow">
              <div class="top_left corner"></div>
              <div class="center_shadow"></div>
              <div class="top_right corner"></div>
              <a href="#"><img src="/images/popup_close.png" class="popup_close png_fix" alt="X" title="Close" /></a>
          </div>
          <div class="popup_content">
            #{body}
          </div>
          <div class="bottom_shadow">
              <div class="bottom_left corner"></div>
              <div class="center_shadow"></div>
              <div class="bottom_right corner"></div>
          </div>
      </div>
      )
    end

  end

end
