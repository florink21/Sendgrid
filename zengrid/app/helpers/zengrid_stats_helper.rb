module ZengridStatsHelper

  def get_new_sla
    begin
      AuditEvent.support_sla(Time.now - 2.hour, barebones=1)[:new_sla_percentage]
    rescue
      -9
    end
  end

  def get_aging_sla
    myAgingSLA = Hash.new
    begin
      myAgingSLA = AuditEvent.support_sla(Time.now - 2.hour, barebones=1)
      returnSLA = myAgingSLA[:aging_sla_percentage]
    rescue
      returnSLA = -9
    end
    return returnSLA
  end

end
