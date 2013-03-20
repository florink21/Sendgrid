module DashboardHelper

  def post_wrapper(outage = 0)
    # Output the CSS style required
    case outage
      when 0
        tCSS = "status_box_info"
      when 1
        tCSS = "status_box_issue"
      else
        tCSS = "status_box_info"
    end
    return tCSS
  end

  def major_indicator(type = 1)
    # Output the major status indicator (image tag)
    case type
      when 1
        tImg = "assets/major_good.png"
      when 2
        tImg = "assets/major_warning.png"
      when 3
        tImg = "assets/major_critical.png"
      else
        tImg = "assets/major_good.png"
    end
    return tImg
  end

  def health_indicator(type = 1)
    # Output the Health indicator (image tag)
    case type
      when 1
        tImg = "assets/health_container_good.png"
      when 2
        tImg = "assets/health_container_warning.png"
      when 3
        tImg = "assets/health_container_critical.png"
      else
        tImg = "assets/health_container_good.png"
    end
    return tImg
  end

end
