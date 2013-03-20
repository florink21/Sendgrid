class WlValidateController < ApplicationController
  require 'wlvalidate'

  def index

  end

  def show
    dns_method = 2

    if !params[:dns_method]
      dns_method = 2
    else
      case params[:dns_method]
        when "Local"
          dns_method = 1
        when "Authorative"
          dns_method = 2
        else
          dns_method = 2
      end
    end

    puts params[:dns_method]

    if params[:validate].first[0] == "domain"
      strDomain = params[:validate].first[1]
      if strDomain.count(".") >= 2
        arrBits = strDomain.split(".",2)
        strValidator = WLValidate::Validate.new('',dns_method)
        varCNAME = strValidator.CNAME(arrBits[0], arrBits[1])
        varSPF = strValidator.SPF(arrBits[0], arrBits[1])
        varDKIM1 = strValidator.DKIM1(arrBits[0], arrBits[1])
        varDKIM2 = strValidator.DKIM2(arrBits[0], arrBits[1])
        varA = strValidator.A(arrBits[0], arrBits[1])
        varMX = strValidator.MX(arrBits[0], arrBits[1])
        varINFO = strValidator.get_info()

        @resAPass = "PASS"
        @resAList = Array.new
        @resInfo = Array.new
        @resMXList = Array.new

        @resAListReason = Array.new
        @resCNAMEReason = Array.new
        @resSPFReason = Array.new
        @resDKIM1Reason = Array.new
        @resDKIM2Reason = Array.new

        varA.each {|a|
          puts a
          if a["result"] != "PASS"
            @resAPass = "FAIL"
            tmpFStr = "No record for IP"
            @resAList.push(tmpFStr)
            @resAListReason = "Either there are no IPs for this account, or reverse DNS data is set incorrectly"
          else
            tmpPStr = a["ext_data"] + " => " + a["data"]
            @resAList.push(tmpPStr)
          end
        }

        varMX.each {|m|
           tmpMX = m["data"] + " (" + m["ext_data"] + ")"
           @resMXList.push(tmpMX)
        }           

        @resDomain = strDomain

        @resCNAME = varCNAME["result"]
        if @resCNAME == "FAIL"
          @resCNAMEReason.push varCNAME["ext_data"] + " - looking for " + varCNAME["data"]
        elsif @resCNAME == "ERROR"
          # Do nothing, for now...
        else #this should be "PASS"
          @resCNAMEReason.push "Host: " + varCNAME["data"]
          @resCNAMEReason.push "Aliased To: " + varCNAME["ext_data"]
        end

        @resSPF = varSPF["result"]
        if @resSPF == "FAIL"
          @resSPFReason.push varSPF["ext_data"]
        elsif @resSPF == "ERROR"
          # Do nothing, for now...
        else #this should be "PASS"
          @resSPFReason.push "Record Data: " + varSPF["data"]
          @resSPFReason.push "Policy: " + varSPF["ext_data"]
        end

        @resDKIM1 = varDKIM1["result"]
        if @resDKIM1 == "FAIL"
          @resDKIM1Reason.push varDKIM1["ext_data"]
        elsif @resDKIM1 == "ERROR"
          # Do nothing, for now...
        else #this should be "PASS"
          @resDKIM1Reason.push "Record Type: " + varDKIM1["ext_data"]
          @resDKIM1Reason.push "Data: " + varDKIM1["rdata"]
        end

        @resDKIM2 = varDKIM2["result"]
        if @resDKIM2 == "FAIL"
          @resDKIM2Reason.push varDKIM2["ext_data"]
        elsif @resDKIM2 == "ERROR"
          # Do nothing, for now...
        else #this should be "PASS"
          @resDKIM2Reason.push "Record Type: " + varDKIM2["ext_data"]
          @resDKIM2Reason.push "Data: " + varDKIM2["rdata"]
        end

        varINFO.each {|k,v|
          case k
            when "dns_server"
              @resInfo.push "DNS Server: " + v
            when "dns_type"
              case v
                when 1
                  @resInfo.push "DNS Server Query Type: " + v.to_s + " (local server)"
                when 2
                  @resInfo.push "DNS Server Query Type: " + v.to_s + " (authorative server for the domain)"
            end
          end
        }
      else
        # We really should be doing validation before the data gets to us,
        # but I want to get this out NOW! v2 will have proper validation.
        render 'error.haml'
      end
    else
      render 'error.haml'
    end
  end

end
